# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# THIS MUST BE FIRST — before the instant prompt block
PROMPT=' '
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Add user configurations here
# For HyDE to not touch your beloved configurations,
# we added 2 files to the project structure:
# 1. ~/.user.zsh - for customizing the shell related hyde configurations
# 2. ~/.zshenv - for updating the zsh environment variables handled by HyDE // this will be modified across updates

#  Plugins 
# oh-my-zsh plugins are loaded  in ~/.user.zsh file, see the file for more information

#  Aliases 
# Add aliases here

#  This is your file 
# Add your configurations here
# export EDITOR=nvim
export EDITOR=nvim

# unset -f command_not_found_handler # Uncomment to prevent searching for commands not found in package manager
export ROFI_THEME="$HOME/.config/rofi/cosmere-theme.rasi"

export PATH=$PATH:/home/autometalogolex/.spicetify

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.local/share/../bin/env"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# CORRECT — theme first, then config
#source ~/powerlevel10k/powerlevel10k.zsh-theme
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
pm() {
  hyde-shell pm "$@"
}

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# In ~/.zshrc — very last lines:
# Very last line of ~/.zshrc — runs after OMZ loads, outside any hook machinery
zle -N zle-line-finish _p9k_widget_zle-line-finish

# Added by ProtonUp-Qt on 30-05-2026 10:59:58
if [ -d "/home/autometalogolex/stl/prefix" ]; then export PATH="$PATH:/home/autometalogolex/stl/prefix"; fi
