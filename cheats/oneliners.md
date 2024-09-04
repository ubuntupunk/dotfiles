---
author: DavDev
highlight-style: tango
---

# get IP of local network
~~~{#get_ip .bash caption="get IP of local network"}
ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
~~~

# get external IP
```{.bash}
curl -s icanhazip.com
```

# ping IPv6 and discover all connected devices
```{.bash}
ping ff02::1%enp0s25
```

# convert images
see (http://www.howtogeek.com/109369/how-to-quickly-resize-convert-modify-images-from-the-linux-terminal/)

# width 200
```bash
convert example.png -resize 200 example.png
```

# height 200
```bash
convert example.png -resize 200 example.png
```
# exact size
```bash
convert example.png -resize 200×100! example.png
```
# find

## executables under current path
```bash
find . -type f -executable -print
```
## delete files with any of given extensions
```bash
	find -iregex '.*\.\(db\|wma\|ini\|txt\)$'
```

```{.bash caption='move all subfolders to root folder'}
find . -mindepth 2 -type d -exec mv {} . \;
```

# netcat receive hexadecimal values
```bash
nc -l -p <PORT> | xxd
```
# list available fonts:
```bash
fc-list
```
# reload font cache
```bash
fc-cache -f -v
```
# check integrity of /etc/passwd
```bash
pwck
```
# fix /etc/passwd (say yes on prompt)
```bash
grpck
```
# convert jpg to png (with imagemagick)
```bash
convert picture.{jpg,png}
convert -resize 50% picture.png picture.png
convert example.png -resize 200×100 example.png
convert example.png -resize x100 example.png
convert example.jpg -rotate 90 example-rotated.jpg
```
# base64
```bash
base64 -d <<< <BASE64STRING>
```
# bash: reuse last parameter
```bash
!$ # or $_
```
# get more than one parameter
```bash
!:1-2
```
# show what takes so long to boot
```bash
systemd-analyze blame
```
# delete (Xth) specific line from file
# good if SSH key has changed
```bash
sed -i 'Xd' ~/.ssh/known_hosts
```
# get external IP
```bash
wget -q -O - http://showip.spamt.net/
```
# play DVDs
```bash
sudo apt install ubuntu-restricted-extras libdvd-pkg libdvdnav4
```
# add user to additional group
```bash
usermod -aG <GROUP> $USER
```
# add GPG key to be able to install via apt
```bash
gpg --recv-keys KEYID
```
# IP address handling

# set static IP
```bash
ip addr add 192.168.112.111/24 dev enp0s25
```
# remove IP address
```bash
ip addr delete 192.168.112.111/24 dev enp0s25
```
# replace IP
```bash
ip addr replace 192.168.112.112/24 dev enp0s25
```
# TMUX
# pairing sessions over SSH
# create socket to share and set rights
```bash
tmux -S /tmp/tmux new -d -s pair
chmod 777 /tmp/tmux
```
# connect to shared socket from other device (over ssh)
```bash
tmux -S /tmp/tmux attach
```
# SAMBA
# list directories
```bash
smbclient -L <SERVER>
```
# connect
```bash
smbclient '\\<SERVER>\<FOLDER>' -U 'DOMAIN\USERNAME'
```
# NFS
# list NFS shares on server
```bash
showmount -e <SERVER-IP>
```
# mount NFS share
```bash
sudo mount -t nfs <SERVER>:<PATH> </mountpoint/on/client>
```
# mount ISO image
```bash
mount -o loop -t iso9660 filename.iso /mnt/iso
```
