#!/bin/bash

# Adaptation of Pratak Kumar's script for Ubuntu, specifically tailored for Pop!_OS 22.04 Jammy

# Define color variables for colored output in the terminal
Red='\e[0;31m';     
BRed='\e[1;31m'; 
BIRed='\e[1;91m';
Gre='\e[0;32m';     
BGre='\e[1;32m';
BBlu='\e[1;34m';
BWhi='\e[1;37m';
RCol='\e[0m';

# Retrieve the codename and OS name from the system's OS release information
codename=$(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2)
osname=$(cat /etc/os-release | grep '="Pop!_OS"' | cut -d = -f 2)

# Check if the script is running on Pop!_OS 22.04
if [ "$codename" == "jammy" ] && [ "$osname" == '"Pop!_OS"' ]; then
  source="/usr/share/gnome-shell/theme/Pop/gnome-shell-theme.gresource"
  GDM_RESOURCE_CONFIG_NAME="gdm"

# Output error message and exit if not running on Pop!_OS 22.04.
else
  echo -e "${Red}
------------------------------------------------------------------
Sorry, Script is only for Pop!_OS ${BWhi}22.04${Red} Only
Exiting...
------------------------------------------------------------------
${RCol}"
  exit 1
fi

# Check if the necessary package 'libglib2.0-dev-bin' is installed.
pkg=$(dpkg -l | grep libglib2.0-dev-bin >/dev/null && echo "yes" || echo "no")
if [ "$pkg" == "no" ]; then
# Output error message and exit if the package is not installed.
  echo -e "${Red}
-----------------------------------------------------------------------------------------------------
Sorry, the package ${BWhi}'libglib2.0-dev-bin'${Red} is not installed. 
Run ${BGre}sudo apt-get install libglib2.0-dev-bin${Red} to install.
For now, Exiting...
-----------------------------------------------------------------------------------------------------${RCol}"
  exit 1
fi

# Define the destination directory for the custom GDM.
dest="/usr/local/share/gnome-shell/custom-gdm"
color='#456789'

###################################################
# Function to display help information.
HELP() {

  echo -e "
${BGre}pop-gdm-set-background${BGre} script (for changing Pop!_OS ${BWhi}22.04${RCol} GDM Background) HELP

there are four options
1. background with image
2. background with color
3. background with gradient horizontal ( requires two valid hex color inputs)
4. background with gradient vertical ( requires two valid hex color inputs)

${BWhi}Tip:${RCol} be ready with valid hex color code in place of below example like #aAbBcC or #dDeEfF. Change them to your preffered hex color codes.
you may choose colors from ${BBlu}https://www.color-hex.com/${RCol}

Example Commands:

1. ${BWhi}sudo ./pop-gdm-set-background --image ${BGre}/home/user/backgrounds/image.jpg${RCol}
2. ${BWhi}sudo ./pop-gdm-set-background --color \#aAbBcC${RCol}
3. ${BWhi}sudo ./pop-gdm-set-background --gradient horizontal \#aAbBcC \#dDeEfF${RCol}
4. ${BWhi}sudo ./pop-gdm-set-background --gradient vertical \#aAbBcC \#dDeEfF${RCol}
5. ${BWhi}sudo ./pop-gdm-set-background --reset${RCol}
6. ./pop-gdm-set-background --help

RESCUE_MODE, Example Commands:

1. ${BWhi}$ sudo ./pop-gdm-set-background --image ${BGre}/home/user/backgrounds/image.jpg ${BWhi}rescue${RCol}
2. ${BWhi}$ sudo ./pop-gdm-set-background --color \#aAbBcC rescue ${RCol}
3. ${BWhi}$ sudo ./pop-gdm-set-background --gradient horizontal \#aAbBcC \#dDeEfF rescue${RCol}
4. ${BWhi}$ sudo ./pop-gdm-set-background --gradient vertical \#aAbBcC \#dDeEfF rescue${RCol}

${BWhi}Why RESCUE_MODE?${RCol}
It is when you try to change the background with some other scripts and then interacted with this script,
there will be some conflicts. In case you ran other scripts to change the background and then tried this script,
found conflicts? then add 'rescue' to the end of the command as mentiond above.

${BRed}Please note that for 'RESCUE_MODE' active internet connection is necessary ${RCol}
"

}
###################################################

