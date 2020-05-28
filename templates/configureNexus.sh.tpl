#!/bin/bash -e

yum install -y amazon-efs-utils
mkdir -p ${mount_point}
mount -t efs ${export}:/ ${mount_point}
echo "${export}:/ ${mount_point} efs default,_netdev,nofail 0 0" >> /etc/fstab

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
