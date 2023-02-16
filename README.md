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
Most of the functions are highly customized for me, my specific use case and setup. I recommend looking though the functions, understand what they are doing and make modifications that work for you and your enviroment.
## Usage
```
helper [OPTION] [ARGUMENT]
```
## Options

General
```
   -u  updater     Updates from apt, flatpak, and snap
   -x  xfce fixer  Basic xfce fixes for when it breaks
   -c  clean       Delete stuff for bounus space! (apt, fp, trash, thumbnails, tmp, logs, downloads)
   -t  timezone    temporarily change timezone - REQUIRES ARGUMENT - See Timezone section of Arguments below
```
Config
```
   -d  drawing     Setup drawing tablet
   -m  monitors    Setup displaylink and arrange monitors
   -v  vpn         Setup Mullvad VPN - REQUIRES ARGUMENT - See VPN section of Arguments below
```
Firewalls
```
   -f  firewall    Deploy firewall rules - REQUIRES ARGUMENT - See Firewall section of Arguments below
   -w  watcher     Watch firewall rule hits in packets and bytes
  ```

Special
```
   -s  startup     Good modules to run on startup
   -i  install     Overall Machine Setup
```
## Arguments 
Firewall
```
home     standard home use"
lax      lax home use - Allow all Out"
limited  limited home use - Internet Only (HTTP, HTTPS, DNS)"
secure   encrypted internt only (HTTPS, DoH, DoT) - HTTP and DNS will NOT work"
class    extra ports for class"
local    no internet, use when doing 1337 hax"
web      web server use"
backup   backup server use"
reset    FLUSH ALL rules and ACCEPT by default !!DANGER!!"
```

Timezone
```
pacific  America/Los_Angeles"
mountain America/Denver"
central  America/Chicago"
eastern  America/New_York"
arizona  America/Phoenix"
korea    Asia/Seoul"
auto     GeoClue"
```

VPN
```
home   standard vpn config + deploy home firewall ruleset
mobile home vpn config without local LAN access
high   vpn config for higher risk sitiations + deploy limitedVPN firewall
```
## Extra Notes

### Updater
* Running the updater function will automatically update from apt and flatpak WITHOUT confirmation. Snap operates normally.

### Firewalls
* Note that choosing reset will FLUSH ALL rules and ACCEPT by default. Effectively, you have no firewall. Use with caution!
<br><br>
* All home rulesets ONLY allow related/established traffic IN
* The standard home ruleset will allow all nessesary ports needed for daily-driver computer usage OUT
* The lax home ruleset will allow any traffic OUT
* The limited home ruleset will only allow HTTP/HTTPS/DNS traffic OUT
* The secure home ruleset will only allow out protocols that are encrypted OUT
* The class class ruleset allows extra ports used in class. Allows SSH IN
* The local home ruleset will only allow all private IP's and localhost, NO internet access. Great for 1337 h@x practice on local network
<br><br>
* The webserver ruleset allows ssh, http, and https IN. Ports reqired for data out are allowed on a per-user basis.
* The backup server only allows SSH in. Ports reqired for data out are allowed on a per-user basis.
<br><br>
* If iptables-persistent is installed, all firewall rulesets will now save themselves to /etc/iptables/rules.v4 Note that this WILL overwrite an existing saved ruleset with the same name. 
<br><br>
* Yes, I am (now) aware the watch command exists, which can replace the watcher module. This module may be depricated in the future

### clean
* Everything removed will be irrecoverable.
* This modual will remove logs from journalctl that are over 3 days old
* This modual will remove unused apt dependencies (autoremove), remove the apt cache (clean), and uninstall unused flatpak runtimes (unused).
* This modual will empty the tmp folder, as well as the trash (items delted from GUI file manager) and thumbnails (icon previews of files in gui file manager) for the user account with the UID of 1000. 
* This modual will also give the option to remove all files in the Downloads folder for user with UID of 1000.

## Installation
### Get the Debian package
##### Download package - The reccomended way
1. GUI - Download the latest .deb package from the Releases page.
2. CLI - Use wget with the link to the .deb package from the Releases page. Ensure you are using wget on the .deb package, not the tag under releases on the main page.
##### Build package from source - The fun way
1. Clone the git repo
2. Run the build command with the directory name of the git repo (default is helper) ```dpkg-deb --build helper```
   * You may want to update the version number in the control file to match the number of commits as to ensure compatibility with future versions
### Install the Debian package
```
apt install ./helper.deb
```

#### ALT: Manually move files to a bin directory - NOT recommended
Note that the program will not be tracked by apt
1. Clone the git repo
2. move all files to /usr/local/bin
3. Allow exacution of 'helper' with ```chmod +x helper```. No need to change permissions of the dependency files. 
