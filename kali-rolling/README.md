# kali-vagrant

## System Setup

The first thing to do is figure out where we are wanting to create our Vagrant boxes and what platforms we want to support. If we are using a Windows system, we can support Hyper-V however our QEMU performance will be worse than on a Linux system. If we are on a Linux system, we won't be able to support Hyper-V.

After deciding what our host system will be we can install [Vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant), [Packer](https://developer.hashicorp.com/packer/install?product_intent=packer), and our desired virtualization software.

### Linux host

If we are using Kali Linux and wanting to support VMWare, VirtualBox, and QEMU we can do the following:

```
┌──(kali㉿kali)-[~]
└─$ sudo apt update && sudo apt install -y packer virtualbox virtualbox-ext-pack qemu
...
┌──(kali㉿kali)-[~]
└─$
```

We will also need to download and install [VMWare](https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html).

### Windows host

If we are on a Windows host then we will need to install [VMWare](https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html), [VirtualBox](https://www.virtualbox.org/wiki/Downloads), and [enable Hyper-V](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v). Please note that in order to run all three software without needing to change any settings you must be using Windows 10 20H1 build 19041.264 or higher or using Windows 11, VMWare 15.5.5 or higher, and VirtualBox 6.0 or higher.

Once we download Packer, we must take note of where `packer.exe` is, as we must move this file to our cloned repository later.

If we choose to try and support QEMU we can also install [QEMU](https://www.qemu.org/download/#windows). If we do so, we will have to later change the `"accelerator": "kvm",` line in the file `kali-vars.json` to be a different accelerator that is supported on Windows. For more information, we can consult the Packer documentation on [QEMU building](https://developer.hashicorp.com/packer/integrations/hashicorp/qemu/latest/components/builder/qemu#optional:). During our testing we found `tcg` to work.

## Vagrant Configuration

After cloning [this repository](https://gitlab.com/kalilinux/build-scripts/kali-vagrant) locally we can begin to edit the files so we can build our own Vagrant boxes. If we are on Windows, now would be a good time to move `packer.exe` to the directory.

We first will copy the file `kali-vars.json.template` and remove the trailing `.template`. On Linux we can quickly do this with the command `cp kali-vars.json.template kali-vars.json`. We now must edit the file `kali-vars.json` and add the required information to every field.

We supply a URL for the ISO we want to be used to install our systems and supply a SHA256 checksum hash. We can get the SHA256 sum on Linux with the command `sha256sum kali.iso` and on Windows we can open a PowerShell terminal and use the command `Get-FileHash kali.iso` (be sure to replace `kali.iso` with the proper ISO filename).

We also supply a [cloud token](https://developer.hashicorp.com/vagrant/vagrant-cloud/users/authentication#authentication-tokens) and box that we wish to upload the box to. If we are just wanting to create a local box, we can remove these parts and also remove the following from the file `config.json` to prevent attempting to upload.

```
      {
        "type": "vagrant-cloud",
        "box_tag": "{{user `cloud_box`}}",
        "access_token": "{{user `cloud_token`}}",
        "version": "{{user `cloud_version`}}"
      }
```

## Running the build

Depending on what system and providers we are building for our command to run the build will be a bit different. The list of [providers](https://developer.hashicorp.com/vagrant/docs/providers) Kali Linux currently supports includes:

- hyperv
- qemu
- vmware_desktop
- virtualbox

On Linux if we wish to build only QEMU we can do the following:

```
┌──(kali㉿kali)-[~]
└─$ packer build -var-file=kali-vars.json -only=qemu config.json
```

Or if we wish to build all but Hyper-V:

```
┌──(kali㉿kali)-[~]
└─$ packer build -var-file=kali-vars.json -except=hyperv config.json
```

On Windows if we wish to only build Hyper-V

```
$ packer.exe build -vare-file=kali-vars.json -only=hyperv config.json
```

Or if we wish to build everything:

```
$ packer.exe build -vare-file=kali-vars.json config.json
```

These are just some examples to provide an idea of what flags are necessary to choose providers and how to build them.

Unless previously removed, building will submit the box to Vagrant Cloud.

###  Running the build (headless)

To run headless builds, you will need to ensure you have the Extension Pack installed and then edit the config.json file to add
```
"headless": "1",
```
In the `"builders"` section before `"boot_command"`


## Misc notes

- The boot command can be removed to perform a manual installation, or the preseed.conf file adjusted as well. This can help to customize package selection and desktop environment choice, or be used to change system settings such as language or keymapping.
- The boot command is not all that is run post creation. Under the `scripts` directory there are further adjustments made to the system. These create the Vagrant user, setup SSH, allow for sudo, adjust DHCP, and slim down the VM to have a smaller file size for uploading.
- ssh_timeout should be extended if the system is slower, as that will allow for more time during the installation step and prevent Packer from erroring out.
- The boot_command portion of the config can be tweaked depending on needs. By default it will install Kali Linux with all default options selected. For a list of special keys, refer [here](https://developer.hashicorp.com/packer/integrations/hashicorp/vmware/latest/components/builder/iso#boot-configuration). Please note that as of December 2023 there is a [bug which may require the enabling of leftShift](https://github.com/hashicorp/packer/issues/7315) to use certain actions.
- For Hyper-V, we build using the default network switch but do not enforce this when pulling it from Vagrant Cloud. The user will choose which option works best for them if they have multiple switches.
- We use Hyper-V generation 2 for our images as generation 1 has been known to have problems that are corrected in generation 2.