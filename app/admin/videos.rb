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
      f.input :series_id, as: :select, collection: Series.all.map { |s| [ s.title, s.id, { "video-count" => Video.where(series_id: s.id).count } ] }, :input_html => { id: "series_id" }
      f.input :video_order, as: :select, collection: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], :input_html => { id: "video_orders" }
      f.input :thumbnail
      f.input :price
      f.input :videoCrudPatarn, :input_html => { id: "videoCrudPatarn" , value: "edit" }, as: :hidden if controller.action_name == 'edit'
      f.input :id, as: :hidden if controller.action_name == 'edit'
    end
    f.actions
  end

  controller do

    def create
      videoOrderDuplicateCheck(video_permit_params, params_crudPatarn[:videoCrudPatarn])
      Video.create(video_permit_params)
      videoOrderOverCountCheck(video_permit_params)
      redirect_to admin_videos_path
    end

    def update
      videoOrderDuplicateCheck(video_permit_params, params_crudPatarn[:videoCrudPatarn])
      Video.update(video_permit_params)
      videoOrderOverCountCheck(video_permit_params)
      redirect_to admin_videos_path
    end

    private
    def video_permit_params
      params.require(:video).permit(:id, :title, :video_url, :introduction, :commentary, :video_order, :thumbnail, :price, :like_count, :series_id)
    end

    def params_crudPatarn
      params.require(:video).permit(:videoCrudPatarn)
    end

    def videoOrderDuplicateCheck(video_permit_params, crudPatarn)
      oldSeriesId = Video.find(video_permit_params[:id]).series_id if crudPatarn == 'edit'
      newSeriesId = video_permit_params[:series_id]
      newVideoOrder = video_permit_params[:video_order].to_i
      oldVideoOrder = Video.find(video_permit_params[:id]).video_order if crudPatarn == 'edit'
      duplicate_check = Video.where(video_order: newVideoOrder).where(series_id: newSeriesId)
      if oldSeriesId == newSeriesId
        Video.updateDuplicateVideoOrderSomeSeries(newSeriesId, crudPatarn, oldVideoOrder, newVideoOrder) if duplicate_check.present?
      else
        Video.updateDuplicateVideoOrderAnotherSeries(newSeriesId, oldSeriesId, oldVideoOrder, newVideoOrder)
      end
    end

    def videoOrderOverCountCheck(video_permit_params)
      videoId = video_permit_params[:id]
      newSeriesId = video_permit_params[:series_id]
      newVideoOrder = video_permit_params[:video_order].to_i
      totalVideoCount = Video.where(series_id: newSeriesId).count
      Video.find(videoId).update(video_order: totalVideoCount) if totalVideoCount < newVideoOrder
    end
  end
end
