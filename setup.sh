#!/usr/bin/env bash
set -e # 遇到錯誤即停止

echo "🚀 老大，開始為你的 MacBook Pro M5 Pro 打造全新開發環境！"

# 1. 檢查並安裝 Apple 命令列工具 (Git 依賴)
if ! xcode-select -p &> /dev/null; then
    echo "🛠 未偵測到 Xcode Command Line Tools，開始安裝..."
    xcode-select --install
    echo "⚠️ 請在彈出的視窗點擊同意安裝，完成後請重新執行此腳本！"
    exit 0
fi

# 2. 檢查並安裝 Homebrew
if ! command -v brew &> /dev/null; then
    echo "🍺 未偵測到 Homebrew，開始自動安裝..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 針對 Apple Silicon (M 晶片) 設定環境變數
    echo ">> 設定 Homebrew PATH..."
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✅ Homebrew 已安裝，進行更新..."
    brew update
fi

# 3. 執行 Brewfile 安裝所有軟體 (包含 iTerm2, Ollama 等)
echo "📦 開始透過 Brewfile 安裝/更新清單內的軟體..."
brew bundle --file=~/dotfiles/Brewfile --cleanup

# 4. 檢查並安裝 Oh My Zsh (終端機風格框架)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🐚 未偵測到 Oh My Zsh，開始安裝..."
    # --unattended 參數讓它安裝完不會直接進入新的 zsh，讓腳本能繼續跑
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 5. 檢查並安裝 Powerlevel10k 主題 (如果還沒有的話)
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "🎨 下載 Powerlevel10k 主題..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# 6. 建立風格設定檔 (防呆與軟連結)
echo "🔗 綁定 Zsh 與風格設定檔..."
# 確保 dotfiles 裡有預設檔案，以免第一次跑出錯
touch ~/dotfiles/.zshrc
touch ~/dotfiles/.p10k.zsh

# 如果原本家目錄有 .zshrc 但不是我們綁定的軟連結，先備份起來
if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
    mv ~/.zshrc ~/.zshrc.bak
fi
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

# 7. 自動設定 iTerm2 的備份路徑指向 dotfiles
echo "💻 設定 iTerm2 自動讀取/儲存設定檔..."
mkdir -p ~/dotfiles/iterm2
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/dotfiles/iterm2"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

echo "✅ 老大，環境安裝與同步完畢！"
echo "請關閉這個終端機，以後請直接打開全新安裝好的『iTerm2』享受！"
