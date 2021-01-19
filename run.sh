#!/bin/bash

STAKECOIN_DIR=/stakecoin
STAKECOIN_CONF=${STAKECOIN_DIR}/stakecoin.conf
NODELIST=$(curl -s "https://chainz.cryptoid.info/explorer/peers.nodes.dws?coin=stk&subver=%2FSatoshi%3A1.1.0%2F" | sed -e 's/[[]\|[]]\|["]/''/g' | tr , '\n' | while read line; do echo addnode="$line"; done;)
BLOCKCHAIN=${STAKECOIN_DIR}/blk0001.dat

# If config doesn't exist, initialize with defaults for a full node
if [ ! -e "${STAKECOIN_CONF}" ]; then
echo "No config found, initializing config"
cat >${STAKECOIN_CONF} <<EOF
server=1
rpcuser=${STK_RPCUSER:-stk}
rpcpassword=${STK_RPCPASSWORD:-youshouldchangeme}
rpcallowip=${STK_RPCALLOWIP:-127.0.0.1}
disablewallet=${STK_DISABLEWALLET:-0}
staking=${STK_STAKING:-1}
txindex=${STK_TXINDEX:-1}
${NODELIST}
EOF
fi
	
if [ ! -f "${BLOCKCHAIN}" ]; then
mkdir -p ${STAKECOIN_DIR}/tmp
echo "Downloading bootstrap, please wait and grab a coffee.."
wget -q -O ${STAKECOIN_DIR}/tmp/StakeCoin_Blockchain.rar https://www.dropbox.com/s/cgmwrq3i7x66zzo/StakeCoin_Blockchain.rar?dl=1
echo "Extracting blockchain and moving to correct location."
cd ${STAKECOIN_DIR}/tmp
unrar x StakeCoin_Blockchain.rar > /dev/null
mv -t ${STAKECOIN_DIR} ${STAKECOIN_DIR}/tmp/database ${STAKECOIN_DIR}/tmp/txleveldb ${STAKECOIN_DIR}/tmp/blk*
rm -r ${STAKECOIN_DIR}/tmp/*
fi
		
if [ $# -eq 0 ]; then
echo "Running stakecoind"
/usr/bin/stakecoind -datadir=${STAKECOIN_DIR} -conf=${STAKECOIN_CONF}
else
echo "Running command"
/usr/bin/stakecoind -datadir=${STAKECOIN_DIR} -conf=${STAKECOIN_CONF} "$@"
fi
