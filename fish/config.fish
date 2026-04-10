if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
    fish_vi_key_bindings
    alias vim nvim
    alias v nvim
    alias tmuxa "tmux attach-session"
    alias l lazygit
    alias y yazi

    set fish_user_paths $HOME/go/bin $fish_user_paths
    set fish_user_paths $HOME/Opt/bin $fish_user_paths
    set fish_user_paths /usr/lib/emscripten $fish_user_paths
    set fish_user_paths $HOME/Opt/zig/build/stage3/bin $fish_user_paths
    set fish_user_paths $HOME/.local/bin $fish_user_paths
    set fish_user_paths $HOME/Opt/zig/build/stage3/bin $fish_user_paths
    # set fish_user_paths $HOME/Opt/zig-0.16.0-dev $fish_user_paths
    # set fish_user_paths $HOME/Opt/zig-0.15.2 $fish_user_paths

    set EDITOR nvim
    set -Ux MANPAGER 'nvim +Man!'
end

function n --wraps nvim --description 'alias n=nvim'
    if count $argv >/dev/null
        nvim -n $argv
    else
        nvim -n .
    end
end

function tn --wraps trax --description 'alias tl=trax'
    if count $argv >/dev/null
        trax new $argv
    else
        trax new
    end
end

function tl --wraps trax --description 'alias tl=trax'
    if count $argv >/dev/null
        trax ls $argv
    else
        trax ls
    end
end

function te --wraps trax --description 'alias tl=trax'
    if count $argv >/dev/null
        trax edit $argv
    else
        trax edit
    end
end
