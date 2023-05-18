#!/bin/bash 

%{ if ebs_data_volume }
/usr/bin/systemctl stop nexus

INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`

# wait for ebs volume to be attached
while true
do
    # attach EBS (run multiple times in case the volume was still detaching elsewhere)
    aws --region ${region} ec2 attach-volume --volume-id ${volume_id} --instance-id $INSTANCE_ID --device /dev/xvdg

    # see if the volume is mounted before proceeding
    lsblk |grep nvme1n1
    if [ $? -eq 0 ]
    then
        break
    else
        sleep 5
    fi
done

# volume may present to lsblk before the os has fully processed it, so give it a chance
sleep 20

# create fs if needed
/sbin/parted /dev/nvme1n1 print 2>/dev/null |grep xfs
if [ $? -eq 0 ]
then
  echo "Data partition found, ensuring it is mounted"

  mount | grep ${mount_point}

  if [ $? -eq 1 ]
  then
    echo "Data partition not mounted, mounting and adding to fstab"
    echo "/dev/nvme1n1p1 ${mount_point}         xfs     defaults,noatime   1 1" >> /etc/fstab
    echo "Giving device time to prepare for mount..."
    sleep 20
    mount ${mount_point}
  fi

else
  echo "Data partition not initialized. Initializing and moving base data volume"
  parted -s /dev/nvme1n1 mklabel gpt
  parted -s /dev/nvme1n1 mkpart primary xfs 0% 100%
  while true
  do
    lsblk |grep nvme1n1p1
    if [ $? -eq 0 ]
    then
        break
    else
        sleep 5
    fi
  done

  mkfs.xfs /dev/nvme1n1p1
  mount /dev/nvme1n1p1 /mnt
  rsync -a ${mount_point}/ /mnt
  umount /mnt

  echo "Data partition initialized, mounting and adding to fstab"
  echo "Data partition initialized, mounting and adding to fstab" > /dev/console
  echo "/dev/nvme1n1p1 ${mount_point}         xfs     defaults,noatime   1 1" >> /etc/fstab
  mount ${mount_point}
fi

%{ else }
yum install -y amazon-efs-utils
mkdir -p ${mount_point}
mount -t efs ${export}:/ ${mount_point}
echo "${export}:/ ${mount_point} efs defaults,_netdev 0 0" >> /etc/fstab
%{ endif }

chown -R nexus:nexus /opt/nexus/sonatype-work
systemctl restart nexus

echo "Checking if license is provided"
if [ -z "${license_secret}"] ; then

    echo "Configuring as OSS"
    cat > /opt/nexus/sonatype-work/nexus3/etc/nexus.properties << END
    nexus.loadAsOSS=true
END

else
    echo "Configuring as Pro"
    cat > /opt/nexus/sonatype-work/nexus3/etc/nexus.properties << END
    nexus.licenseFile=/opt/nexus/sonatype-work/nexus3/nexus.lic
END

    aws --region us-east-1 secretsmanager get-secret-value \
        --secret-id ${license_secret} --version-stage AWSCURRENT \
        --query SecretBinary --output text | base64 -d > /opt/nexus/sonatype-work/nexus3/nexus.lic

fi
