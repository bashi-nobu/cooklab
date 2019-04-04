require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'dsasdsad',
      aws_secret_access_key: 'ggajsas',
      region: 'ap-northeast-1'
    }

    config.fog_directory = 'cooklab'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/cooklab'
  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end
