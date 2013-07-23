#!/bin/sh

if [ -e "/home/vagrant/.provisioned" ]; then
	exit
fi

sudo apt-get update
sudo apt-get -y install build-essential nodejs
sudo apt-get -y install postgresql-9.1 libpq-dev
sudo su postgres -c "pg_dropcluster --stop 9.1 main ; pg_createcluster --start --locale en_US.UTF-8 9.1 main"
sudo su postgres -c "createuser -s -d vagrant"
sudo /etc/init.d/postgresql restart
sudo apt-get -y install libyaml-dev curl

sudo su vagrant -c "curl -L https://get.rvm.io | bash -s stable; 
source /home/vagrant/.rvm/scripts/rvm; 
rvm pkg install openssl;
rvm install 2.0.0  --with-openssl-dir=/home/vagrant/.rvm/usr  --verify-downloads 1;
rvm use 2.0.0;
echo 'gem: --no-rdoc --no-ri' >> /home/vagrant/.gemrc;
gem install rails"

touch /home/vagrant/.provisioned