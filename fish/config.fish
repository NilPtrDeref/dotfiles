if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
    alias vim "nvim"
    alias v "nvim"
    alias tmuxa "tmux attach-session"
    alias l "lazygit"
    alias y "yazi"
    alias emsdk_setup ". /home/jwood/opt/emsdk/emsdk_env.fish"
    set -Ux PYENV_ROOT $HOME/.pyenv

    # $HOME/opt/zls/zig-out/bin
    set -U fish_user_paths $HOME/opt/zig $HOME/go/bin $PYENV_ROOT/bin $fish_user_paths
    pyenv init - | source
    set EDITOR nvim
    set -Ux MANPAGER 'nvim +Man!'
end
