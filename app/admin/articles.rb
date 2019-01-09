ActiveAdmin.register Article do
  permit_params :title, :contents, :thumbnail

  index do
    column :id
    column :title
    column :like_count
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :contents, :input_html => { id: "article-contents" }
      text_node '<div class="text-count">入力文字数：<span id="text-count">0</span>文字(推奨2000文字)</div>'.html_safe
      f.input :thumbnail
      f.input :tag_list, :input_html => { id: "genre-tags", value: nil }
      f.input :registered_tag, as: :hidden, :input_html => { id: "registered_tag", value: nil } if controller.action_name == 'new'
      f.input :registered_tag, as: :hidden, :input_html => { id: "registered_tag", value: Article.find(params[:id]).tag_list } if controller.action_name == 'edit'
      f.input :autocmplete_tag, as: :hidden, :input_html => { id: "autocomplete_tag", value: Article.tags_on(:tags).map(&:name) }
    end
    f.actions
  end

  controller do
    def create
      article = Article.create(article_permit_params)
      article.tag_list = params_tag_list[:tag_list]
      article.save
      redirect_to admin_articles_path
    end

    def update
      article = Article.find(params[:id])
      article.update(article_permit_params)
      article.tag_list = params_tag_list[:tag_list]
      article.save
      redirect_to admin_articles_path
    end

    def destroy
      article = Article.find(params[:id])
      article.destroy
      redirect_to admin_articles_path
    end

    private

    def article_permit_params
      params.require(:article).permit(:title, :contents, :thumbnail)
    end

    def params_tag_list
      params.require(:article).permit(:tag_list)
    end
  end
end