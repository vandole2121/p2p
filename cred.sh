### Credentials

echo "Setup credentials... (Ctrl-C to quit, Enter to continue)"
read
REALNAME=""
EMAIL=""
echo "Enter REALNAME:"
read REALNAME
echo "Enter EMAIL:"
read EMAIL

passphrase2pgp -e -s -a > prv.asc
gpg --import prv.asc
rm prv.asc
#passphrase2pgp -e -s -a -p > pub.asc
#cat prv.asc | qrencode -o prv.png
#cat pub.asc | qrencode -o pub.png
#rm prv.asc pub.asc

echo "do: gpg --edit-key #choose trust->5->quit"

gpg -K --keyid-format long

pkill -HUP gpg-agent

mkdir -p ~/.ssh
chmod 700 ~/.ssh
passphrase2pgp -e1 -s -a -f ssh > ~/.ssh/id_rsa
passphrase2pgp -e1 -s -a -p -f ssh > ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id*

pkill -HUP ssh-agent

########