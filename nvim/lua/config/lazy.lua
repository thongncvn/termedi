-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.termguicolors = true
vim.opt.cmdheight = 0
vim.opt.linebreak = true

-- Line numbers
vim.opt.number = true         -- Hiển thị số dòng
vim.opt.relativenumber = true -- Số dòng tương đối (relative)
vim.opt.signcolumn = "yes"    -- Luôn hiển thị cột dấu (không bị nhảy khi có lỗi)

-- Tab settings: use 2 spaces
vim.opt.tabstop = 2       -- Number of spaces a tab counts for
vim.opt.shiftwidth = 2    -- Number of spaces for auto-indent
vim.opt.softtabstop = 2   -- Number of spaces for <Tab> and <BS>
vim.opt.expandtab = true  -- Use spaces instead of tabs

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
  ui = {
    icons = {
      cmd = ">",
      config = "@",
      event = "!",
      ft = "T",
      init = ".",
      keys = "k",
      plugin = "*",
      runtime = "r",
      require = "&",
      source = "-",
      start = "^",
      task = "#",
      lazy = "z",
    },
  },
})
