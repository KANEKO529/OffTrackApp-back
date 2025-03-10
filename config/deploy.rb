# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

# デプロイするアプリケーション名
set :application, "offtrackapp"

# cloneするgitのレポジトリ リモートリポジトリのurl
set :repo_url, "git@github.com:KANEKO529/OffTrackApp-back.git"

# deployするブランチ。デフォルトはmasterなのでなくても可。
set :branch, 'master'

# deploy先のディレクトリ。
set :deploy_to, '/var/www/offtrackapp/backend'

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

# デプロイのタスク
namespace :deploy do

  # unicornの再起動
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end