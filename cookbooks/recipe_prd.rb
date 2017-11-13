include_recipe 'recipes/base'

remote_file '/var/www/template_web/shared/.env' do
  source './remote_files/production.env'
end

file '/var/www/template_web/shared/.env' do
  action :edit
  owner 'deploy'
  mode '600'
end
