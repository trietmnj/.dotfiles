-- lua/plugins/whichKey.lua
-- show key mappings
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- preset UI (classic/modern/helix). Keep default.
      preset = "classic",

      -- Show the popup quickly for plugin-driven popups, 200ms otherwise (same as defaults)
      delay = function(ctx) return ctx.plugin and 0 or 200 end,

      -- NEW: replaces old `ignore_missing`
      -- If you wanted to hide mappings without a desc, flip this to:
      -- filter = function(m) return m.desc and m.desc ~= "" end,
      filter = function(_) return true end,

      -- You can add specs here, or call require("which-key").add() later
      spec = {},

      notify = true,

      -- NEW: replaces old `triggers` & `triggers_blacklist`
      -- The default auto trigger is usually what you want.
      triggers = {
        { "<auto>", mode = "nxso" },
      },

      -- NEW: replaces old `operators` setting (different behavior in v3).
      -- Keep the default defer logic so visual-block/visual line start hidden.
      defer = function(ctx) return ctx.mode == "V" or ctx.mode == "<C-V>" end,

      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = false,     -- you had this disabled
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },

      -- NEW: replaces old `window`
      win = {
        no_overlap = true,
        border = "none",
        padding = { 1, 2 },    -- roughly matches your old padding
        title = true,
        title_pos = "center",
        zindex = 1000,
        bo = {},
        wo = {
          -- winblend = 0,     -- you had 0 previously; defaults are fine
        },
      },

      layout = {
        width = { min = 20, max = 50 },
        spacing = 3,
      },

      -- NEW: replaces old `popup_mappings`
      keys = {
        scroll_down = "<c-d>",
        scroll_up   = "<c-u>",
      },

      -- NEW: replaces old `key_labels` and `hidden`
      -- v3 uses `replace` to format keys/descriptions in the popup.
      replace = {
        key = {
          function(key) return require("which-key.view").format(key) end,
          -- { "<Space>", "SPC" },   -- uncomment if you want SPC label
          -- { "<cr>", "RET" },
          -- { "<tab>", "TAB" },
        },
        desc = {
          { "<Plug>%(?(.*)%)?", "%1" },
          { "^%+", "" },
          { "<[cC]md>", "" },
          { "<[cC][rR]>", "" },
          { "<[sS]ilent>", "" },
          { "^lua%s+", "" },
          { "^call%s+", "" },
          { "^:%s*", "" },
        },
      },

      icons = {
        breadcrumb = "»",
        separator  = "➜",
        group      = "+",
        mappings   = true,     -- keep icons on
        -- rules = {},         -- leave defaults
        -- colors = true,      -- use mini.icons highlights if present
      },

      show_help = true,
      show_keys = true,

      disable = { ft = {}, bt = {} },
      debug = false,
    },
    keys = {
      -- Handy which-key helper to show buffer-local maps (from docs)
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
