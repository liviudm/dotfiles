local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- needed by many other plugins
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  -- import everythung from the plugins folder
  { import = "plugins" },
}

local opts = {
  install = {
    missing = true,
    colorscheme = { "tokyonight" },
  },
  checker = {
    enabled = true,
  },
}

require("lazy").setup(plugins, opts)
