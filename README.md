**Prerequisites**

Requires that Docker be installed on the host machine. This requires at least Docker 17.05 for both daemon and client due to the multi-stage build.

**Building**

If you like to build it from these sources, for a new Stakecoin daemon version for example, follow these instructions.
$ docker build --no-cache -t wimjaap/stakecoind:latest .

**Running**

If you just want to run a node, follow these!
Create a directory to store Stakecoin data

```$ mkdir ~/stakecoin_data```

Pull the latest version and run with your parameters. See below for all parameters.

```$ docker pull wimjaap/stakecoind:latest```

```$ docker run --name stakecoind -d \ ```
``` --env 'STK_RPCUSER=user' \ ```
``` --env 'STK_RPCPASSWORD=password' \ ```
``` --volume ~/stakecoin_data:/stakecoin \ ```
``` --publish 16814:16815 \ ```
``` wimjaap/stakecoin```

**Configuration**

A custom stakecoin.conf file can be placed in the mounted data directory. Otherwise, a default stakecoin.conf file will be automatically generated based on environment variables passed to the container:

|name|default|
|---|---|
|STK_RPCUSER|stk|
|STK_RPCPASSWORD|youshouldchangeme|
|STK_RPCALLOWIP|127.0.0.1|
|STK_DISABLEWALLET|0|
|STK_STAKING|1|
|STK_TXINDEX|1|

Of course you are free to change, or add any parameter the stakecoin.conf after running.

**Sending commands to the stakecoind container**
You can use another container to sends commands to your stakecoind container. This way you can manage your wallet, unlock your wallet for staking etc.
For a full list run:

```$ docker run --rm --network container:stakecoind --volume ~/stakecoin_data:/stakecoin wimjaap/stakecoind help```

**Staking**

Make sure staking=1 and disablewallet=0 is set in your configuration, these are the default values.
Send some coins from an exchange to your STK address, you can find it by running:

```$ docker run --rm --network container:stakecoind --volume ~/stakecoin_data:/stakecoin wimjaap/stakecoind getaccountaddress ""```

**Encrypt your wallet using a passphrase**

```$ docker run --rm --network container:stakecoind --volume ~/stakecoin_data:/stakecoin wimjaap/stakecoind encryptwallet 'my secret passphrase'```

Your stakecoind will stop. Restart it with:

```$ docker start stakecoind```

Now you can unlock your wallet using "walletpassphrase". This command needs a "minutes" argument. The wallet will be unlocked for this amount of minutes. Also, optional you can add a "mintonly" argument to unlock for staking only.

```$ docker run --rm --network container:stakecoind --volume ~/stakecoin_data:/stakecoin wimjaap/stakecoind walletpassphrase 'my secret passphrase' 3600 true```

Example command would unlock the wallet for an hour with my passphrase and unlock for staking only. If you want to unlock "forever", set the minutes to the maximum: 9999999999999999999. As an alternative you could also use cron or "Scheduled Tasks" to run the unlock at an interval. Note, if you wish to extend the unlock time, send a "walletlock" command first.

**Donate / Credits**

If you like this and have some spare coins, you're always welcome to donate! =) Bugs and suggestions, contact me!

BTC: bc1qqyja5fyxx93sywcvzrx23s76n4r46za5y9ux3khuyylttkqtk64qmfe7wm
