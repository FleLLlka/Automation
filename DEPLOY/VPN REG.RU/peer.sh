#!/bin/bash
echo "Write a peer name"
read peername
wg genkey | tee /etc/wireguard/$peername-privatekey | wg pubkey | tee /etc/wireguard/$peername-publickey
peerpubkey=$(cat /etc/wireguard/$peername-publickey)
peerprivkey=$(cat /etc/wireguard/$peername-privatekey)
enum=$(cat /etc/wireguard/enum)
config="[Peer]\nPublicKey = $(cat /etc/wireguard/$peername-publickey) \nAllowedIPs = 10.0.10.$enum/24 \n"
cliconfig="[Interface]\nPrivateKey = $peerprivkey \nAddress = 10.0.0.$enum/32 \n\n[Peer]\nPublicKey = $(cat /etc/wireguard/publickey) \nEndpoint = $(hostname -i):51830 \nAllowedIPs = 0.0.0.0/0 \nPersistentKeepalive = 20\n"

echo -e $config >> /etc/wireguard/friends.conf
echo -e $cliconfig > /etc/wireguard/$peername.conf

let result=$enum+1

echo $result > /etc/wireguard/enum

service wg-quick@friends restart

echo "User $peername succesfully created and added to wireguard config"


