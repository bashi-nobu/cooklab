module MetaTaggable
  extend ActiveSupport::Concern

  include ActionView::Helpers::AssetUrlHelper

  included do
    before_action :prepare_meta_tags
  end

  private

  def prepare_meta_tags(options = {})
    base = t('meta_tags.base')

    site = base[:site]
    description = base[:description]
    title = t("meta_tags.titles.#{controller_name}.#{action_name}", default: '')
    image = image_url('image.png')

    defaults = {
      site: site,
      title: base[:title],
      description: description,
      keywords: base[:keywords],
      og: {
        url: request.url,
        title: title,
        description: description,
        site_name: site,
        type: 'website',
        # image: image,
        locale: 'ja_JP',
      },
      # twitter: {
      #   card: 'summary',
      #   site: '@simpliejp',
      #   title: title.presence || site,
      #   description: description,
      #   image: image
      # }
    }

    options.reverse_merge!(defaults)

    set_meta_tags(options)
  end
end