# reMarkbly-Random
Based on [https://pages.github.com/Neurone/reMarkable](https://github.com/Neurone/reMarkable)

Customizations for reMarkable and reMarkable 2 Paper Tablet.

> [!WARNING]
> This project is **NOT** affiliated with nor endorsed by reMarkable AS. If you modify your device, official support might refuse to help you if something goes wrong. Use at your own risk.

Scripts tested and working on versions `3.17.x` up to `3.26.x`. May work on previous versions but I don't have access so couldn't test.

> [!NOTE]
> Updates tend to remove the timer and reset the sleep screen to default. Good news is that it leaves your images alone. To fix this, just run `./putitback.sh`.

### Create your own images

Create your own images! They need to be 1404 x 1872 pngs and I used 229 ppi resolution. They don't have to be grayscale to work. I found the reMarkable logos here: [https://brandfetch.com/remarkable.com](https://brandfetch.com/remarkable.com)

> [!NOTE]
> This repo comes with some default images. I did my best to research them to ensure they were not copyrighted. If you find they are or are the creator, please send a PR to this repo and I will either credit you or delete the image as you desire.

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

- Clone this repo:

```bash
git clone git@github.com:ahnyerkeester/reMarkably-Random.git reMarkable-customizations
```

- Get the IP address and password for your reMarkable: Menu bars in the top left corner -> **Settings** -> **About** -> **Copyrights and licenses**. These are displayed at the bottom of that box.

> [!IMPORTANT]
> The IP address will change periodically when connecting over WiFi, don't assume it will always be the same.

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

- Copy the scripts and make them executable:

```bash
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/set-random-sleep.sh /usr/share/remarkable/scripts/
chmod +x /usr/share/remarkable/scripts/set-random-sleep.sh
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/monitor-sleep-wake.sh /usr/share/remarkable/scripts/
chmod +x /usr/share/remarkable/scripts/monitor-sleep-wake.sh
```

- Copy some images into the folder:

```bash
cp /home/root/temp-reMarkable-customizations/images/suspended/* /home/root/customization/images/suspended
```

If you want to use your own images now or in the future, you'll need to be in the folder they are and use `scp` to get them there:

```bash
scp -r *.png root@XXX.XXX.XXX.XXX:/home/root/customization/images/suspended
```

- Copy the service into the system services folder:

```bash
cp /home/root/temp-reMarkable-customizations/scripts/random-screens/monitor-sleep-wake.service /etc/systemd/system/monitor-sleep-wake.service
```

- Save the original image, _just in case_:

```bash
yes n | cp -i /usr/share/remarkable/suspended.png /usr/share/remarkable/suspended.original.png
```

- Enable and start the monitoring service:

```bash
systemctl enable /etc/systemd/system/monitor-sleep-wake.service
systemctl start monitor-sleep-wake.service
```

- Run the script to initialize it:

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
     Loaded: loaded (/etc/systemd/system/monitor-sleep-wake.service; enabled; vendor preset: disabled)
     Active: active (running) since Tue 2023-06-20 19:30:00 UTC; 15min ago
   Main PID: 312 (monitor-sleep-wa)
```

If the screen is not changing after wake events, restart the service:

```bash
systemctl restart monitor-sleep-wake.service
```
