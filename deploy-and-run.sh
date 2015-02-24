#!/bin/bash
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2015, Joyent, Inc.
#

#
# Run this script from a headnode to deploy the local "manta-cn-physusage"
# script to each of the Manta storage nodes in this datacenter, run that
# script, and fetch the results to the current directory.
#

set -o xtrace
set -o errexit
set -o pipefail

hosts="$(manta-adm cn -n storage)"

sdc-oneachnode -n "$hosts" 'rm -f /var/tmp/manta-cn-physusage'
sdc-oneachnode -n "$hosts" -d /var/tmp -g /var/tmp/manta-physusage/manta-cn-physusage
sdc-oneachnode -T 1200 -n "$hosts" 'chmod +x /var/tmp/manta-cn-physusage &&
    /var/tmp/manta-cn-physusage > /var/tmp/manta-physusage-latest.txt'
sdc-oneachnode -n "$hosts" -d /var/tmp/manta-physusage \
    -p /var/tmp/manta-physusage-latest.txt
