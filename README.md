# reMarkbly-Random
Based on [https://pages.github.com/Neurone/reMarkable](https://github.com/Neurone/reMarkable)

Customizations for reMarkable and reMarkable 2 Paper Tablet.

> [!WARNING]
> This project is **NOT** affiliated with nor endorsed by reMarkable AS. If you modify your device, official support might refuse to help you if something goes wrong. Use at your own risk.

Scripts tested and working on versions `3.17.x` up to `3.26.x`. May work on previous versions but I don't have access so couldn't test.

> [!NOTE]
> Updates tend to remove the timer and reset the sleep screen to default. Good news is that it leaves your images alone. To fix this, just run `./putitback.sh`.

## Automatically change your suspend screen on every sleep/wake cycle

After installing this script, the images in `/home/root/customization/images/suspended` are indexed, put in a random order, and every time the reMarkable wakes from sleep the next image in order is made the current suspend screen. The names of the files are not relevant.

This approach monitors `/sys/power/wakeup_count` (the standard Linux power management interface) and triggers the image change immediately after each wake event, achieving the original goal of updating the screen on every sleep/wake cycle.

If you change the contents of `/home/root/customization/images/suspended` the script will detect the change and reindex the images automatically.

> [!TIP]
> If the sleep screen stops changing after modifying the script, restart the monitoring service:
> ```bash
> systemctl restart monitor-sleep-wake.service
> ```

### Manual installation

Follow all steps in the [Manual installation](#manual-installation) section below first, then continue here to add the sleep/wake monitoring service.

- Copy the monitoring script and make it executable:

```bash
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/monitor-sleep-wake.sh /usr/share/remarkable/scripts/
chmod +x /usr/share/remarkable/scripts/monitor-sleep-wake.sh
```

- Copy the service into the system services folder:

```bash
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/monitor-sleep-wake.service /usr/lib/systemd/system/monitor-sleep-wake.service
```

- Enable and start the monitoring service:

```bash
systemctl enable /usr/lib/systemd/system/monitor-sleep-wake.service
systemctl start monitor-sleep-wake.service
```

- Disable the 5-minute timer (if it is still present):

```bash
systemctl disable random-screens.timer
systemctl stop random-screens.timer
```

- Put your reMarkable to sleep and wake it — the sleep screen should change each time.

### Manual installation

- Clone this repo:

```bash
git clone git@github.com:ahnyerkeester/reMarkably-Random.git reMarkable-customizations
```

- Get the IP address and password for your reMarkable: Menu bars in the top left corner -> **Settings** -> **About** -> **Copyrights and licenses**. These are displayed at the bottom of that box.

> [!IMPORTANT]  
>Be aware that the IP address may change periodically when connecting over WiFi, don't assume it will always be the same.

- Connect to your reMarkable via USB or wake it and ensure it connects to WiFi. Copy this repo into a temp folder (change the XXXs below to the reMarabkle's IP address):

```bash
scp -r reMarkable-customizations root@XXX.XXX.XXX.XXX:/home/root/temp-reMarkable-customizations
```

- Login into your reMarkable:

```bash
❯ ssh root@XXX.XXX.XXX.XXX
root@XXX.XXX.XXX.XXX′s password:
ｒｅＭａｒｋａｂｌｅ
╺━┓┏━╸┏━┓┏━┓   ┏━┓╻ ╻┏━╸┏━┓┏━┓
┏━┛┣╸ ┣┳┛┃ ┃   ┗━┓┃ ┃┃╺┓┣━┫┣┳┛
┗━╸┗━╸╹┗╸┗━┛   ┗━┛┗━┛┗━┛╹ ╹╹┗╸
reMarkable: ~/
```

- Create dedicated folders for your scripts and images:

```bash
mkdir -p /usr/share/remarkable/scripts
mkdir -p /home/root/customization/images/suspended
```

- Copy the script into the correct folder and make it executable:

```bash
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/set-random-sleep.sh /usr/share/remarkable/scripts/
chmod +x /usr/share/remarkable/scripts/set-random-sleep.sh
```

- Copy some images into the folder:

```bash
cp /home/root/temp-reMarkable-customizations/images/suspended/* /home/root/customization/images/suspended
```

If you want to use your own images now or in the future, you'll need to be in the folder they are and use `scp` to get them there:

```bash
scp -r *.png root@XXX.XXX.XXX.XXX:/home/root/customization/images/suspended
```

- Copy the service and timer into the correct folder:

```bash
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/random-screens.service /usr/lib/systemd/user/random-screens.service
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/random-screens.timer /usr/lib/systemd/user/random-screens.timer
```

- Save the original image, _just in case_:

```bash
yes n | cp -i /usr/share/remarkable/suspended.png /usr/share/remarkable/suspended.original.png
```

- Enable service and timer:

```bash
systemctl enable /usr/lib/systemd/user/random-screens.timer
systemctl enable /usr/lib/systemd/user/random-screens.service
```

- Run the script to initialze it:

```bash
/usr/share/remarkable/scripts/set-random-sleep.sh
```

- Put your reMarkable to sleep and you should see a customized screen.

- **OPTIONAL** To free up space, you may delete the temp folder:

> [!TIP]
> As I learned with the `3.18` update, you may need these files again. You could leave the folder here or if you need to reinstall them, you can always copy them back again. 

```bash
rm -rf /home/root/temp-reMarkable-customizations
```

### Automatic installation

WIP :)

### Troubleshooting

You can check the status of the `monitor-sleep-wake` service to verify it is running and free of errors:

```bash
❯ systemctl status monitor-sleep-wake.service
● monitor-sleep-wake.service - Monitor sleep/wake events and update reMarkable sleep screen
     Loaded: loaded (/usr/lib/systemd/system/monitor-sleep-wake.service; enabled; vendor preset: disabled)
     Active: active (running) since Tue 2023-06-20 19:30:00 UTC; 15min ago
   Main PID: 312 (monitor-sleep-wa)
```

If the screen is not changing after wake events, restart the service:

```bash
systemctl restart monitor-sleep-wake.service
```
