#!/bin/bash
#
# docker-entrypoint.sh - Install and configure chef-workstation on Unix
#
# Author     : Marcelo França <marcelo.frneves@gmail.com>
#
#  -------------------------------------------------------------
#   That's program get download of Chef Development Kit via URL added by 
#   user in docker-compose, then install via dpkg if sha256
#   signature match, else send error message in console (STDOUT).
#
#  -------------------------------------------------------------
#
#
# Changelog:
#
#    v1.0 2019-02-28, Marcelo Franca:
#       - Creating a feature to get download of Chef Development Kit
#    v1.1 2019-03-13, Marcelo Franca:
#		- Organizing statements of install and check chefdk into functions
# Licence: Apache.
#
sha256="83b96eb28891d3f89d58c3ffefa61c0d8aa605911c3b90d8c5cb92a75602e56d"
local_file="/tmp/chefdk_3.8.14-1_amd64.deb"
chefdk_url="https://packages.chef.io/files/stable/chefdk/3.8.14/ubuntu/18.04/chefdk_3.8.14-1_amd64.deb"

installchefdk() {
	if [[ $sha256 == $(wget --no-check-certificate	 $chefdk_url -O $local_file && \
		sha256sum $local_file | awk '{print $1}') ]]; then

		dpkg -i $local_file
		if [[ $? == 0 ]]; then
			echo "Installation has been completed!"
			export CHEFDK=true
			
		else
			echo "The installation failure"
			exit 2
		fi
	else
		echo "Download failure. The sha256 code do not been match!!";
		echo "sha256 code required: $sha256";
		echo "sha256 code received: $(sha256sum $local_file | awk '{print $1}')";
		echo "Please. Try again";
	fi
}

verifychef() {
	/usr/bin/chef verify
	if [[ $? == 0 ]]; then
		echo "ChefDK Verification completed"
		export CHEFCHECK_INSTALL=true
		su - $CHEFUSER -s /bin/bash
	fi
}

if [[ $CHEFDK && $CHEFCHECK_INSTALL == true ]]; then
	echo "ChefDK has been configured"
	su - $CHEFUSER -s /bin/bash
else
	echo -e "The ChefDK has not yet been installed.\n\n Starting the Installation...\n\n"
	installchefdk;
	verifychef;
fi
