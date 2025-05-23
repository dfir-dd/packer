# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.disk_bus = "virtio"
    libvirt.driver = "kvm"
    libvirt.video_vram = 512
    libvirt.graphics_type = "spice"
    libvirt.graphics_gl = false
    libvirt.video_type = "virtio"
    libvirt.video_accel3d = false
    libvirt.usb_controller :model => "qemu-xhci"
  end

  config.vm.provider :vmware_workstation do |vmware|
    vmware.vmx["usb.present"] = "TRUE"
    vmware.vmx["ehci.present"] = "TRUE"
    vmware.vmx["usb_xhci.present"] = "TRUE"
    vmware.force_vmware_license = "workstation"
  end
end
