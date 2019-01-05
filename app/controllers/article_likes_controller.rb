class ArticleLikesController < ApplicationController
  def create
    ArticleLike.create(user_id: current_user.id, article_id: params[:article_id])
    @article = Article.find(params[:article_id])
  end

  def destroy
    like = ArticleLike.find_by(user_id: current_user.id, article_id: params[:article_id])
    like.destroy
    @article = Article.find(params[:article_id])
  end
end
