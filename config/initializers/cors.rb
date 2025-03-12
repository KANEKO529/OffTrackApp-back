Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://3994-2400-2200-532-b398-2d17-a454-72f6-54ef.ngrok-free.app"#frontend
    resource '/api/*',
      headers: :any,
      # expose: ['Authorization', 'Content-Type'],
      expose: ['ngrok-skip-browser-warning'],
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
      # credentials: true
  end
end
