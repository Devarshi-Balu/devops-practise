pvcreate /dev/nvme1n1
pvcreate /dev/nvme2n1

#volume group creation 
vgcreate vg_storage /dev/nvme1n1 
#extending a volume group
vgextend vg_storage /dev/nvme2n1

#createing logical volumes
#lvcreate -L <how-large> -n <name-of-the-lv>    <from_which_volume_group>
lvcreate -L 20G -n lv_data vg_storage
lvcreate -L 20G -n lv_backup vg_storage
lvcreate -L 20G -n lv_deva vg_storage

#lv extend -r ==> automatically resize the file system

# make the below entries /etc/fstab
/dev/vg_storage/lv_deva /deva xfs  defaults,nofail   0 2
/dev/vg_storage/lv_backup /backup xfs  defaults,nofail   0 2
/dev/vg_storage/lv_data /data xfs  defaults,nofail   0 2


# verify using the below commands --- < run as sudo user > 
# lsblk -f
# df -hT
# lvs 
# pvs 
# vgs 
# chatlink: https://chatgpt.com/share/6a4e3dba-0f90-83ee-bc14-928074c05a70