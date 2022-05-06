My colletion of bash scripts combined into one script to help make my (and your) life that much easier.
<br>
<br>
This is a constant work in progress so be prepared for stuff to break and many updates.
<br>
<br>
Not all updates will get a new package realease. When I am working on this project, they come way to fast for that. I finally turned this into a package mostly becuase I was tired of navingating to the script :)
<br>
<br>
Most of the functions are highly customized for me, my specific use case and setup. I would reccomend looking though the functions, understand what they are doing and make modifications that work for you and your enviroment.
## Usage
```
helper [OPTION]
```
## Options
```
Popular"
  -u  updater     Updates from apt, flatpak, and snap"
Config"
  -m  monitors    Setup displaylink and arrange monitors"
  -d  drawing     Setup drawing tablet"
Firewalls"
  -f  firewall    Deploy firewall rules"
  -w  watch       Watch firewall rule hits in packets and bytes"
Special"
  -s  startup     good modules to run on startup"
  -i  install     Overall Machine Setup"
```
## Firewall Notes
Running the firewall module will first open a menu asking which of the following rulesets to deploy
```
w   workstaion
s   server
r   reset
```
The workstation ruleset requires sudo to be installed
<br>
The server ruleset does not work with sudo and must be run as root
<br>
The reset function will check if you are root and run with or without sudo depending on your UID
<br><br>
Note that choosing reset will FLUSH ALL rules and ACCEPT by default. Effectively, you have no firewall. Use with caution!
