# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
    config.vm.box = "odoo-box"
    config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

    config.vm.forward_port 8169, 8169
	config.vm.forward_port 8069, 8069

	config.vm.provision :base do |shell|
	  shell.inline = "sudo apt-get install -y git-core"
	end
	
	config.vm.provision :base do |shell|
	  shell.inline = "cd $1"
	  shell.args = %q{/home/vagrant/}
	end
	
	config.vm.provision :clone do |shell|
	  shell.inline = "sudo -u $1 git clone $2"
	  shell.args = %q{vagrant "https://github.com/adrienpeiffer/vagrant.git odoo"}
	end
	
	config.vm.provision :install do |shell|
	  shell.inline = "sudo chmod u+x $1"
	  shell.args = %q{./odoo/install_odoo.sh}
	end
	
	config.vm.provision :install do |shell|
	  shell.inline = "sudo -u $1 ./odoo/install_odoo.sh"
	  shell.args = %q{vagrant}
	end
	
end
