# helper
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
helper [OPTION] [ARGUMENT]
```
## Options

Popular
```
   -u  updater     Updates from apt, flatpak, and snap
```
Config
```
   -d  drawing     Setup drawing tablet
   -m  monitors    Setup displaylink and arrange monitors
```
Firewalls
```
   -f  firewall    Deploy firewall rules - REQUIRES ARGUMENT - See Firewall section of Arguments below
   -w  watcher     Watch firewall rule hits in packets and bytes
  ```

Special
```
   -s  startup     good modules to run on startup
   -i  install     Overall Machine Setup
```
## Arguments 
Firewall
```
 
 web     Firewall ruleset for web server use
 backup  Firewall ruleset for backup server use
 home    Firewall ruleset for home use
 lax     Firewall ruleset for more lax home use - Allow all Out
 limited Firewall ruleset for more limited home use - Internet Only
 local   Firewall ruleset for 1337 hax - No Internet
 reset   FLUSH ALL rules and ACCEPT by default !!DANGER!!
```
## Extra Notes

### Updater
* Running the updater function will automatically update from apt and flatpak WITHOUT confirmation. Snap operates normally.

### Firewalls
* Note that choosing reset will FLUSH ALL rules and ACCEPT by default. Effectively, you have no firewall. Use with caution!
<br><br>
* The home rulesets requires sudo to be installed
* All home rulesets ONLY allow related/established traffic IN
* The lax home ruleset will allow any traffic OUT
* The limited home ruleset will only allow HTTP/HTTPS/DNS traffic OUT
* The standard home ruleset will allow all nessesary ports needed for daily-driver computer usage OUT
* The local home ruleset will only allow all private IP's and localhost, NO internet access. Great for  
<br><br>
* The server rulesets does not work with sudo and must be run as root
* The webserver ruleset allows ssh, http, and https IN. Ports reqired for data out are allowed on a per-user basis.
* The backup server only allows SSH in. Ports reqired for data out are allowed on a per-user basis.
<br><br>
* The reset function will check if you are root and run with or without sudo depending on your UID
* If iptables-persistent is installed, all firewall rulesets will now save themselves to /etc/iptables/rules.v4 Note that this WILL overwrite an existing saved ruleset with the same name. 
<br><br>
* Yes, I am (now) aware the watch command exists, which can replace the watcher module. This module may be depricated in the future




## Installation
### Get the Debian package
#### Download package - The reccomended way
1. GUI - Download the latest .deb package from the Releases page.
2. CLI - Use wget with the link to the .deb package from the Releases page. Ensure you are using wget on the .deb package, not the tag under releases on the main page.
#### Build package from source - The fun way
1. Clone the git repo
2. Run the build command with the directory name of the git repo (default is helper) ```dpkg-deb --build helper```
   * You may want to update the version number in the control file to match the number of commits as to ensure compatibility with future versions 
   * You may want to rename the debian package to ```helper_VER.deb``` to avoid potential confusion with future verisons
#### Manually move add files to the bin directory - NOT recommended
Note that the program will not be tracked by apt
1. Clone the git repo
2. move all files to /usr/local/bin
3. Allow exacution of 'helper' with ```chmod +x helper```. No need to change permissions of the dependency files. 
### Install the Debian package
```
apt install ./helper_VER.deb
```