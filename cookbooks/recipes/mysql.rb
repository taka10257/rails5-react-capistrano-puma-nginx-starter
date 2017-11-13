# MySQLインストール
package 'mysql-server'
package 'libmysqlclient-dev'

# MySQL権限設定
execute 'mysql permission' do
  command <<-EOL
    chown mysql:mysql /var/log/mysqld.log
    chown -R mysql:mysql /var/lib/mysql
  EOL
end

execute 'mysql auto start' do
  command '/lib/systemd/systemd-sysv-install enable mysql'
end

execute 'mysql restart' do
  command '/etc/init.d/mysql restart'
end
