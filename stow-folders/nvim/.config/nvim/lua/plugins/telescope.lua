-- lua/plugins/telescope.lua
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { -- faster native sorter (requires `make`)
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
      { "ThePrimeagen/git-worktree.nvim", lazy = true },
    },
    keys = {
      { "<C-e>", "<cmd>Telescope buffers<cr>", desc = "Switch buffer" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local tb       = require("telescope.builtin")

      telescope.setup({
        defaults = {
          prompt_prefix    = " >",
          color_devicons   = true,
          file_previewer   = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer   = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          mappings = {
            i = {
              ["<C-x>"] = false,
              -- send selected to qflist and open it (nicer UX)
              ["<C-q>"] = function(prompt_bufnr)
                actions.smart_send_to_qflist(prompt_bufnr)
                actions.open_qflist(prompt_bufnr)
              end,
            },
          },
        },
        pickers = {
          buffers = {
            sort_lastused = true,
            ignore_current_buffer = false,
            mappings = {
              i = {
                -- delete buffer from the list with <C-d>
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
        },
        extensions = {
          -- fzf-native config
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Set up git-worktree, then load its Telescope extension
      pcall(function()
        require("git-worktree").setup({})
        telescope.load_extension("git_worktree")
      end)

      -- Load fzf-native if available
      pcall(function() telescope.load_extension("fzf") end)

      -- Keymaps (Telescope-specific)
      local map  = vim.keymap.set
      local base = { silent = true, noremap = true }

      map("n", "<C-p>",       tb.git_files,  vim.tbl_extend("force", base, { desc = "Git files" }))
      map("n", "<leader>pf",  tb.find_files, vim.tbl_extend("force", base, { desc = "Find files" }))
      map("n", "<leader>ps",  function()
        tb.grep_string({ search = vim.fn.input("Grep For > ") })
      end, vim.tbl_extend("force", base, { desc = "Grep (prompt)" }))

      map("n", "<leader>pw",  function()
        tb.grep_string({ search = vim.fn.expand("<cword>") })
      end, vim.tbl_extend("force", base, { desc = "Grep word under cursor" }))

      map("n", "<leader>pb",  tb.buffers,   vim.tbl_extend("force", base, { desc = "Buffers" }))
      map("n", "<leader>vh",  tb.help_tags, vim.tbl_extend("force", base, { desc = "Help tags" }))

      -- Your helper pickers from tmnj/telescope.lua
      map("n", "<leader>rr",  function() require("tmnj.telescope").refactors() end,
        vim.tbl_extend("force", base, { desc = "Refactor actions" }))

      map("n", "<leader>vrc", function() require("tmnj.telescope").search_dotfiles() end,
        vim.tbl_extend("force", base, { desc = "Search dotfiles" }))

      map("n", "<leader>gc",  function() require("tmnj.telescope").git_branches() end,
        vim.tbl_extend("force", base, { desc = "Git branches (delete with <C-d>)" }))

      map("n", "<leader>gw",  function()
        local ok, ext = pcall(function()
          return require("telescope").extensions.git_worktree
        end)
        if ok and ext then
          ext.git_worktrees()
        else
          vim.notify("git_worktree extension not loaded", vim.log.levels.WARN)
        end
      end, vim.tbl_extend("force", base, { desc = "Git worktrees" }))

      map("n", "<leader>gm",  function()
        local ok, ext = pcall(function()
          return require("telescope").extensions.git_worktree
        end)
        if ok and ext then
          ext.create_git_worktree()
        else
          vim.notify("git_worktree extension not loaded", vim.log.levels.WARN)
        end
      end, vim.tbl_extend("force", base, { desc = "Create git worktree" }))

      map("n", "<leader>td",  function() require("tmnj.telescope").dev() end,
        vim.tbl_extend("force", base, { desc = "Run dev helpers (local dev.lua)" }))
    end,
  },
}
