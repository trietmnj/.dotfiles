# TODO add in case for macOS
function nvim
    set machine_name (hostname)
    if test $machine_name = "tTunesLaptop"
        ~/apps/squashfs-root/usr/bin/nvim $argv;
    else if test $machine_name = "tmnj-desktop"
        if test -f ~/.local/bin/nvim
            ~/.local/bin/nvim $argv;
        else
            /usr/local/bin/nvim $argv;
        end
    else
        if command -q nvim
            command nvim $argv;
        else
            ~/apps/nvim-linux64/bin/nvim $argv;
        end
    end
end
