-- lua/modules/init.lua
pcall(require, "telescope")
pcall(require, "navigation")
pcall(require, "remaps")
pcall(require, "ai")
pcall(require, "theme")
pcall(require, "keymaps")
pcall(require, "globals")

P = function(v)
    print(vim.inspect(v))
    return v
end

if pcall(require, 'plenary') then
    RELOAD = require('plenary.reload').reload_module

    R = function(name)
        RELOAD(name)
        return require(name)
    end
end
