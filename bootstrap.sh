#
# Bootstrap File for Mac Installations
#
# copyright Robert Hoppe - nodemash.com
#

# clear first the shell
clear

# post first some info
echo "=========================================================="
echo "Starting now OSX Bootstrap of Robert Hoppe"
echo " "
echo "Repository: https://github.com/roberth1988/osx-bootstrap"
echo "=========================================================="
echo " "
echo " "
echo "The Bootstrapping will start ing 10 seconds."

wait 10

# lets call xcode first
xcode-select --install

# install first homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# export paths
export PATH=/usr/local/bin:$PATH

brew install \
    git \
    wget \
    python \
    tree \
    sshuttle \
    watch \
    redis \
    libxml2 \
    libyaml \
    mysql \
    node \
    openssl \
    pcre \
    speedtest_cli \
    figlet \
    htop \
    dialog \
    httpie \
    wrk \
    fzf \
    go \
    lnav

# display arrangement
brew tap jakehilborn/jakehilborn && brew install displayplacer

# add mongodb
brew tap mongodb/brew
brew install mongodb-community@4.2

# add duf
brew tap muesli/tap
brew install duf

# vim special
brew install macvim

# zsh special
brew tap homebrew/services
brew install zsh
brew install zsh-completions

# kubernetes specific
brew install kube-ps1 \
    kubectx \
    stern \
    derailed/k9s/k9s \
    derailed/popeye/popeye \
    sunny0826/tap/kubecm

# install cask
brew install cask
brew cask install java

# add glance quicklook plugin
# You must start /Applications/Glance.app once manually to setup the QuickLook plugin.
brew cask install glance

# Golang specific stuff
brew tap go-swagger/go-swagger
brew install go-swagger

# install necessary pip modules
pip install progressbar \
    pyOpenSSL \
    requests \
    dnspython \
    lxml \
    py3dns \
    regex \
    csvkit \
    pyaml \
    Flask \
    awesome-slugify \
    beautifulsoup4 \
    vatnumber \
    PyExecJS \
    futures \
    Sphinx \
    chardet \
    redis \
    deepdiff \
    fuzzywuzzy \
    python-Levenshtein \
    tldextract \
    raven \
    microdata \
    ngram \
    pyparsing \
    statsd \
    blinker \
    pycountry \
    simplejson \
    suds-jurko \
    powerline-status

# some folder stuff
mkdir .ssh

# Ask for the administrator password upfront
echo "We need super-user rights to continue the installation"
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# setup default shell to zsh
echo "Setting zsh as default shell"
if ! grep -q zsh /etc/shells; then
    echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
fi
chsh -s /usr/local/bin/zsh

# switch now to zsh
/usr/local/bin/zsh

# setup computer name
sudo scutil --set ComputerName "RobsMac"
sudo scutil --set HostName "RobsMac"
sudo scutil --set LocalHostName "RobsMac"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "robsmac"

# Key Repeating
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 20
defaults write -g KeyRepeat -int 1

# Mission Control
defaults write com.apple.dock expose-animation-duration -float 0.15
killall Dock

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Disable game center cruft
defaults write com.apple.gamed Disabled -bool true

# Disable ext change warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Get dotfile package manager ellipsis.sh
curl -L ellipsis.sh | sh

# load ellipsis to path
export PATH=~/.ellipsis/bin:$PATH

# install custom settings
dialog --title "Install dotfiles" \
--backtitle "ellipsis install roberth1988/files " \
--yesno "Do you want to install the roberth1988/files?" 7 60

response=$?
case $response in
   0) ellipsis install roberth1988/files &&  $(brew --prefix)/opt/fzf/install;;
   1) echo "Boostrapping done";;
   255) echo "[ESC] key pressed.";;
esac
