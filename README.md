# reMarkbly-Random

## Timer Options

### Preferred Option: On-Sleep Trigger

The preferred method for managing your random screens is using the on-sleep trigger. This method ensures that your timer settings are handled effectively while your system is idle.

#### random-screens.service
```ini
[Unit]
Description=Random Screensaver Timer

[Service]
Type=simple
ExecStart=/usr/bin/some-random-screensaver-command
```  

#### random-screens.timer
```ini
[Unit]
Description=Runs Random Screensaver every time the computer goes idle

[Timer]
OnActiveSec=5min
Persistent=true

[Install]
WantedBy=timers.target
```  

### Deprecated Option: 5-Minute Timer

**DEPRECATION WARNING:** The 5-minute timer option is now considered a legacy setting. It is still available for use but is not recommended as the preferred method. Please consider using the on-sleep trigger instead.

#### 5-Minute Timer Configuration
```ini
[Unit]
Description=5-Minute Random Screensaver Timer

[Timer]
OnActiveSec=5min
Unit=random-screens.service

[Install]
WantedBy=timers.target
```  

Please copy and paste the relevant configurations into your system as needed.