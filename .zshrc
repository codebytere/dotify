#!/usr/bin/env zsh

##### INSTALLATION PATH #####
export ZSH=~/.dotfiles/zsh/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

##### MISC VARS #####
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="sorin"

#load in all dotfiles
for file in ~/Developer/.dotfiles/zsh_files/.{aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

##### PLUGINS #####
plugins=(git)

##### USER CONFIG #####
export PATH="YOUR PATH"
