# Mac Silicon Developer Setup

This repository contains a repeatable setup script and configuration files for a fresh
Apple Silicon MacBook (tested on an M3 Pro) to prepare a pleasant development
environment.  It automates the installation of Zsh and Oh My Zsh with the
Robby Russell theme, configures a few sensible defaults for tmux, installs a
programmer‑friendly font from the Nerd Fonts project, installs Google Chrome and
makes it the default browser, and provides guidance for installing the
Claude Code extension in Visual Studio Code.

## What’s included?

This project creates the following pieces:

* **`setup.sh`** – a shell script you can run to perform the bulk of the setup on
  macOS.  The script checks for Homebrew, installs required packages, and
  applies configuration files.  It installs Zsh via Homebrew, runs
  Oh My Zsh’s unattended installer (which requires Zsh 4.3.9 or newer; the
  Oh My Zsh documentation notes that v5.0.8 or newer is preferred【148139571596259†L447-L449】), and then copies
  the provided `.zshrc` into your home directory.  It also installs
  `tmux`, the Nerd Fonts “Fantasque Sans Mono” font (using the Cask package
  `font‑fantasque‑sans‑mono‑nerd‑font`【686798725133823†L8-L22】), `google-chrome`【488508821418535†L6-L14】,
  `defaultbrowser`【667945880255305†L8-L13】, `visual‑studio‑code`【878211723063324†L6-L14】 and
  the `defaultbrowser` tool for setting your default web browser.  After
  installation, the script uses `defaultbrowser chrome` to make Chrome your
  default browser【891960197831231†L25-L27】.

* **`macbook-m3-dev-setup/.zshrc`** – a minimal Zsh configuration.  It sets the
  `ZSH` environment variable to `~/.oh-my-zsh`, selects the
  **robbyrussell** theme (the default according to the Oh My Zsh
  README【148139571596259†L540-L548】) and enables a few useful plugins (currently `git` and `macos`).

* **`macbook-m3-dev-setup/.tmux.conf`** – a simple tmux configuration that
  enables mouse support, switches the prefix key from `Ctrl+B` to `Ctrl+A`, and
  sets the default shell to Zsh.

## Prerequisites

The script is intended for a **fresh macOS installation**.  It will prompt for
administrator privileges when necessary.  Because the script uses Homebrew
(which manages packages on macOS), you should have an internet connection and
the Xcode command‑line tools installed.  If Homebrew is not present, the
script will attempt to install it for you.

## Usage

1. **Clone this repository** somewhere on your Mac:

   ```sh
   git clone git@github.com:donghyun-daniel/new-mac-init.git ~/workspace/macbook-m3-dev-setup
   cd ~/workspace/macbook-m3-dev-setup
   ```

2. **Run the setup script**:

   ```sh
   chmod +x setup.sh
   ./setup.sh
   ```

   The script will:

   * Install Zsh (via Homebrew) if needed【273548852385877†L6-L11】.
   * Install Oh My Zsh using the official unattended installer【148139571596259†L455-L466】.
   * Place the provided `.zshrc` into your home directory and set the
     Robby Russell theme【148139571596259†L540-L548】.
   * Install the Nerd Fonts “Fantasque Sans Mono” font【686798725133823†L8-L22】; you can then select it in
     Terminal.app or your preferred terminal emulator.
   * Install `tmux`【13118944867581†L6-L12】 and copy the provided `.tmux.conf` into your home
     directory.
   * Install Google Chrome【488508821418535†L6-L14】 and the `defaultbrowser` tool【667945880255305†L8-L13】,
     then set Chrome as the default browser by running `defaultbrowser chrome`【891960197831231†L25-L27】.
   * Install Visual Studio Code【878211723063324†L6-L14】.
   * Install Rectangle and configure its shortcuts as described above.  The
     script launches Rectangle once to initialize its preferences, sets the
     default shortcut scheme to use **Command + Option** combos, and
     reassigns the **Maximize** action to **Cmd + Option + F**【87417539624935†L318-L343】.  To use
     Rectangle after setup, start it from Applications or with `open -a
     Rectangle`.
  * Install **Rectangle**, a free window‑manager utility.  The script
    launches Rectangle once to create its preference file, then writes
    two settings via `defaults`:
    * It enables the recommended default shortcuts (⌘ + ⌥ combinations),
      equivalent to clicking **Restore Default Shortcuts** in the app.  This
      is done by setting the `alternateDefaultShortcuts` flag to `true`【661863216817574†L64-L73】.
    * It reassigns the **Maximize** action to **Cmd + Option + F** by
      specifying a key code of `3` (the **F** key) and modifier flags
      representing the ⌘ and ⌥ keys.  This mirrors how Rectangle stores
      shortcuts in its preference file【87417539624935†L318-L343】.  You must restart
      Rectangle after running the script for the change to take effect.

3. **Make Fantasque Sans Mono your terminal font** – open **Terminal > Settings >
   Profiles**, choose your favourite profile, and set the font to
   “Fantasque Sans Mono Nerd Font”.  You can also change the font in your
   terminal of choice.

4. **Install the Claude Code VS Code extension** – after the script installs
   Visual Studio Code, open VS Code, press `Cmd+Shift+X` to open the
   Extensions view, search for “Claude Code”, and click **Install**【911443157073624†L126-L137】.
   Claude Code requires VS Code 1.98.0 or higher and an Anthropic account.  The
   extension integrates the Claude Code AI into VS Code and allows you to work
   with your code directly inside the IDE【911443157073624†L123-L136】.

## Notes and caveats

* **Zsh versions** – Oh My Zsh’s README states that it requires Zsh 4.3.9 or
  later and prefers 5.0.8 or newer【148139571596259†L447-L449】.  macOS Sonoma and later ship with a
  modern Zsh, but using Homebrew’s version ensures you’re on the latest
  release.  The script will switch your default shell to the Homebrew Zsh.

* **Default browser** – The script uses the `defaultbrowser` utility to change
  the default HTTP handler to Chrome.  According to the tool’s documentation,
  running `defaultbrowser chrome` will set Chrome as your default browser
  【891960197831231†L25-L27】.  If you would rather not change your default browser, remove the
  relevant line from `setup.sh`.

* **Manual adjustments** – Some things, such as choosing a terminal font or
  installing the Claude Code extension, cannot be fully automated because
  they require user interaction.  The README directs you to these manual steps.

* **Further customization** – Feel free to edit `.zshrc` or `.tmux.conf` to
  tailor the environment to your preferences (e.g., adding more plugins or
  changing key bindings).  Consult the Oh My Zsh documentation for enabling
  additional plugins and themes【148139571596259†L503-L516】.

## Attribution

This setup draws on official documentation and package maintainers:

* Oh My Zsh installation and requirements【148139571596259†L447-L478】【148139571596259†L540-L548】.
* Homebrew Casks for Fantasque Sans Mono Nerd Font【686798725133823†L8-L22】,
  Google Chrome【488508821418535†L6-L14】, and Visual Studio Code【878211723063324†L6-L14】.
* Homebrew formulae for Zsh【273548852385877†L6-L11】 and tmux【13118944867581†L6-L12】.
* The `defaultbrowser` utility for setting the default browser【891960197831231†L25-L27】.
* Instructions from the Claude Code documentation for installing the VS Code
  extension【911443157073624†L126-L137】.
