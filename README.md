vagrant-ubuntu
==============

Scripts to create a lean Ubuntu Vagrant box.

- http://www.ubuntu.com/download/desktop/install-desktop-long-term-support

Install Ubuntu 12.04.4 LTS

Use "Alternate install CD"

- http://releases.ubuntu.com/precise/


Use "Automated Install using Kickstart"
https://help.ubuntu.com/12.04/installation-guide/i386/automatic-install.html

Use "Automated Install using Preseed"
https://help.ubuntu.com/12.04/installation-guide/amd64/appendix-preseed.html

Other Vagrant Box Setup Examples:

- https://github.com/puppetlabs/puppet-vagrant-boxes

- https://github.com/phusion/open-vagrant-boxes

Run:

    cd PATH_TO/vagrant-ubuntu
    ./setup

and at the boot prompt press <F6> to gain access to the boot options.
Add the `url=.*` [or `ks=.*`] string you get from the command prompt. The rest of
the installation is automated.

Finally, run the last command that `setup` spits out (it's of the
form `./cleanup && ...`). Congratulations! You have just created a
Vagrant box.

Your Vagrant box will be saved in a file like:
    PATH_TO/vagrant-ubuntu/boxes/ubuntu1204-x86_64-20140125.box

Specification
-------------

The box is constrained to 613 MiB of memory to vaguely resemble an
Amazon AWS micro instance. You may want to consider adjusting this
for your needs using options like:

    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", 2048]
        vb.customize ["modifyvm", :id, "--ioapic", "on", "--cpus", 2]
    end

in your `Vagrantfile`.

This box has a heavy bias towards US English locales. If this
affects you, please adjust the preseed.cfg [or `ks.cfg` ] file accordingly. This was
mainly done as a space saving measure.


Additional Notes
----------------

There is a hacky 'web server' to get the kickstart script into the
installer which requires `netcat`. Alternatively, you could host the
preseed.cfg and late_command.sh [or `ks.cfg` ] file on your own HTTP server.

Please be aware that these scripts will *not* install any special
provisioners beyond the shell. Patches will be considered if you
wish to contribute support for Puppet, Chef, etc.

Does Support Ansible

The development tools group package is also included for
convenience. This includes things like `gcc` and `make` as well as
VCSs like `git`, `hg`, `bzr`, etc.

You are encouraged to look at the file `vars.sh` to modify the
configuration to best suit your needs. In particular, take note
of the location of the ISOs (which aren't include in the git
repository):

    INSTALLER="./isos/ubuntu-12.04.4-alternate-amd64.iso"
    GUESTADDITIONS="./isos/VBoxGuestAdditions-4.3.6.iso"

Assumptions have been made about the location of the hard drive as
well:

    HDD="${HOME}/VirtualBox VMs/${NAME}/${NAME}.vmdk"

If you wished to be emailed with the various logs the build produces
see the `ks.cfg` file and find the line:

    EMAIL=root

and adjust accordingly.

Contributors
----------------
Christopher Rawnsley

Steve Morin
