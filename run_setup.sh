#!/bin/bash
# Title:		run_setup.sh
# Description:	Installation script for Packstack on CentOS 7 - OpenStack Newton release
# Author:		jodlajodla
# Date:			20170221
# Version:		0.1
# Usage:		bash run_setup.sh    OR    bash run_setup.sh ironic
# Notes:		Script is intended to install either default Packstack components or Packstack with Ironic


# Initial script variables
if [ $(id -u) != 0 ]; then
	SUDO='sudo -E'
fi
DEFAULT_EXTNET='physnet1'
INCLUDE_IRONIC=$([[ "$1" == 'ironic' ]]; echo $?)
BRIDGE_INTERFACE="$2"
EXTERNAL_NETWORK="$([[ -z "$3" ]] && echo $DEFAULT_EXTNET || echo $3)"

# Script functions
function change_puppetfile {
	if [ -z $1 ]; then
		# Change before install
		mv Puppetfile Puppetfile.default
		mv Puppetfile.ironic Puppetfile
	else
		# Change after install
		mv Puppetfile Puppetfile.ironic
		mv Puppetfile.default Puppetfile
	fi
}

# Disable firewalld and NetworkManager
$SUDO systemctl disable firewalld
$SUDO systemctl stop firewalld
$SUDO systemctl disable NetworkManager
$SUDO systemctl stop NetworkManager
$SUDO systemctl enable network
$SUDO systemctl start network

# Install Packstack packages
$SUDO yum install -y centos-release-openstack-newton
$SUDO yum update -y
$SUDO yum install -y openstack-packstack

# Check which type of installation was chosen and do workaround with Puppetfile in case of Ironic
if [ $INCLUDE_IRONIC -eq 0 ]; then
	change_puppetfile
fi

# Install gem and Puppet modules
$SUDO yum install -y gem
export GEM_HOME=/tmp/gem_packstack
gem install r10k
$SUDO "$GEM_HOME/bin/r10k" puppet install -v
$SUDO cp -r packstack/puppet/modules/packstack /usr/share/openstack-puppet/modules

# Check which type of installation was chosen and do workaround with Puppetfile in case of Ironic
if [ $INCLUDE_IRONIC -eq 0 ]; then
	if [ ! -z "$BRIDGE_INTERFACE" ]; then
		# Install Packstack & Ironic with bridged interface
		packstack --os-ironic-install=y --nagios-install=n --provision-demo=n --os-neutron-ovs-bridge-mappings="$EXTERNAL_NETWORK":br-ex --os-neutron-ovs-bridge-interfaces=br-ex:"$BRIDGE_INTERFACE" --allinone
	else
		# Install only Packstack & Ironic with existing network configuration
		packstack --os-ironic-install=y --nagios-install=n --provision-demo=n --allinone
	fi
	change_puppetfile 1
else
	packstack --nagios-install=n --provision-demo=n --allinone
fi

exit 0
