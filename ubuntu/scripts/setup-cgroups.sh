#!/bin/bash

set -ex

username="tester"


# Create user ("tester")
useradd --home /home/${username} --create-home --groups sudo --shell /bin/bash ${username}

# allow user czm to user docker without sudo
#usermod -aG sudo tester

# assign rights for tester user to create and manage ressources
cgcreate -a ${username} -g blkio:${username}


###############################################################################
# setup all available cgroups (man cgconfig.conf)                             #
###############################################################################


cat <<EOF >/tmp/cgconfig.conf
group slow {
# Specify which users can admin (set limits) the group
perm {    
    admin {
        uid = ${username};
    }
# Specify which users can add tasks to this group
    task {
        uid = ${username};
    }
}
blkio {
    # set read/write to 5 MB/s each
    blkio.throttle.read_bps_device = 5242880;
    blkio.throttle.write_bps_device = 5242880;
}
group medium {
# Specify which users can admin (set limits) the group
perm {    
    admin {
        uid = ${username};
    }
# Specify which users can add tasks to this group
    task {
        uid = ${username};
    }
}
blkio {
    # set read/write to 25 MB/s each
    blkio.throttle.read_bps_device = 26214400;
    blkio.throttle.write_bps_device = 26214400;
}
group fast {
# Specify which users can admin (set limits) the group
perm {    
    admin {
        uid = ${username};
    }
# Specify which users can add tasks to this group
    task {
        uid = ${username};
    }
}
blkio {
    # set read/write to 100 MB/s each
    blkio.throttle.read_bps_device = 104857600;
    blkio.throttle.write_bps_device = 104857600;
}
EOF
mv /tmp/cgconfig.conf /etc/cgconfig.conf


###############################################################################
# setup settings (see man cgrules.conf)                                       #
###############################################################################


#cat <<EOF >/tmp/cgrules.conf
#...

#EOF
#mv /tmp/cgrules.conf /etc/cgrules.conf

