user 'deploy' do
  action :create
  username 'deploy'
  create_home true
end

execute 'set password' do
  command 'echo "deploy:deploy" | chpasswd'
end

execute 'set group' do
  command 'usermod -aG root deploy'
end

execute 'set sudoers' do
  command 'echo "deploy ALL=NOPASSWD: ALL" >> /etc/sudoers'
end

directory '/home/deploy/.ssh' do
  action :create
  owner 'deploy'
  mode '770'
end

remote_file '/home/deploy/.ssh/id_rsa' do
  source '../remote_files/id_rsa'
end

file '/home/deploy/.ssh/id_rsa' do
  action :edit
  owner 'deploy'
  mode '600'
end

execute 'ssh-add' do
  command 'su deploy'
  command 'eval `ssh-agent`'
  command 'ssh-add /home/deploy/.ssh/id_rsa'
  command 'exit'
end
