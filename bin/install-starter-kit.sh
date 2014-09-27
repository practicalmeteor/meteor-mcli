#!/bin/bash -xe

sudo curl -L -o /tmp/meteor-cli.tar.gz https://github.com/spacejamio/meteor-cli/archive/master.tar.gz
sudo tar xf /tmp/meteor-cli.tar.gz -C /tmp
sudo mv /tmp/meteor-cli-master/bin/mcli /tmp/meteor-cli-master/bin/mcli-bundle /usr/local/bin
sudo chmod 555 /usr/local/bin/mcli /usr/local/bin/mcli-bundle
echo "mcli and mcli-bundle scripts installed in /usr/local/bin"
cp -r /tmp/meteor-cli-master/starter-cli-app .
sudo rm -rf /tmp/meteor-cli.tar.gz /tmp/meteor-cli-master
echo "A starter meteor command line program using spacejamio:mcli was created in your current directory."
echo "To run your new meteor command line program:"
echo "  cd starter-cli-app"
echo "  mcli hello-world"
