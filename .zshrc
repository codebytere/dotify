##### INSTALLATION PATH #####
export ZSH= your_zsh_path
source $ZSH/oh-my-zsh.sh

##### THEME #####
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="YOUR THEME"

#load in all dotfiles
for file in ~/Developer/.dotfiles/zsh_files/.{aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

##### PLUGINS #####
plugins=(git)

##### USER CONFIG #####
export PATH="YOUR PATH"

##### MISCELLANEOUS #####

# export ARCHFLAGS="-arch x86_64"
# ZSH_CUSTOM=/path/to/new-custom-folder
# HIST_STAMPS="mm/dd/yyyy"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# COMPLETION_WAITING_DOTS="true"
# ENABLE_CORRECTION="true"
# DISABLE_AUTO_TITLE="true"
# DISABLE_LS_COLORS="true"
# export UPDATE_ZSH_DAYS=13

