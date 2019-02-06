ActiveAdmin.register Chef do
  permit_params :name, :phonetic, :introduction, :biography, :chef_avatar

  index do
    column :id
    column :name
    column :phonetic
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :phonetic
      f.input :introduction
      f.input :biography
      f.input :chef_avatar
      f.input :tag_list, :input_html => { id: "genre-tags", value: nil }
      text_node '<div class="text-count">※記事を執筆するだけの場合は"記事専門"と入力してください。</div>'.html_safe
      f.input :registered_tag, as: :hidden, :input_html => { id: "registered_tag", value: nil } if controller.action_name == 'new'
      f.input :registered_tag, as: :hidden, :input_html => { id: "registered_tag", value: Chef.find(params[:id]).tag_list } if controller.action_name == 'edit'
      f.input :autocmplete_tag, as: :hidden, :input_html => { id: "autocomplete_tag", value: Chef.tags_on(:tags).map(&:name) }
      f.input :chef_crud_patarn, :input_html => { id: "chefCrudPatarn", value: "edit" }, as: :hidden if controller.action_name == 'edit'
    end
    f.actions
  end

  controller do
    def create
      @chef = Chef.new(chef_permit_params)
      if @chef.save
        @chef.tag_list = params_tag_list[:tag_list]
        @chef.save
        redirect_to admin_chefs_path
      else
        render :new
      end
    end

    def update
      @chef = Chef.find(params[:id])
      if @chef.update(chef_permit_params)
        @chef.tag_list = params_tag_list[:tag_list]
        @chef.save
        redirect_to admin_chefs_path
      else
        render :edit
      end
    end

    def destroy
      chef = Chef.find(params[:id])
      chef.destroy
      redirect_to admin_chefs_path
    end

    private

    def chef_permit_params
      params.require(:chef).permit(:name, :phonetic, :introduction, :biography, :chef_avatar)
    end

    def params_crud_patarn
      params.require(:chef).permit(:chef_crud_patarn)
    end

    def params_tag_list
      params.require(:chef).permit(:tag_list)
    end
  end
end