###################################################
# Function to perform initial routine checks.
ROUTINE_CHECK() {
  # Checks for script execution permissions and prepares the environment.
  if [ "$UID" != "0" ]; then
    echo -e "${BRed}This script must be run with sudo${RCol}"
    exit 1
  fi

  cd /tmp
  if [ -d /tmp/theme/ ]; then
    rm -r /tmp/theme
  fi

  if ! [ -d $dest ]; then
    install -d $dest
  fi

}
###################################################

###################################################
# Function for handling rescue mode operations.
RESCUE_MODE() {
  # Attempts to fix issues by reinstalling the yaru-theme-gnome-shell package.
  echo -e "
>>>>> Trying to ${BWhi}reinstall${RCol} the package yaru-theme-gnome-shell,
if the reinstallation of the package is succesful, background change will be done
otherwise No changes will be made <<<<<<<<<
"
  apt install --reinstall yaru-theme-gnome-shell
  if [ $? != 0 ]; then
    echo -e "${BIRed}
SCRIPT COULD NOT FINISH THE JOB, FAILURE, NO CHANGES WERE DONE.${RCol}"
    exit 1
  fi
}
###################################################

###################################################
# Function to extract GDM theme resources.
EXTRACT() {
  # Extracts gnome-shell resources for customization.
  for r in $(gresource list $source); do
    t="${r/#\/org\/gnome\/shell\//}"
    mkdir -p $(dirname $t)
    gresource extract $source $r >$t
  done
}
###################################################

###################################################
# Function to create a custom XML for the GDM theme.
CREATE_XML() {
  # Assembles and writes a custom XML for the GDM theme modification.

  extractedFiles=$(find "theme" -type f -printf "%P\n" | xargs -i echo "    <file>{}</file>")
  cat <<EOF >"theme/custom-gdm-background.gresource.xml"
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
$extractedFiles
  </gresource>
</gresources>
EOF
}
###################################################

###################################################
# Function to update GDM resource with custom settings.
SET_GRESOURCE() {
  # Applies the custom GDM theme and performs a check to confirm success.
  cd $dest
  update-alternatives --quiet --install /usr/share/gnome-shell/$GDM_RESOURCE_CONFIG_NAME-theme.gresource $GDM_RESOURCE_CONFIG_NAME-theme.gresource $dest/custom-gdm-background.gresource 0
  update-alternatives --quiet --set $GDM_RESOURCE_CONFIG_NAME-theme.gresource $dest/custom-gdm-background.gresource

  check=$(update-alternatives --query $GDM_RESOURCE_CONFIG_NAME-theme.gresource | grep Value | grep $dest/custom-gdm-background.gresource >/dev/null && echo "pass" || echo "fail")
  if [ "$check" == "pass" ]; then
    echo -e "
😕 ${BGre}Seems 'background change is successful'${RCol}
Changes will be effective after a Reboot (${BWhi}CTRL+ALT+F1${RCol} may show the changes immediately)
If something went wrong, log on to tty and run the below command
${BWhi}$ sudo update-alternatives --quiet --set $GDM_RESOURCE_CONFIG_NAME-theme.gresource /usr/share/gnome-shell/theme/Pop/gnome-shell-theme.gresource${RCol}
"
  else
    echo Failure
    exit 1
  fi
}
###################################################

############################################################################################
case "$1" in 
  --help)
    HELP
    exit 1
  ;;
  --reset)
    ROUTINE_CHECK
    if ! [ -f $dest/custom-gdm-background.gresource ]; then
      echo -e "
-----------------------------------------------------------------------------
No need, Already Reset. ${Red}(or unlikely background is not set using this Script.)${RCol}
-----------------------------------------------------------------------------"
      exit 1
    elif [ "$UID" != "0" ]; then
      echo -e "${BRed}This Script must be run with sudo${RCol}"
      exit 1
    else
      rm $dest/custom-gdm-background.gresource
      update-alternatives --quiet --set $GDM_RESOURCE_CONFIG_NAME-theme.gresource "$source"
      cd /usr/local/share
      rmdir --ignore-fail-on-non-empty -p gnome-shell/custom-gdm
      echo -e "${Gre}
      		---------------
		  		|Reset Success|
		  		---------------
		  		Changes will be effective after a Reboot ${RCol}"
      exit 1
    fi
  ;;
  --image)
    if [ -z "$2" ]; then
      echo -e "${BRed}Image path is not provided${RCol}"
      exit 1
    fi
    if
      file "$2" | grep -qE 'image|bitmap'
    then
      ROUTINE_CHECK
    if [ "$3" == "rescue" ]; then
      RESCUE_MODE
    fi
    EXTRACT
    cd theme
    cp "$2" ./gdm-background
    mv $GDM_RESOURCE_CONFIG_NAME.css original.css
    echo '@import url("resource:///org/gnome/shell/theme/original.css");
