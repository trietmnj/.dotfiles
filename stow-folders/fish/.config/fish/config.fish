
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/tmnj/miniconda3/bin/conda
    eval /home/tmnj/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/tmnj/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/tmnj/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/tmnj/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

set -x JAVA_HOME /usr/lib/jvm/java-1.11.0-openjdk-amd64


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
set -gx MAMBA_EXE "/home/tmnj/.local/bin/micromamba"
set -gx MAMBA_ROOT_PREFIX "/home/tmnj/micromamba"
$MAMBA_EXE shell hook --shell fish --root-prefix $MAMBA_ROOT_PREFIX | source
# <<< mamba initialize <<<
