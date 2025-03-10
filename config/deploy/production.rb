# conohaのサーバーのIP、ログインするユーザー名、サーバーの役割
# xxxの部分はサーバーのIPアドレス
# 10022はポートを変更している場合。通常は22
server '160.251.212.202', user: 'kaneko', roles: %w{app db web}, port: 10022 

#デプロイするサーバーにsshログインする鍵の情報。サーバー編で作成した鍵のパス
set :ssh_options, keys: '~/.ssh/conoha_hoge/id_rsa'
