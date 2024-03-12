# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.disk_bus = "virtio"
    libvirt.driver = "kvm"
    libvirt.video_vram = 512
  end

  config.vm.provider :libvirt do |libvirt|
    vmware.vmx["usb.present"] = "TRUE"
    vmware.vmx["ehci.present"] = "TRUE"
    vmware.vmx["usb_xhci.present"] = "TRUE"
  end
end
