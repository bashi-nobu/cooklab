Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins 'https://googleads.g.doubleclick.net'
    origins "*"
    resource '*',
      headers: :any,
      methods: %i(get options head)
  end
end