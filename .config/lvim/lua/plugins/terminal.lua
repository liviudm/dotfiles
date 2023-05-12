return {
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.cmd([[
        noremap <silent> <c-h> :<C-U>TmuxNavigateLeft<cr>
        noremap <silent> <c-j> :<C-U>TmuxNavigateDown<cr>
        noremap <silent> <c-k> :<C-U>TmuxNavigateUp<cr>
        noremap <silent> <c-l> :<C-U>TmuxNavigateRight<cr>
        noremap <silent> <c-\> :<C-U>TmuxNavigatePrevious<cr>
      ]])
    end
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    lazy = false,
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Open Terminal", mode = "n" },
    },
    config = function()
      local opts = { silent = true }
      local keymap = vim.api.nvim_set_keymap
      keymap("t", '<esc>', [[<C-\><C-n>]], opts)
      -- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", opts)
      -- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", opts)
      -- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", opts)
      -- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", opts)
      require("toggleterm").setup({
        hide_numbers = true,
        persist_size = false,
        direction = "horizontal",
        size = 20,
        shade_terminals = false,
      })
    end
  }
}
