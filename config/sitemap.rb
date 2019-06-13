# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://cook-lab.net" 
SitemapGenerator::Sitemap.sitemaps_path = 'shared/'
SitemapGenerator::Sitemap.create do
  add root_path            # root_pathをsitemapに追加する

  # 各投稿をsitemapに追加する
  # Video.find_each do |video|
  #   add video_path(video), priority: 1.0, lastmod: video.updated_at, changefreq: 'weekly'
  # end
  # Article.find_each do |article|
  #   add article_path(article), priority: 1.0, lastmod: article.updated_at, changefreq: 'weekly'
  # end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
