class Video < ApplicationRecord
  belongs_to :series
  has_many :recipes, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :users, through: :charges
  has_many :video_likes, dependent: :destroy
  accepts_nested_attributes_for :recipes, allow_destroy: true
  mount_uploader :thumbnail, VideoThumbnailUploader
  acts_as_taggable_on :tags
  with_options presence: true do
    validates :title
    validates :video_url
    validates :introduction
    validates :commentary
    validates :video_order
    validates :thumbnail
    validates :series_id
  end

  def self.update_duplicate_video_order_some_series(series_id, crud_patarn, old_video_order, new_video_order)
    if crud_patarn == 'edit' && old_video_order < new_video_order
      Video.where('video_order > ?', old_video_order).where('video_order <= ?', new_video_order).where(series_id: series_id).find_each { |v| v.update(video_order: v.video_order - 1) }
    elsif crud_patarn == 'delete'
      Video.where('video_order > ?', old_video_order).where(series_id: series_id).find_each { |v| v.update(video_order: v.video_order - 1) }
    else
      Video.where('video_order >= ?', new_video_order).where(series_id: series_id).find_each { |v| v.update(video_order: v.video_order + 1) }
    end
  end

  def self.update_duplicate_video_order_another_series(new_series_id, old_series_id, old_video_order, new_video_order)
    Video.where('video_order > ?', old_video_order).where(series_id: old_series_id).find_each { |v| v.update(video_order: v.video_order - 1) }
    Video.where('video_order >= ?', new_video_order).where(series_id: new_series_id).find_each { |v| v.update(video_order: v.video_order + 1) }
  end

  def self.tag_count(tags)
    Video.tagged_with(tags, any: true).count(:all)
  end

  def like_user(user_id)
    video_likes.find_by(user_id: user_id)
  end

  def self.recommend(video_id) #python側へリクエスト送信
    begin
      uri = self.create_uri()
      req = self.create_api_request(uri)
      http = self.create_http(uri)
      req = self.create_requet_content(req, video_id)
      res = http.request(req)
      id_list = res.body.split(',')
      id_list =  Video.all.order(id: :desc).limit(8).pluck(:id) if id_list.length == 0
      Video.where(id: id_list).order(['field(id, ?)', id_list])
    rescue
      Video.where.not(id: video_id).order(id: :desc).limit(8)
    end
  end

  def self.create_uri()
    api_url = 'https://n8jtwk1ygc.execute-api.ap-northeast-1.amazonaws.com/dev/recommend'
    uri = URI.parse(api_url)
  end

  def self.create_api_request(uri)
    req = Net::HTTP::Post.new(uri.request_uri)
  end

  def self.create_http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

  def self.create_requet_content(req, video_id)
    req["Content-Type"] = "application/json"
    req.body = { "id" => video_id }.to_json
    req
  end
end

