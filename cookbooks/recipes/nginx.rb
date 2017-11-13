package 'nginx' do
  action :install
end

remote_file '/etc/nginx/nginx.conf' do
  source '../remote_files/nginx.conf'
end

remote_file '/etc/nginx/conf.d/app.conf' do
  source '../remote_files/app.conf'
end

execute 'nginx auto start' do
  command '/lib/systemd/systemd-sysv-install enable nginx'
end

execute 'nginx start' do
  command '/etc/init.d/nginx start'
end
