# SickChill Updater

After updating to the PIP version of SickChill, I found that it was no longer automatically updating so I wrote a quick script.

I've setup a cron job to run this script once an hour (I know its overkill but the entire reason I created this was because I got sick of seeing the "update available" banner)

### Installation

`wget https://raw.githubusercontent.com/josh-gaby/sickchill-updater/master/update_sickchill.sh`

`chmod +x update_sickchill.sh`

Next you'll need to edit the script and change a couple of variables:

`nano update_sickchill.sh`

If you installed SickChill by cloning from GitHub:

```bash
INSTALL_TYPE="GIT"
SICKCHILL_PATH="/path/to/your/sickchill/installation"
```

If you installed SickChill using PIP:
```bash
INSTALL_TYPE="PIP"
SICKCHILL_PATH="/path/to/your/sickchill/installation"
```
For pip installations there is also an optional variable you can change called `PIP_PATH`, setting this will allow you to run the updates and restart Sickchill using a version of pip other than the default system version.

**NOTE:** *If you set `PIP_PATH` and leave the `PYTHON_PATH` empty then the updater script will attempt to call the version of pyhyon inside your `PIP_PATH` to restart SickChill.*
