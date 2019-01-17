kobo-wget-sync
===============

Forked from https://github.com/wernerb/kobo-wget-sync, a script that uses a precompiled and barely enough version of wget downloaded by a package script. Wget is then used to download files on every sync.

In this forked version the branch `zeit` is optimized to be used to get updates from zeit.de, a german weekly newspaper.

Install
---------------

1. To build simply run the package script.

   ```
   ./package.sh
   ```

   Then copy the `build/KoboRoot.tgz` to your kobo's /.kobo directory and disconnect the kobo.
   You will see it updating and restart.

2. Press `Sync` or activate wifi to start the script. (It watches the activation of wifi through udev rules)
3. Connect your kobo again and a dir called `.wget-sync` should be created that contains `config.sh`
4. Either edit `config.sh` by setting the url and other options OR
5. Copy the preconfigured config.sh to `.wget-sync` and create a file `auth.sh` at the same location filled with your authorization info:
   ```
   http_username="your_registered_email_address"
   http_password="your_password"
   ```
6. Disconnect usb, activate wifi (e.g. by syncing) and your kobo should download the newest issue. If it does not go well you can check the log in `.wget-sync` to check what went wrong.

FAQ
--------------
```
Q: For what Kobo versions does this work?
A: I only tested this with the Kobo Aura H2O with the latest firmware to date `4.12.12111`.

Q: Will you long-term support this?
A: No.
```

License
---------------
Neither softapalvelin nor wernerb seem to give proper licensing info (2019-01-14). I'm also not affiliated to the publisher Zeitverlag Gerd Bucerius GmbH & Co. KG other than being a reader of their newspaper. That's why I might need to remove this repository at any time.

Disclaimer
---------------
Even if everything seems to be fine on my side, this script might somehow break your device. If you're unsure leave your device as it is and live long and prosper.
