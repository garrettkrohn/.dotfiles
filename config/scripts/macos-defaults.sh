#!/usr/bin/env bash

set -e

echo "🍎 Configuring macOS defaults..."
echo ""
echo "⚠️  Note: Some changes require logout/restart to take effect"
echo ""

# ============================================================================
# Keyboard Settings
# ============================================================================
echo "⌨️  Configuring keyboard settings..."

# Enable key repeat (disable press-and-hold for vim motions)
defaults write -g ApplePressAndHoldEnabled -bool false
echo "✓ Disabled press-and-hold (enabled key repeat)"

# Faster key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
echo "✓ Set faster key repeat rate"

# Faster initial key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 10
echo "✓ Set faster initial key repeat"

# ============================================================================
# Finder Settings
# ============================================================================
echo ""
echo "📁 Configuring Finder settings..."

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES
echo "✓ Enabled showing hidden files"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
echo "✓ Enabled showing all file extensions"

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true
echo "✓ Enabled Finder path bar"

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true
echo "✓ Enabled Finder status bar"

# Restart Finder to apply changes
killall Finder
echo "✓ Restarted Finder"

# ============================================================================
# Dock Settings
# ============================================================================
echo ""
echo "🎯 Configuring Dock settings..."

# Auto-hide dock
defaults write com.apple.dock autohide -bool true
echo "✓ Enabled dock auto-hide"

# Set dock icon size
defaults write com.apple.dock tilesize -int 36
echo "✓ Set dock icon size to 36"

# Remove dock auto-hide delay
defaults write com.apple.dock autohide-delay -float 0
echo "✓ Removed dock auto-hide delay"

# Speed up dock auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.5
echo "✓ Sped up dock animation"

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false
echo "✓ Disabled recent applications in Dock"

# Restart Dock to apply changes
killall Dock
echo "✓ Restarted Dock"

# ============================================================================
# Trackpad Settings
# ============================================================================
echo ""
echo "🖱️  Configuring trackpad settings..."

# Uncomment the line below if you want to disable natural scrolling
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
# echo "✓ Disabled natural scrolling"

# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
echo "✓ Enabled tap to click"

# Enable three finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
echo "✓ Enabled three finger drag"

# ============================================================================
# Screenshot Settings
# ============================================================================
echo ""
echo "📸 Configuring screenshot settings..."

# Save screenshots to Downloads folder
defaults write com.apple.screencapture location -string "${HOME}/Downloads"
echo "✓ Set screenshot location to ~/Downloads"

# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"
echo "✓ Set screenshot format to PNG"

# Disable screenshot shadow
defaults write com.apple.screencapture disable-shadow -bool true
echo "✓ Disabled screenshot shadow"

# ============================================================================
# Other Settings
# ============================================================================
echo ""
echo "⚙️  Configuring other settings..."

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
echo "✓ Enabled expanded save panel"

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
echo "✓ Enabled expanded print panel"

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
echo "✓ Disabled automatic capitalization"

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
echo "✓ Disabled smart dashes"

# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
echo "✓ Disabled automatic period substitution"

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
echo "✓ Disabled smart quotes"

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
echo "✓ Disabled auto-correct"

# ============================================================================
# Complete
# ============================================================================
echo ""
echo "✅ macOS defaults configured successfully!"
echo ""
echo "📋 Next steps:"
echo "  - Log out and log back in for all changes to take effect"
echo "  - Some settings may require a full restart"
echo "  - To enable natural scrolling disable, uncomment line 72 in this script"
echo ""