#lockDialogGroup {
background: '$color' url("resource:///org/gnome/shell/theme/gdm-background");
background-repeat: no-repeat;
background-size: cover;
background-position: center; }' >$GDM_RESOURCE_CONFIG_NAME.css
    cd /tmp
    CREATE_XML
    cd theme
    glib-compile-resources custom-gdm-background.gresource.xml
    mv custom-gdm-background.gresource $dest

    SET_GRESOURCE

    exit 1

  else
    echo -e "${BRed}
Absolute path to image is neither provided nor is it valid.
see help with below command${BWhi}
$ ./pop-gdm-set-background --help${RCol}"
    exit 1
  fi
  ;;
  --color)
    if [ -z "$2" ]; then
      echo -e "${Red}Color is not provided.
      Use ${BWhi}\$ sudo ./pop-gdm-set-background --color #aee02a${RCol} to set ${BWhi}#aee02a${RCol} as the background color.${RCol}"
      exit 1
    fi
    if ! [[ $2 =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]]; then
      echo -e "${BRed}Provided color is not a valid 'HEX Color Code'${RCol}
See help with below command
${BWhi}$ ./pop-gdm-set-background --help${RCol}"
      exit 1
    fi

  ROUTINE_CHECK
  if [ "$3" == 'rescue' ]; then
    RESCUE_MODE
  fi

  EXTRACT
  cd theme
  mv $GDM_RESOURCE_CONFIG_NAME.css original.css
  echo '@import url("resource:///org/gnome/shell/theme/original.css");
#lockDialogGroup {
background-color: '$2'; }' >$GDM_RESOURCE_CONFIG_NAME.css
  cd /tmp
  CREATE_XML
  cd theme
  glib-compile-resources custom-gdm-background.gresource.xml
  mv custom-gdm-background.gresource $dest

  SET_GRESOURCE

  exit 1
  ;;
  --gradient)
  if [ "$2" == "horizontal" ] || [ "$2" == "vertical" ]; then
    direction=$2
  else
    echo -e "${BRed}Gradient direction is not provided.${RCol}
    Use ${BWhi}$ sudo ./pop-gdm-set-background --gradient horizontal \#aa03af \#afa0ee${RCol} OR
    ${BWhi}$ sudo ./pop-gdm-set-background --gradient vertical \#aa03af \#afa0ee${RCol} to set a vertical gradient.
    See ${BWhi}./pop-gdm-set-background --help for more info${RCol}"
    exit 1
  fi
  if [[ -z "$3" || -z "$4" ]]; then
    echo -e "${BRed}color/colors is/are not provided${RCol}"
    exit 1
  fi

  if ! [[ $3 =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]] || ! [[ $4 =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]]; then
    echo -e "${BRed}Provided color/colors is/are not a valid 'HEX Color Code'${RCol}.
See help with below command
${BWhi}$ ./pop-gdm-set-background --help${RCol}"
    exit 1
  fi

  ROUTINE_CHECK

  if [ "$5" == "rescue" ]; then
    RESCUE_MODE
  fi

  EXTRACT
  cd theme
  mv $GDM_RESOURCE_CONFIG_NAME.css original.css
  echo '@import url("resource:///org/gnome/shell/theme/original.css");
#lockDialogGroup {
background-gradient-direction: '$direction';
background-gradient-start: '$3';
background-gradient-end: '$4'; }' >$GDM_RESOURCE_CONFIG_NAME.css
  cd /tmp
  CREATE_XML
  cd theme
  glib-compile-resources custom-gdm-background.gresource.xml
  mv custom-gdm-background.gresource $dest

  SET_GRESOURCE

  exit 1
  ;;
  *) 
    echo -e "Use the options ${BWhi}--image |--color | --gradient | --help | --reset${RCol}"
    exit 1
  ;;
esac
exit

