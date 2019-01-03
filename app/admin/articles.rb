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
    end
    f.actions
  end
end
