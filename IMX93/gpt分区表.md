parted << EOF
mklabel gpt 
mkpart primary fat16 10MB 100MB
mkpart primary ext4 120MB 3900MB
mkpart primary ext4 3900MB 5206MB
mkpart primary ext4 5206MB 6512MB
mkpart primary ext4 6512MB 7818MB
EOF
    mkfs.ext4 /dev/mmcblk0p2
    mkfs.ext4 /dev/mmcblk0p3
    mkfs.ext4 /dev/mmcblk0p4
    mkfs.ext4 /dev/mmcblk0p5