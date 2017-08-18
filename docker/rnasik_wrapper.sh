#!/bin/bash
source /etc/profile.d/lmod.sh
module --force try-load BigDataScript
module --force try-load RNAsik-pipe
RNAsik "$@"
