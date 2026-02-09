-- lua/modules/init.lua
local M = {}

-- tiny helper: require a module and call its setup() if present
local function setup(modname)
  local ok, mod = pcall(require, modname)
  if ok and type(mod) == "table" and type(mod.setup) == "function" then
    local ok2, err = pcall(mod.setup)
    if not ok2 then
      vim.notify(("Error in %s.setup(): %s"):format(modname, err), vim.log.levels.ERROR)
    end
  end
end

function M.setup()
  -- use fully-qualified names under lua/modules/
  setup("modules.keymaps")
  setup("modules.navigation")
  setup("modules.telescope")
  setup("modules.theme")
  setup("modules.globals")
end

-- pretty print helper
P = function(v)
  print(vim.inspect(v))
  return v
end

return M
