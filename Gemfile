source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.7"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.0"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4", group: [:development, :test, :production]  # 開発環境では SQLite3 を使用

# Webサーバー
gem "puma", "~> 6.0", group: [:development, :test]  # 開発環境では Puma を使用
# 本番環境のみ Unicorn を使用
group :production do
  gem "unicorn"
end
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

gem "geocoder", "~> 1.8"

gem "activerecord-import", "~> 2.1"

gem 'sprockets-rails'

gem "google-apis-sheets_v4"

# gem 'rb-readline'

gem "dotenv-rails"

# gem 'pry'

# gem 'pry-rails'


