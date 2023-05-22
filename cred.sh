#!/bin/sh

### Credentials

echo "Setup credentials... Make sure you are on the right user! (Ctrl-C to quit, Enter to continue)"
read
REALNAME=""
EMAIL=""
echo "Enter REALNAME:"
read REALNAME
echo "Enter EMAIL:"
read EMAIL
stty -echo
echo "Enter passphrase:"
read PASS
stty echo
echo "Generating prv key..."

echo $PASS > ~/.p

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

mkdir -p ~/.ssh
chmod 700 ~/.ssh
REALNAME=$REALNAME EMAIL=$EMAIL passphrase2pgp -i ~/.p -e1 -s -a -f ssh > ~/.ssh/id_rsa
REALNAME=$REALNAME EMAIL=$EMAIL passphrase2pgp -i ~/.p -e1 -s -a -p -f ssh > ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id*

pkill -HUP ssh-agent

rm ~/.p

########
