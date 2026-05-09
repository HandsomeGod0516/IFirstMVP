# 啟用 Powerlevel10k 即時提示
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh 安裝路徑
export ZSH="$HOME/.oh-my-zsh"

# 設定主題為 Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# 啟動 Oh My Zsh
source $ZSH/oh-my-zsh.sh

# 載入 p10k 個人設定檔
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/dotfiles/.p10k.zsh.
[[ ! -f ~/dotfiles/.p10k.zsh ]] || source ~/dotfiles/.p10k.zsh

# === 老大專屬 Git 快捷鍵 ===
alias g="git"
alias gst="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"
alias glo="git log --oneline --graph --decorate --all" # 加上 --graph 會有漂亮的視覺化分支線
