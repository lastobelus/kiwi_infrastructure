# SSH #

add the ec2_key that the cluster creates to ssh (must be done each login session, or add to .bash_profile):

    ssh-add knife/credentials/ec2_keys/2_box_lamp.pem

find the ip with knife cluster show:

    knife cluster show 2_box_lamp

use the ubuntu user:

    ssh ubuntu@xx.xx.xx.xx

