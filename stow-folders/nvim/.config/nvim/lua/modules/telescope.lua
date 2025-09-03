-- lua/tmnj/telescope.lua
local pickers      = require("telescope.pickers")
local finders      = require("telescope.finders")
local previewers   = require("telescope.previewers")

local action_state = require("telescope.actions.state")
local conf         = require("telescope.config").values
local actions      = require("telescope.actions")

local M = {}

-- Setup + keymaps (call from your lazy.nvim plugin config)
function M.setup()
  require("telescope").setup({
    defaults = {
      file_sorter      = require("telescope.sorters").get_fzy_sorter,
      prompt_prefix    = " >",
      color_devicons   = true,

      file_previewer   = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer   = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

      mappings = {
        i = {
          ["<C-x>"] = false,
          ["<C-q>"] = actions.send_to_qflist,
        },
      },
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })

  -- Extensions (don’t fail if missing)
  pcall(function() require("telescope").load_extension("git_worktree") end)
  pcall(function() require("telescope").load_extension("fzy_native") end)

  -- Keymaps (Lua equivalents of your nnoremap lines)
  local tb = require("telescope.builtin")
  local map, base = vim.keymap.set, { silent = true, noremap = true }

  map("n", "<leader>rr", function() require("tmnj.telescope").refactors() end,
    vim.tbl_extend("force", base, { desc = "Refactor actions (telescope)" }))

  map("n", "<leader>ps", function()
    tb.grep_string({ search = vim.fn.input("Grep For > ") })
  end, vim.tbl_extend("force", base, { desc = "Grep (prompt)" }))

  map("n", "<C-p>",       tb.git_files,  vim.tbl_extend("force", base, { desc = "Git files" }))
  map("n", "<leader>pf",  tb.find_files, vim.tbl_extend("force", base, { desc = "Find files" }))
  map("n", "<leader>pw", function()
    tb.grep_string({ search = vim.fn.expand("<cword>") })
  end, vim.tbl_extend("force", base, { desc = "Grep word under cursor" }))
  map("n", "<leader>pb",  tb.buffers,   vim.tbl_extend("force", base, { desc = "Buffers" }))
  map("n", "<leader>vh",  tb.help_tags, vim.tbl_extend("force", base, { desc = "Help tags" }))

  map("n", "<leader>vrc", function() require("tmnj.telescope").search_dotfiles() end,
    vim.tbl_extend("force", base, { desc = "Search dotfiles" }))
  map("n", "<leader>gc", function() require("tmnj.telescope").git_branches() end,
    vim.tbl_extend("force", base, { desc = "Git branches (delete with <C-d>)" }))

  -- git-worktree (guard for extension availability)
  map("n", "<leader>gw", function()
    local ok, ext = pcall(function() return require("telescope").extensions.git_worktree end)
    if ok and ext then ext.git_worktrees() else vim.notify("git_worktree extension not loaded", vim.log.levels.WARN) end
  end, vim.tbl_extend("force", base, { desc = "Git worktrees" }))

  map("n", "<leader>gm", function()
    local ok, ext = pcall(function() return require("telescope").extensions.git_worktree end)
    if ok and ext then ext.create_git_worktree() else vim.notify("git_worktree extension not loaded", vim.log.levels.WARN) end
  end, vim.tbl_extend("force", base, { desc = "Create git worktree" }))

  map("n", "<leader>td", function() require("tmnj.telescope").dev() end,
    vim.tbl_extend("force", base, { desc = "Run dev helpers (local dev.lua)" }))
end

-- ===== The helper functions you already had =====
function M.search_dotfiles()
  require("telescope.builtin").find_files({
    prompt_title = "< VimRC >",
    cwd = vim.env.DOTFILES,
    hidden = true,
  })
end

local function refactor(prompt_bufnr)
  local content = action_state.get_selected_entry(prompt_bufnr)
  actions.close(prompt_bufnr)
  require("refactoring").refactor(content.value)
end

function M.refactors()
  pickers.new({}, {
    prompt_title = "refactors",
    finder = finders.new_table({
      results = require("refactoring").get_refactors(),
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      map("i", "<CR>", refactor)
      map("n", "<CR>", refactor)
      return true
    end,
  }):find()
end

function M.git_branches()
  require("telescope.builtin").git_branches({
    attach_mappings = function(_, map)
      map("i", "<c-d>", actions.git_delete_branch)
      map("n", "<c-d>", actions.git_delete_branch)
      return true
    end,
  })
end

function M.dev(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.loop.fs_realpath(vim.loop.cwd())

  local possible_files = vim.api.nvim_get_runtime_file("/lua/**/dev.lua", true)
  local local_files = {}
  for _, raw_f in ipairs(possible_files) do
    local real_f = vim.loop.fs_realpath(raw_f)
    if string.find(real_f, opts.cwd, 1, true) then
      table.insert(local_files, real_f)
    end
  end

  local dev = local_files[1]
  local loaded = dev and loadfile(dev)
  if not loaded then
    print("No dev.lua found near CWD")
    return
  end
  local ok, mod = pcall(loaded)
  if not ok then
    print("===================================================")
    print("YOUR CODE DOESN'T WORK")
    print("===================================================")
    return
  end

  local objs = {}
  for k, v in pairs(mod) do
    local debug_info = debug.getinfo(v)
    table.insert(objs, { filename = string.sub(debug_info.source, 2), text = k })
  end

  local mod_name = vim.split(dev, "/lua/")
  if #mod_name ~= 2 then
    print("===================================================")
    print("I DO NOT KNOW HOW TO FIND THIS FILE:")
    print(dev)
    print("===================================================")
  end
  mod_name = string.gsub(mod_name[2], ".lua$", "")
  mod_name = string.gsub(mod_name, "/", ".")

  pickers.new({
    finder = finders.new_table({
      results = objs,
      entry_maker = function(entry)
        return {
          value = entry,
          text = entry.text,
          display = entry.text,
          ordinal = entry.text,
          filename = entry.filename,
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    previewer = previewers.builtin.new(opts),
    attach_mappings = function(_, map)
      actions.select_default:replace(function(...)
        local entry = action_state.get_selected_entry()
        actions.close(...)
        mod[entry.value.text]()
      end)

      map("i", "<tab>", function(...)
        local entry = action_state.get_selected_entry()
        actions.close(...)
        vim.schedule(function()
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes(
              string.format("<esc>:lua require('%s').%s()<CR>", mod_name, entry.value.text),
              true, false, true
            ),
            "n",
            true
          )
        end)
      end)

      return true
    end,
  }):find()
end

return M
