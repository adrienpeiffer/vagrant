# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
    config.vm.box = "odoo-box"
    config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

    config.vm.network :forwarded_port, guest: 8069, host: 8069
	config.vm.network :forwarded_port, guest: 8169, host: 8169

	config.vm.provision :shell do |shell|
	  shell.inline = "cd $1"
	  shell.args = %q{/home/vagrant/}
	  shell.inline = "sudo su - $1"
	  shell.args = %q{"vagrant"}
	  shell.inline = "git clone $1"
	  shell.args = %q{"https://github.com/acsone/odoo-box.git odoo"}
	  shell.inline = "./odoo/install_odoo"
	end
end
