#!/bin/bash

hostname {subdomain}

# Install saltstack
add-apt-repository ppa:saltstack/salt -y
apt-get update -y
apt-get upgrade -y
apt-get install salt-minion -y

export PAYLOAD=`echo "{{'ec2_hostname':'$(ec2metadata --public-hostname)','public_ip':'$(ec2metadata --public-ipv4)'}}" | sed s,"'",'\\\"',g`


sed -i "s/#master: salt/master: kush.weedlabs.io/" /etc/salt/minion
sed -i "s/#id:/id: {subdomain} #/" /etc/salt/minion

mkdir ~/.ssh

> ~/.ssh/authorized_keys

curl https://github.com/clarete.keys >> ~/.ssh/authorized_keys
curl https://github.com/gabrielfalcao.keys >> ~/.ssh/authorized_keys

chmod 600 ~/.ssh/authorized_keys


cat <<- EOF > salt-minion.conf
# salt-minion.conf

# https://gist.github.com/rubic/1617054

description "salt-minion upstart daemon"
author  "Jeff Bauer <jbauer@rubic.com>"

# copy this file to /etc/init

start on (net-device-up and local-filesystems)
stop on shutdown

expect fork
respawn
respawn limit 5 20

exec salt-minion -d
EOF

sudo cp salt-minion.conf /etc/init

service salt-minion start || echo 'started'
sleep 5
service salt-minion stop || echo 'stopped'

curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" http://kush.weedlabs.io/sms/{subdomain}

curl http://kush.weedlabs.io

service salt-minion start || echo 'started'
service salt-minion restart || echo 'salt-minion-running'
