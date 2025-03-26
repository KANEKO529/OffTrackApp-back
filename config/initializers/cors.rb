Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://f25b-125-15-25-100.ngrok-free.app"#frontend
    resource '/api/*',
      headers: :any,
      # expose: ['Authorization', 'Content-Type'],
      expose: ['ngrok-skip-browser-warning'],
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
      # credentials: true
  end
end
