#!/usr/bin/env bash

# This script bootstraps a developer environment on a fresh macOS installation.
# It uses Homebrew to install Zsh, Oh My Zsh, tmux, Nerd Fonts, Chrome,
# defaultbrowser and Visual Studio Code.  It then applies custom dotfiles.

set -euo pipefail

echo "Starting macOS developer setup…"

# Ensure we are running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "Error: This setup script is intended for macOS." >&2
  exit 1
fi

# Determine script directory (for relative file copies)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

######################################################################
# Homebrew installation
######################################################################
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Homebrew installation complete."
fi

echo "Updating Homebrew…"
brew update

######################################################################
# Zsh installation & default shell
######################################################################
# Install Zsh if not already installed via Homebrew.  Even though macOS ships
# with Zsh, using the Homebrew version ensures you have a modern release.
if ! brew list zsh >/dev/null 2>&1; then
  echo "Installing Zsh via Homebrew…"
  brew install zsh
fi

# Get the path to the Homebrew Zsh
BREW_ZSH="$(brew --prefix)/bin/zsh"

# Add the Homebrew Zsh to /etc/shells if it isn’t already present
if ! grep -qx "$BREW_ZSH" /etc/shells; then
  echo "Adding $BREW_ZSH to /etc/shells…"
  echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
fi

# Change the user’s default shell to the Homebrew Zsh if necessary
if [[ "$SHELL" != "$BREW_ZSH" ]]; then
  echo "Changing default shell to $BREW_ZSH…"
  chsh -s "$BREW_ZSH"
fi

######################################################################
# Oh My Zsh installation
######################################################################
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing Oh My Zsh…"
  # Run the unattended installer.  RUNZSH=no prevents it from launching a new
  # shell and KEEP_ZSHRC=yes preserves any existing ~/.zshrc (we overwrite it
  # later).
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Copy custom .zshrc from repository
echo "Applying custom .zshrc…"
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

######################################################################
# Install fonts and applications
######################################################################
# Tap the Homebrew fonts cask
brew tap homebrew/cask-fonts

# Install Fantasque Sans Mono Nerd Font
if ! brew list --cask font-fantasque-sans-mono-nerd-font >/dev/null 2>&1; then
  echo "Installing Fantasque Sans Mono Nerd Font…"
  brew install --cask font-fantasque-sans-mono-nerd-font
fi

# Install tmux
if ! brew list tmux >/dev/null 2>&1; then
  echo "Installing tmux…"
  brew install tmux
fi

# Copy tmux configuration
echo "Applying custom .tmux.conf…"
cp "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Install Google Chrome
if ! brew list --cask google-chrome >/dev/null 2>&1; then
  echo "Installing Google Chrome…"
  brew install --cask google-chrome
fi

# Install defaultbrowser utility for changing default browser
if ! brew list defaultbrowser >/dev/null 2>&1; then
  echo "Installing defaultbrowser utility…"
  brew install defaultbrowser
fi

# Set Chrome as the default browser using defaultbrowser
echo "Setting Chrome as the default browser…"
defaultbrowser chrome || true

# Install Visual Studio Code
if ! brew list --cask visual-studio-code >/dev/null 2>&1; then
  echo "Installing Visual Studio Code…"
  brew install --cask visual-studio-code
fi

######################################################################
# Rectangle installation & configuration
######################################################################
# Install Rectangle (a free, open‑source window manager) if it isn’t already
if ! brew list --cask rectangle >/dev/null 2>&1; then
  echo "Installing Rectangle…"
  brew install --cask rectangle
fi

# Launch Rectangle once to initialize its preference files.  Without an initial
# launch, the preferences plist may not exist and subsequent defaults writes
# could be ignored.  We ignore any errors here since the app may already be
# running or the command may exit immediately on headless systems.
echo "Launching Rectangle to initialize preferences…"
open -a Rectangle || true
# Give the app a moment to write its defaults before quitting
sleep 2
# Quit Rectangle gracefully if it is running.  This prevents duplicate menu
# bar icons when the user starts the app later.
osascript -e 'tell application "Rectangle" to quit' >/dev/null 2>&1 || true

# Use the recommended default shortcuts (Command ⌘ + Option ⌥) instead of
# Spectacle‑style shortcuts.  According to the Rectangle documentation, setting
# the `alternateDefaultShortcuts` flag to `true` switches the default
# shortcuts to the recommended set【661863216817574†L64-L73】.
echo "Configuring Rectangle to use recommended default shortcuts…"
defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -bool true

# Change the Maximize shortcut to ⌘+⌥+F.  Rectangle stores keyboard
# shortcuts in its preferences file under a dictionary keyed by the action
# name.  Each entry has a `keyCode` and `modifierFlags` entry.  A key code
# of `3` corresponds to the `F` key on macOS keyboards, and the modifier flags
# are the sum of the integer values for the desired modifiers (Command
# = 1 048 576 and Option = 524 288).  The total of 1 572 864 encodes the
# ⌘+⌥ combination.  This approach mirrors how other users configure the
# `maximize` action via defaults write, as shown in community scripts where
# `maximize` is set to a dictionary of `keyCode`/`modifierFlags` pairs【87417539624935†L318-L343】.
echo "Setting Rectangle’s Maximize shortcut to Cmd+Option+F…"
defaults write com.knollsoft.Rectangle maximize -dict-add keyCode -float 3 modifierFlags -float 1572864

# Leave a message about restarting Rectangle.  The changes above require the
# user to restart Rectangle to pick up the new settings.  We don’t relaunch
# automatically because it would create a running GUI app during script
# execution.
echo "Rectangle configuration complete.  Please start Rectangle manually to apply changes."

######################################################################
# Finish
######################################################################
echo "\nSetup complete!"
echo "\nNext steps:"
echo "• Change your terminal font to Fantasque Sans Mono Nerd Font in Terminal.app or your preferred terminal."
echo "• Open Visual Studio Code, press Cmd+Shift+X, search for ‘Claude Code’ and install the official extension as described in the documentation【911443157073624†L126-L137】."
echo "• Restart your terminal session to apply the new shell." 
