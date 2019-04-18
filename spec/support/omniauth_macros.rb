module OmniauthMacros
  def facebook_mock
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      {
        provider: 'facebook',
        uid: '12345',
        info: {
          name: 'mockuser',
          email: 'sample@test.com'
        },
        extra: {
          raw_info: 'hjhjkkjk'
        },
        credentials: {
          token: 'hogefuga'
        }
      }
    )
  end
  def twitter_mock
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      {
        provider: 'twitter',
        uid: '123456',
        info: {
          name: 'mockuser2',
          email: 'sample2@test.com'
        },
        extra: {
          raw_info: 'hjhjkkjadk'
        },
        credentials: {
          token: 'hogefugahoga'
        }
      }
    )
  end
end