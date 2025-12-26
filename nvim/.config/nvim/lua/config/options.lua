--cursor line and relative number
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true

-- Change linecolors
vim.cmd [[
  highlight LineNr guifg=#e0af56 gui=bold " relative numbers
  highlight CursorLineNr guifg=#e0af68 gui=bold " current line
]]

--shift spacing
vim.opt.shiftwidth = 3

-- Show which line your cursor is on
vim.opt.cursorline = true

--line wrap and break
vim.opt.wrap = true
vim.opt.linebreak = true

-- use system clipboard for all yank, delete, change, put operations
vim.opt.clipboard = "unnamedplus"
