#!/bin/sh

# usage: ./install_plone.sh

sudo apt-get install -y git-core
sudo apt-get install -y python-pip
sudo apt-get install -y python-dev
sudo apt-get install -y libxml2-dev libxslt-dev
sudo apt-get install -y postgresql
sudo apt-get install -y python-psycopg2
sudo apt-get install -y libpq-dev
sudo apt-get install -y libldap2-dev libsasl2-dev libssl-dev

sudo -u postgres createuser vagrant --superuser

if [ ! `which virtualenv` ]; then
	echo "Installing virtualenv..."
	pip install virtualenv
fi

echo "DONE!"
echo "Ready to install Odoo !"

cd /home/vagrant/odoo
mkdir instance-70
ln -s buildout-70.cfg/ instance-70/buildout.cfg
mkdir instance-80
ln -s buildout-80.cfg/ instance-80/buildout.cfg

virtualenv instance-70
./instance-70/bin/pip install zc.buildout
virtualenv instance-80
./instance-80/bin/pip install zc.buildout

CWD=`pwd`
cd instance-70
./bin/buildout -vvv
cd $CWD
if [ ! -f ./instance-70/bin/start_openerp ] 
then
	echo "Instance 7.0 creation error. Please restart them"
	exit 1
fi
cd instance-80
./bin/buildout -vvv
cd $CWD
if [ ! -f ./instance-80/bin/start_openerp ] 
then
	echo "Instance 8.0 creation error. Please restart them"
	exit 1
fi

if [ ! -f /etc/init/odoo-server-70.conf ] 
then 
   sudo touch /etc/init/odoo-server-70.conf
fi
if [ ! -f /etc/init/odoo-server-80.conf ] 
then 
   sudo touch /etc/init/odoo-server-80.conf
fi
echo "setuid vagrant" | sudo tee /etc/init/odoo-server-70.conf
echo "setgid vagrant" | sudo tee -a /etc/init/odoo-server-70.conf
echo "exec /home/vagrant/instance/bin/start_openerp --proxy-mode" | sudo tee -a /etc/init/odoo-server-70.conf

sudo ln -s /lib/init/upstart-job /etc/init.d/odoo-server-70
sudo service odoo-server-70 start

echo "setuid vagrant" | sudo tee /etc/init/odoo-server-80.conf
echo "setgid vagrant" | sudo tee -a /etc/init/odoo-server-80.conf
echo "exec /home/vagrant/instance/bin/start_openerp --proxy-mode" | sudo tee -a /etc/init/odoo-server-80.conf

sudo ln -s /lib/init/upstart-job /etc/init.d/odoo-server-80
sudo service odoo-server-80 start

echo
echo "DONE!"
echo "You may now run Odoo instance 7.0 or 8.0."
