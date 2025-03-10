# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

# デプロイするアプリケーション名
set :application, "offtrackapp"

# cloneするRails の GitHub リポジトリ
set :repo_url, "git@github.com:KANEKO529/OffTrackApp-back.git"
# deployするブランチ。デフォルトはmasterなのでなくても可。
set :branch, 'master'

# React の GitHub リポジトリ
set :frontend_repo_url, "git@github.com:KANEKO529/OffTrackApp-front.git"
set :frontend_branch, 'master'  # フロントのブランチ名

# Rails のデプロイ先
set :deploy_to, '/var/www/offtrackapp/backend'

# React のデプロイ先を追加
set :frontend_deploy_to, '/var/www/offtrackapp/frontend'

# シンボリックリンクをはるファイル
set :linked_files, fetch(:linked_files, []).push('config/master.key')

# シンボリックリンクをはるフォルダ
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# 保持するバージョンの個数(※後述)
set :keep_releases, 5

# rubyのバージョン
# rbenvで設定したサーバー側のrubyのバージョン
set :rbenv_ruby, '3.3.4'

# 出力するログのレベル。
set :log_level, :debug

# Railsのデプロイ処理　（タスク）
namespace :deploy do

  # unicornの再起動
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'# ここUnicorn(Railsアプリのアプリケーションサーバを再起動)
  end


  #rails db:migrate をリモートサーバー上で実行→DBのスキーマを最新に更新
  desc 'Run database migrations'
  task :migrate do
    on roles(:db) do
      within release_path do
        execute :bundle, :exec, :rails, 'db:migrate'
      end
    end
  end

  # rails assets:precompile をリモートサーバー上で実行→CSS・JS などの静的ファイルを事前にコンパイル
  # assets:precompile がないと、 Rails のフロント（ビュー）に必要な CSS や JS が正しく表示されない。
  desc 'Precompile assets'
  task :precompile_assets do
    on roles(:app) do
      within release_path do
        execute :bundle, :exec, :rails, 'assets:precompile'
      end
    end
  end

  # deploy:publishing（Capistrano が新しいバージョンを公開する処理）の 前に
  # データベースのマイグレーションおよびアセットのプリコンパイル を実行するように設定
  before 'deploy:publishing', 'deploy:migrate'
  before 'deploy:publishing', 'deploy:precompile_assets'

  after :publishing, :restart#デプロイが完了したら、restartを実行

  # キャッシュをクリア
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end

#React フロントエンドのデプロイ処理
namespace :deploy do
  desc 'Deploy React frontend'
  task :deploy_frontend do
    on roles(:app) do
      within release_path do
        execute "rm -rf #{fetch(:frontend_deploy_to)}"
        execute "git clone -b #{fetch(:frontend_branch)} #{fetch(:frontend_repo_url)} #{fetch(:frontend_deploy_to)}"
        execute "cd #{fetch(:frontend_deploy_to)} && npm install && npm run build"
      end
    end
  end

  after :finishing, :deploy_frontend
end