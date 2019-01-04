module ArticleHelper
  def all_article_count_for_index_page(total_count_execpt_newest)
    total_count_execpt_newest + 1
  end
end
