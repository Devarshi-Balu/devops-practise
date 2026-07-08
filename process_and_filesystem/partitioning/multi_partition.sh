sudo parted /dev/nvme1n1 --script mklabel gpt \
                mkpart primary 1MiB 5GiB \
                mkpart primary 5GiB 10GiB \
                mkpart primary 10GiB 100% \


sudo mkfs.xfs /dev/nvme1n1p1
sudo mkfs.xfs /dev/nvme1n1p2
sudo mkfs.xfs /dev/nvme1n1p3

sudo mkdir -p /data 
sudo mkdir -p /logs 
sudo mkdir -p /backup 

sudo mount /dev/nvme1n1p1 /data
sudo mount /dev/nvme1n1p2 /logs
sudo mount /dev/nvme1n1p3 /backup


