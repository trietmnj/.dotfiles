
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/tmnj/apps/miniconda3/bin/conda
    eval /home/tmnj/apps/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/tmnj/apps/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/tmnj/apps/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/tmnj/apps/miniconda3/bin" $PATH
        set -x LANG en_US.UTF-8
        set -x LC_ALL en_US.UTF-8
    end
end
# <<< conda initialize <<<

