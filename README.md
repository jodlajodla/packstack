# Packstack

Fork of official Packstack repo which contains fix for installing Packstack
with Ironic on CentOS 7 with OpenStack Ocata release. This repository, along
original files, also contains installation script `run_setup.sh`, so the
installation can be performed only by running a script, without any
additional effort. There is also `Puppetfile.ironic` in repo which is used
for correct installation of Packstack with Ironic.

## Installation of Packstack with Ironic and existing network configuration:

    $ sudo yum install -y git
    $ git clone git://github.com/jodlajodla/packstack.git
    $ cd packstack && git checkout stable/ocata
    $ sudo bash run_setup.sh ironic

## Installation of Packstack with Ironic and bridged network:

Make sure to replace `enp2s0` interface with your own.

    $ sudo yum install -y git
    $ git clone git://github.com/jodlajodla/packstack.git
    $ cd packstack && git checkout stable/ocata
    $ sudo bash run_setup.sh ironic enp2s0

## Installation of Packstack with Ironic and bridged network + named external network:

Make sure to replace `enp2s0` interface and `extnet` external network with your own.

    $ sudo yum install -y git
    $ git clone git://github.com/jodlajodla/packstack.git
    $ cd packstack && git checkout stable/ocata
    $ sudo bash run_setup.sh ironic enp2s0 extnet

## Installation of Packstack with default components:

    $ sudo yum install -y git
    $ git clone git://github.com/jodlajodla/packstack.git
    $ cd packstack && git checkout stable/ocata
    $ sudo bash run_setup.sh

## Development and general information

For any additional information about development or anything other connected to
Packstack, please refer to original README (in file `README_ORIGINAL`),
or check official repository located at https://github.com/openstack/packstack

## License

The software is provided "as is", without warranty of any kind from my side.
All files in project are included as fetched from source and may have been
changed in the way to make things work with technologies specified above.
Please read original license which is added to the project if you want to
further use this software or modify it. All respective rights reserved to
authors and contributors.
