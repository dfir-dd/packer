# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.disk_bus = "virtio"
    libvirt.driver = "kvm"
    libvirt.video_vram = 512
  end
end
