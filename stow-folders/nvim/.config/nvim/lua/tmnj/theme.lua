vim.o.termguicolors = true
require('colorizer').setup()

vim.api.nvim_set_hl(0, 'CopilotSuggestion', { fg = '#eb4034' })
vim.api.nvim_set_hl(0, 'CopilotAnnotation', { fg = '#eb4034' })
