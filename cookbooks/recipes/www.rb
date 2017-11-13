directory '/var/www/template_web/shared/config' do
  action :create
  owner 'deploy'
  mode '770'
end

execute 'permission' do
  command 'chown -R deploy /var/www'
  command 'chmod 770 -R /var/www'
end
