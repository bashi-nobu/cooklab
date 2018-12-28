ActiveAdmin.register Video do
  index do
    column :id
    column :title
    column :video_order
    column :price
    column :like_count
    column :series
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :video_url
      f.input :introduction
      f.input :commentary
      f.input :series_id, as: :select, collection: Series.all.map { |s| [s.title, s.id, { "video-count" => Video.where(series_id: s.id).count }] }, :input_html => { id: "series_id" }
      f.input :video_order, as: :select, collection: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], :input_html => { id: "video_orders" }
      f.input :thumbnail
      f.input :price
      f.input :tag_list, :input_html => { id: "genre-tags", value: nil }
      f.input :registered_tag, as: :hidden, :input_html => { id: "registered_tag", value: Video.find(params[:id]).tag_list }
      f.input :autocmplete_tag, as: :hidden, :input_html => { id: "autocomplete_tag", value: Video.tags_on(:tags).map { |t| t.name } }
      f.input :video_crud_patarn, :input_html => { id: "videoCrudPatarn", value: "edit" }, as: :hidden if controller.action_name == 'edit'
    end
    f.actions
  end

  controller do
    before_action -> {
      video_order_duplicate_check(video_permit_params, params_crud_patarn[:video_crud_patarn])
    }, only: [:create, :update]

    def create
      video = Video.create(video_permit_params)
      video_order_over_count_check(video_permit_params)
      video.tag_list = params_tag_list[:tag_list]
      video.save
      redirect_to admin_videos_path
    end

    def update
      video = Video.find(params[:id])
      video.update(video_permit_params)
      video.tag_list = params_tag_list[:tag_list]
      video.save
      video_order_over_count_check(video_permit_params)
      redirect_to admin_videos_path
    end

    def destroy
      video = Video.find(params[:id])
      crud_patarn = 'delete'
      organize_video_order_of_delete_video_series(video, crud_patarn)
      video.destroy
      redirect_to admin_videos_path
    end

    private

    def video_permit_params
      params.require(:video).permit(:title, :video_url, :introduction, :commentary, :video_order, :thumbnail, :price, :like_count, :series_id)
    end

    def params_crud_patarn
      params.require(:video).permit(:video_crud_patarn)
    end

    def params_tag_list
      params.require(:video).permit(:tag_list)
    end

    def video_order_duplicate_check(video_permit_params, crud_patarn)
      old_series_id = Video.find(params[:id]).series_id if crud_patarn == 'edit'
      new_series_id = video_permit_params[:series_id]
      new_video_order = video_permit_params[:video_order].to_i
      old_video_order = Video.find(params[:id]).video_order if crud_patarn == 'edit'
      duplicate_check = Video.where(video_order: new_video_order).where(series_id: new_series_id)
      if old_series_id == new_series_id
        Video.update_duplicate_video_order_some_series(new_seriesId, crud_patarn, old_video_order, new_video_order) if duplicate_check.present?
      else
        Video.update_duplicate_video_order_another_series(new_series_id, old_series_id, old_video_order, new_video_order)
      end
    end

    def organize_video_order_of_delete_video_series(video, crud_patarn)
      old_video_order = video.video_order
      series_id = video.series
      Video.update_duplicate_video_order_some_series(series_id, crud_patarn, old_video_order, 0)
    end

    def video_order_over_count_check(video_permit_params)
      video_id = params[:id]
      new_series_id = video_permit_params[:series_id]
      new_video_order = video_permit_params[:video_order].to_i
      total_video_count = Video.where(series_id: new_series_id).count
      Video.find(video_id).update(video_order: total_video_count) if total_video_count < new_video_order
    end
  end
end
