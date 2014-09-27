#!/bin/bash -xe

sudo curl -L -o /tmp/mcli.tar.gz https://github.com/spacejamio/meteor-mcli/archive/master.tar.gz
sudo tar xf /tmp/mcli.tar.gz -C /tmp
sudo mv /tmp/meteor-mcli-master/bin/mcli /tmp/meteor-mcli-master/bin/mcli-bundle /usr/local/bin
sudo chmod 555 /usr/local/bin/mcli /usr/local/bin/mcli-bundle
echo "mcli and mcli-bundle scripts installed in /usr/local/bin"
cp -r /tmp/meteor-mcli-master/starter-cli-app .
sudo rm -rf /tmp/mcli.tar.gz /tmp/meteor-mcli-master
echo "A starter meteor command line program using spacejamio:mcli was created in your current directory."
echo "To run your new meteor command line program:"
echo "  cd starter-cli-app"
echo "  mcli hello-world"
