#!/bin/bash
sudo systemctl stop asterisk
echo "Your IP:"; ip -4 -br a
asterisk -C ~/asterisk-lab/asterisk.conf -cvvv
