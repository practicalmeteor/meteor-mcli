#!/bin/bash -e

sudo curl -o /usr/local/bin/mcli https://raw.githubusercontent.com/practicalmeteor/meteor-mcli/master/bin/mcli
sudo chmod 555 /usr/local/bin/mcli
sudo curl -o /usr/local/bin/mcli-bundle https://raw.githubusercontent.com/practicalmeteor/meteor-mcli/master/bin/mcli-bundle
sudo chmod 555 /usr/local/bin/mcli-bundle
