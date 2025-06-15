
---

# ðŸ§ª IITD ZSH Proxy Environment Setup

This guide walks you through setting up a non-root `zsh` with `oh-my-zsh`, switching between **MSR** and **Research** environments, and launching corresponding proxies automatically.

---

## 1. Install Zsh from Source (Non-Root)

```bash
mkdir -p ~/apps
cd ~/apps
wget https://sourceforge.net/projects/zsh/files/zsh/5.9/zsh-5.9.tar.xz
tar -xf zsh-5.9.tar.xz
cd zsh-5.9

# Install ncurses locally (needed for Zsh)
cd ~/apps
wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.4.tar.gz
tar -xzf ncurses-6.4.tar.gz
cd ncurses-6.4
./configure --prefix=$HOME/apps/ncurses --with-shared --with-termlib --enable-widec --enable-ext-colors
make -j4 && make install
export CPPFLAGS="-I$HOME/apps/ncurses/include"
export LDFLAGS="-L$HOME/apps/ncurses/lib"
export LD_LIBRARY_PATH="$HOME/apps/ncurses/lib:$LD_LIBRARY_PATH"

# Now configure and install zsh
cd ~/apps/zsh-5.9
./configure --prefix=$HOME/apps/zsh --with-curses-terminfo
make -j4 && make install
```

---

## ð2. Create Zsh Launch Wrapper

`~/apps/zsh-launch.sh`

Make it executable:

```bash
chmod +x ~/apps/zsh-launch.sh
```

---

## ð3. Make Zsh Your Default (Non-root Way)

In `~/.bash_profile` (or `~/.bashrc`):

```bash
if [ -z "$ZSH_VERSION" ]; then
    exec "$HOME/apps/zsh-launch.sh"
fi
```

---

## ð4. Install Oh My Zsh (manually)

After launching Zsh:

```bash
$ ~/apps/zsh-launch.sh
```


##  5. Create Proxy Environment Scripts

Create two files in `~/exports/`:

**exports_msr.sh**
**exports_research.sh**


## ð6. Define Environment Switcher Functions

Add this to the bottom of your `~/.zshrc`:

```bash
emsr() {
  local msr_export="$HOME/exports/exports_msr.sh"
  local res_export="$HOME/exports/exports_research.sh"
  local proxy_script="$HOME/apps/iitdproxy/bin/iitdproxy.py"
  local proxy_file="$HOME/apps/iitdproxy/proxy_msr.txt"

  pkill -f "iitdproxy.py" 2>/dev/null
  nohup python3 "$proxy_script" "$proxy_file" > /dev/null 2>&1 &

  sed -i.bak "\|source \"$res_export\"|d" ~/.zshrc
  if ! grep -Fxq "source \"$msr_export\"" ~/.zshrc; then
    echo "source \"$msr_export\"" >> ~/.zshrc
    echo "[emsr] Added MSR exports to .zshrc"
  fi

  source "$msr_export"
}

eres() {
  local msr_export="$HOME/exports/exports_msr.sh"
  local res_export="$HOME/exports/exports_research.sh"
  local proxy_script="$HOME/apps/iitdproxy/bin/iitdproxy.py"
  local proxy_file="$HOME/apps/iitdproxy/proxy_research.txt"

  pkill -f "iitdproxy.py" 2>/dev/null
  nohup python3 "$proxy_script" "$proxy_file" > /dev/null 2>&1 &

  sed -i.bak "\|source \"$msr_export\"|d" ~/.zshrc
  if ! grep -Fxq "source \"$res_export\"" ~/.zshrc; then
    echo "source \"$res_export\"" >> ~/.zshrc
    echo "[eres] Added Research exports to .zshrc"
  fi

  source "$res_export"
}
```

Then reload Zsh:

```bash
source ~/.zshrc
```

---

## ð7. Using It

### Switch to MSR mode:

```bash
emsr
```

### Switch to Research mode:

```bash
eres
```

