# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  config.vm.provider "virtualbox" do |v|
config.vm.network :forwarded_port, guest:22, host: 2255, id: "ssh", auto_correct: true
    v.memory = 256
    v.cpus = 1
  end

  config.vm.define "nginx_rpm" do |nginx_rpm|
    nginx_rpm.vm.network "private_network", ip: "192.168.50.50", virtualbox__intnet: "net1"
    nginx_rpm.vm.hostname = "nginx"
    nginx_rpm.vm.provision "file", source: "~/Homework5/nginx.spec", destination: "/tmp"
    nginx_rpm.vm.provision "file", source: "~/Homework5/otus.repo", destination: "/tmp"
    nginx_rpm.vm.provision "file", source: "~/Homework5/default.conf", destination: "/tmp"
    nginx_rpm.vm.provision "shell", path: "nginx_rpm.sh"
  end

end

