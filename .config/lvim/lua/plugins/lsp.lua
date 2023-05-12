return {
  {
    "neovim/nvim-lspconfig",
  },

  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local servers = {
        "bashls",
        "jsonls",
        "lua_ls",
        "terraformls",
        -- "tflint",
        "yamlls",
      }
      local lspconfig = require("lspconfig")
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lsp_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
        keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
        keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
        keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
        keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
      end
      local lsp_options = {
        on_attach = lsp_attach,
        flags = {
          debounce_text_changes = 150,
        },
        capabilities = lsp_capabilities,
      }
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })
      -- local get_servers = require("mason-lspconfig").get_installed_servers
      -- for _, server_name in ipairs(get_servers()) do
      --   lspconfig[server_name].setup({
      --     on_attach = lsp_attach,
      --     capabilities = lsp_capabilities,
      --   })
      -- end
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup(lsp_options)
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", lsp_options, {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          }))
        end,
        ["terraformls"] = function()
          lspconfig.terraformls.setup(vim.tbl_deep_extend("force", lsp_options, {
            cmd = { "/opt/homebrew/bin/terraform-ls", "serve" },
          }))
        end
      })
    end,
  },
}
