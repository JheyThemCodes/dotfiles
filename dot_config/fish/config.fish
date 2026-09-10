if command -v thefuck > /dev/null
    thefuck --alias | source
end

if command -v "bat" > /dev/null
    alias cat='bat --color auto'
end

if command -v eza > /dev/null
    alias ls='eza --icons=auto'
    alias l='eza -lh --icons=auto'
    alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
    alias ld='eza -lhD --icons=auto'
    alias lt='eza --icons=auto --tree'
end

if command -v kitten > /dev/null
    alias s="kitten ssh "
    alias icat="kitten icat "
end

alias mkdir='mkdir -p'

if command -v zoxide > /dev/null
    zoxide init fish | source
end

for f in $__fish_config_dir/functions/**/*
    source $f
end

if status is-interactive
    starship init fish | source
    fastfetch
end
