# /etc/profile.d/dosh.sh

# Change SELinux label to unshare the volume with the containers?
if test -e /sys/fs/selinux/enforce && grep -q 1 /sys/fs/selinux/enforce
then
	DOSH_MOUNT_OPTIONS="Z"
	export DOSH_MOUNT_OPTIONS
fi
