# Capistrano staging config
set :stage, :production
set :rails_env, :production
set :branch, :production

set :deploy_to, '/var/www/rails/cashbox.metastudiohq.com'

set :rvm_type, :system
set :rvm_ruby_version, 'ruby-2.1.1@cashbox'

server 'metastudio.ru', user: 'admin', roles: %w{web app db worker}
