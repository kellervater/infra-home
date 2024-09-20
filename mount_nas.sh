#!/bin/bash

NAS_IP=192.168.0.115
NAS_SHARE=kellerfilme
NAS_ADDRESS=//$NAS_IP/$NAS_SHARE
MOUNT_POINT=/mnt/nas

DEFAULT_NAS_USER=kellervater

#read -p "Enter NAS username (default: $DEFAULT_NAS_USER): " NAS_USER
NAS_USER=${NAS_USER:-$DEFAULT_NAS_USER}
read -sp "Enter password for ${NAS_USER}@${NAS_ADDRESS}: " PASSWORD

FSTAB_LINE="${NAS_ADDRESS} ${MOUNT_POINT} cifs username=${NAS_USER},password=${PASSWORD},uid=${USER},gid=${USER},file_mode=0777,dir_mode=0777 0 0"
grep -qF "${NAS_ADDRESS} ${MOUNT_POINT}" /etc/fstab || sudo sh -c "echo '${FSTAB_LINE}' >> /etc/fstab"


# Create symlink (workspace dir pointing to repositories on NAS)
TARGET="/mnt/nas/Job/repos/"
LINK="$HOME/workspace"

# Check if the target directory exists
if [ -d "$TARGET" ]; then
    # Create the symbolic link forcefully
    ln -sf "$TARGET" "$LINK"
    echo "Symbolic link $LINK -> $TARGET created or updated."
else
    echo "Target directory $TARGET does not exist. Symbolic link creation aborted."
fi
