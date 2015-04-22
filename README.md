# manta-physusage

This is a **one-off** set of **unsupported** tools for assessing the physical
storage space used in a [Manta](https://github.com/joyent/manta) deployment.
Manta has rich reporting facilities for logical space used.  These tools are a
quick-and-dirty way to get a summary of physical space used, which includes the
effects of ZFS metadata and compression.

## Getting started

The basic flow is:

1. Install the scripts in this directory onto an
   [SDC](https://github.com/joyent/sdc) headnode.  These examples use the path
   /var/tmp/manta-physusage on the headnode.
2. On the headnode, run the `./deploy-and-run.sh` script.  This copies the per-CN
   script over to each Manta storage CN, runs it, and fetches the results into
   the current directory.  It can take several minutes to run this script on
   large deployments.
3. cat all the output files together and feed them to
   `./manta-physusage-summary'

Here's an example using a test datacenter called "emy10" that has just one Manta
storage CN (the headnode itself).  First, copy the files to the headnode:

    $ git clone https://github.com/joyent/manta-physusage
    $ cd manta-physusage
    $ ssh emy10.gz mkdir /var/tmp/manta-physusage
    $ scp deploy-and-run.sh manta-cn-physusage manta-physusage-summary \
        emy10.gz:/var/tmp/manta-physusage

Now on the headnode:

    $ ssh emy10.gz
    # cd /var/tmp/manta-physusage
    # chmod +x deploy-and-run.sh 
    # ./deploy-and-run.sh 
    ...

This creates an output file in a date-based subdirectory with the uuid of my
server:

    # head 2015-04-01/44454c4c-5700-1047-8051-b3c04f585131 
    emy-10 headnode zones:used - 242915668480
    emy-10 headnode zones:avail - 1487956160000
    emy-10 headnode /var/crash - 0
    emy-10 headnode zones/6ee79dfd-5a88-4ec2-928e-54881959957c - 5378952192
    emy-10 headnode zones/6ee79dfd-5a88-4ec2-928e-54881959957c 27b71bfe-ccf6-e287-9ffe-9b8dd3a40416 21
    ...

Now we feed that to the summarizer.  Note that you must have a copy of Node
0.10 or later on your PATH:

    # node manta-physusage-summary < 44454c4c-5700-1047-8051-b3c04f585131 
    resolving user "365fe66c-9d56-e167-e1d8-f9459d7019c5"
    resolving user "9240bb94-63ca-410b-a394-f38604398aaf"
    resolving user "27b71bfe-ccf6-e287-9ffe-9b8dd3a40416"
    Per-user physical storage used (top users)
    
        GIGABYTES   %TOT    %CUM  USER
             13.8  96.1%   96.1%  login: poseidon
              0.4   3.0%   99.1%  tombstone
              0.1   0.5%   99.6%  uuid:  9240bb94-63ca-410b-a394-f38604398aaf
              0.1   0.4%  100.0%  login: marlin_test
    
    Per-CN physical storage used
    
       GBTOTAL   GBUSED  %USED  %MANTA  %SNAPS  %CRASH  %REST  CN
          1612      226  14.0%    6.4%    0.0%    0.0%  93.6%  emy-10 headnode

        GBTOTAL: total gigabytes of usable space on this system
        GBUSED:  total gigabytes of usable space that is currently used
        %USED:   percentage of usable space that is currently used
        %MANTA:  percentage of USED space associated with Manta data
        %SNAPS:  percentage of USED space referenced only by snapshots
        %CRASH:  percentage of USED space associated with crash dumps
        %REST:   percentage of USED space unaccounted-for in other fields

## Reports

See above for an example report.

Fields in the per-user report:

* **GIGABYTES**: total gigabytes used by this user
* **%TOT**: percentage of used space that's associated with this user
* **%CUM**: percentage of used space that's associated with this user and all
  previously-listed users (i.e., percentage of spaced used by this user and all
  larger users)
* **USER**: may be either a user login, a user uuid (if the uuid could not be
  resolved to a login or if you specified "-n"), or one of a few special values.
  The special values include "nginx_temp" (temporary space used by nginx),
  "rebalance_tmp" (temporary space used by Manta rebalancing operations), and
  "tombstone" (data that has been deleted from Manta but not yet from the
  filesystem -- see [Manta GC
  overview](https://github.com/joyent/manta-mola/blob/master/docs/gc-overview.md)).

Fields in the per-CN report are described above.
