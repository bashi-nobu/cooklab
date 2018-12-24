ActiveAdmin.register Video do
  permit_params :title, :video_url, :introduction, :commentary, :video_order, :thumbnail, :price, :like_count, :series
end
