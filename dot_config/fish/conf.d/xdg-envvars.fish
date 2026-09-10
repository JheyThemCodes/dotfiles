# Basic PATH prepending (user local bin)
set PATH "$HOME/.local/bin:$PATH"

# XDG Base Directory Specification variables with defaults
set -U XDG_CONFIG_HOME "$HOME/.config"
set -U XDG_DATA_HOME "$HOME/.local/share"
set -U XDG_DATA_DIRS "$XDG_DATA_HOME:/usr/local/share:/usr/share"
set -U XDG_STATE_HOME "$HOME/.local/state"
set -U XDG_CACHE_HOME "$HOME/.cache"

# XDG User Directories (fallback to xdg-user-dir command if available)
if command -v xdg-user-dir >/dev/null 2>&1
  set -U XDG_DESKTOP_DIR "$(xdg-user-dir DESKTOP)"
  set -U XDG_DOWNLOAD_DIR "$(xdg-user-dir DOWNLOAD)"
  set -U XDG_TEMPLATES_DIR "$(xdg-user-dir TEMPLATES)"
  set -U XDG_PUBLICSHARE_DIR "$(xdg-user-dir PUBLICSHARE)"
  set -U XDG_DOCUMENTS_DIR "$(xdg-user-dir DOCUMENTS)"
  set -U XDG_MUSIC_DIR "$(xdg-user-dir MUSIC)"
  set -U XDG_PICTURES_DIR "$(xdg-user-dir PICTURES)"
  set -U XDG_VIDEOS_DIR "$(xdg-user-dir VIDEOS)"
end

# Less history file location
set -U LESSHISTFILE /tmp/less-hist

# Application config files
set -U PARALLEL_HOME $XDG_CONFIG_HOME/parallel
set -U SCREENRC $XDG_CONFIG_HOME/screen/screenrc
set -U TERMINFO $XDG_DATA_HOME/terminfo
set -U TERMINFO_DIRS $XDG_DATA_HOME/terminfo:/usr/share/terminfo
set -U WGETRC $XDG_CONFIG_HOME/wgetrc
set -U PYTHON_HISTORY $XDG_STATE_HOME/python_history

