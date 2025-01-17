# andxpto mac system defaults

# ask password
sudo -v

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# show hidden files
defaults write com.apple.Finder AppleShowAllFiles true

# disable mouse acceleration (requires restart)
defaults write .GlobalPreferences com.apple.mouse.scaling -1

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show hidden files by default
#defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Disable quit propt in iterm2
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# kill affected apps
for app in "Activity Monitor" \
	"Dock" \
	"Finder" \
	"Google Chrome" \
	"SystemUIServer" \
	"Terminal"; do
	killall "${app}" &> /dev/null
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
