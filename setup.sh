#!/usr/bin/env zsh
source resources.sh

bot "hello! welcome to your new computer"
bot "let's get going! "

bot "installing osx command line tools"
xcode-select --install

# set computer info
set_computer_info

# make dotfiles hidden
running "hiding dotfiles"
mv /dotfiles ~/.dotfiles
ok

# install brew
running "installing brew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

if [[ $? != 0 ]]; then
    error "unable to install homebrew -> quitting setup"
    exit 2
fi

running "updating to most recent brew version"
brew doctor
brew update
ok

# install node
running "installing node"
curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"
if [[ $? != 0 ]]; then
    error "unable to install node -> quitting setup"
    exit 2
fi
ok

running "Select which bundled brew & brew-cask packages you want to install"
source installs/.brew_installs
ok "feel free to add more brew packages! "

# globally install key npm pkgs
running "Select which bundled npm modules you want to install"
source installs/.npm_installs
ok "feel free to add more npm modules! "

# globally install important gems
running "Select which bundled gems you want to install"
source installs/.gem_installs
ok "feel free to add more ruby gems! "

#globally install atom packages
running "select the atom packages you would like to install"
source installs/.apm_installs
ok "feel free to add more atom packages! "

# hard link .zshrc
running "linking your .zshrc!"
ln ~/.dotfiles/.zshrc ~/.zshrc
ok

running "downloading oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

if [[ $? != 0 ]]; then
  error "unable to install oh-my-zsh -> quitting setup"
  exit 2
fi
ok

# hard link .oh-my-zsh
running "linking .oh-my-zsh"
ln ~/.oh-my-zsh ~/.dotfiles/zsh/.oh-my-zsh
ok

# hard link .gitconfig
running "linking .gitconfig"
ln ~/.dotfiles/.gitconfig ~/.gitconfig
ok

# setup git credentials
yes_or_no "Would you like to set your git credentials now?"
if confirmed; then
  set_git_info
else
  bot "ok, but remember to do it before your first commit! "
fi

bot "setting zsh as the user shell"
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]; then
  bot "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell (password required)"
  sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh > /dev/null 2>&1
  ok
fi

running "sourcing zshrc"
source ~/.zshrc
ok

running "sourcing osx defaults"
source .osx
ok

bot "whooo, all set! "
