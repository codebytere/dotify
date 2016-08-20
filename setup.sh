source sh_files/echos.sh

bot "hello! welcome to your new computer"
bot "let's get going! "

# make dotfiles hidden
running "hiding dotfiles"
mv ~/Developer/dotfiles ~/Developer/.dotfiles
ok

# install node
running "installing node"
curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"

if [[ $? != 0 ]]; then
  error "unable to install node -> quitting setup"
  exit 2
fi
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

#do brew things
running "installing brew pkgs and apps via brew cask"
source installs/.brew_installs

# globally install key npm pkgs
running "globally installing key npm pkgs"
source installs/.npm_installs

# globally install important gems
running "globally installing gems"
source installs/.gem_installs

# hard link .zshrc
running "linking your .zshrc!"
ln ~/Developer/.dotfiles/.zshrc ~/.zshrc
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
ln ~/.oh-my-zsh ~/Developer/.dotfiles/zsh/.oh-my-zsh
ok

# hard link .gitconfig
running "linking .gitconfig"
ln ~/Developer/.dotfiles/.gitconfig ~/.gitconfig
ok

# set zsh as the user shell
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

bot "whooo, all set"
