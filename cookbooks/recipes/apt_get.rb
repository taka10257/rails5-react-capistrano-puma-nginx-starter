execute 'apt-get update' do
  command 'apt-get update -y'
end

package 'sudo' do
  action :install
end

package 'vim' do
  action :install
end

package 'nodejs' do
  action :install
end

package 'monit' do
  action :install
end

package 'build-essential' do
  action :install
end
