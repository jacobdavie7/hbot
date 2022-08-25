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
   -m  monitors    Setup displaylink and arrange monitors
   -d  drawing     Setup drawing tablet
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
 home    Firewall ruleset for home use
 web     Firewall ruleset for web server use
 backup  Firewall ruleset for backup server use
 limited Firewall ruleset for limited home use
 reset   FLUSH ALL rules and ACCEPT by default !!DANGER!!
```
## Extra Notes
### Firewalls
* The home ruleset requires sudo to be installed
* The server rulesets does not work with sudo and must be run as root
* The reset function will check if you are root and run with or without sudo depending on your UID
<br><br>
* Note that choosing reset will FLUSH ALL rules and ACCEPT by default. Effectively, you have no firewall. Use with caution!
<br><br>
* Yes, I am (now) aware the watch command exists, which can replace the watcher module. This module may be depricated in the future

## Installation
### Get the Debian package
#### Download package - The reccomended way
1. GUI - Download the latest .deb package from the Releases page
2. CLI - Use wget with the .deb link from the Releases page
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