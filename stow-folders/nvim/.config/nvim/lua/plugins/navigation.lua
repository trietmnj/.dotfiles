-- plugins/navigation.lua
return {
    { "unblevable/quick-scope", event = "VeryLazy" },

    {
    "ggandor/lightspeed.nvim",
    event = "VeryLazy",
    config = function()
      require("lightspeed").setup({
        ignore_case = true,
        exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },
        jump_to_unique_chars = { safety_timeout = 400 },
        match_only_the_start_of_same_char_seqs = true,
        force_beacons_into_match_width = false,
        substitute_chars = { ["\r"] = "¬" },
        special_keys = { next_match_group = "<space>", prev_match_group = "<tab>" },
        limit_ft_matches = 4,
        repeat_ft_with_target_char = false,
      })
    end,
    },

    {
    "ThePrimeagen/harpoon",
    branch = "harpoon", -- optional: if you want v2 branch
    event = "VeryLazy",
    config = function()
      local hm = require("harpoon.mark")
      local hu = require("harpoon.ui")

      -- Keymaps
      vim.keymap.set("n", "<leader>gh", hm.add_file, { noremap = true, silent = true, desc = "Harpoon add file" })
      vim.keymap.set("n", "<C-e>", hu.toggle_quick_menu, { noremap = true, silent = true, desc = "Harpoon quick menu" })
      vim.keymap.set("n", "<leader>y", function() hu.nav_file(1) end, { noremap = true, silent = true, desc = "Harpoon to file 1" })
      vim.keymap.set("n", "<leader>u", function() hu.nav_file(2) end, { noremap = true, silent = true, desc = "Harpoon to file 2" })
      vim.keymap.set("n", "<leader>i", function() hu.nav_file(3) end, { noremap = true, silent = true, desc = "Harpoon to file 3" })
      vim.keymap.set("n", "<leader>o", function() hu.nav_file(4) end, { noremap = true, silent = true, desc = "Harpoon to file 4" })
    end,
  },

}
