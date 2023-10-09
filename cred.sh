#!/bin/sh

### Credentials

REALNAME=$1
EMAIL=$2
PASS=$3

if [ -z "$REALNAME" ]; then

	echo "Setup credentials... Make sure you are on the right user! (Ctrl-C to quit, Enter to continue)"
	read
	echo "Enter REALNAME:"
	read REALNAME
	echo "Enter EMAIL:"
	read EMAIL
	stty -echo
	echo "Enter passphrase:"
	read PASS
	stty echo
else
	echo "Using REALNAME: $REALNAME, EMAIL: $EMAIL"
fi

	echo "Using REALNAME: $REALNAME, EMAIL: $EMAIL, Enter to continue ..."
read 

echo "Generating prv key..."

echo $PASS > ~/.p

mkdir -p ~/.local/share/gnupg
ln -s ~/.local/share/gnupg/ ~/.gnupg
chmod 700 ~/.gnupg
echo > ~/.local/share/gnupg/gpg-agent.conf "default-cache-ttl 600"
echo >> ~/.local/share/gnupg/gpg-agent.conf "max-cache-ttl 900"
echo >> ~/.local/share/gnupg/gpg-agent.conf "enable-ssh-support"

sudo pacman -U passphrase2pgp-1.2.1-1-x86_64.pkg.tar.zst

echo "generating keys..."

REALNAME=$REALNAME EMAIL=$EMAIL passphrase2pgp -i ~/.p -e -s -a > prv.asc
gpg --import prv.asc
rm prv.asc
#passphrase2pgp -e -s -a -p > pub.asc
#cat prv.asc | qrencode -o prv.png
#cat pub.asc | qrencode -o pub.png
#rm prv.asc pub.asc

echo "********** do: gpg --edit-key #choose trust->5->quit"
gpg --edit-key van

gpg -K --keyid-format long

pkill -HUP gpg-agent

echo "generating keys..."

mkdir -p ~/.ssh
chmod 700 ~/.ssh
REALNAME=$REALNAME EMAIL=$EMAIL passphrase2pgp -i ~/.p -e1 -s -a -f ssh > ~/.ssh/id_rsa
REALNAME=$REALNAME EMAIL=$EMAIL passphrase2pgp -i ~/.p -e1 -s -a -p -f ssh > ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id*

echo >> ~/.local/share/gnupg/gpg-agent.conf "pinentry-program /sbin/pinentry-gnome3"

pkill -HUP ssh-agent

rm ~/.p

########
