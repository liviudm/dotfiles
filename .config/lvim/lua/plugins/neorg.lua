return {
  "nvim-neorg/neorg",
  enabled = false,
  build = ":Neorg sync-parsers",
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          }
        },
        ["core.concealer"] = {
          config = {
            icon_preset = "varied",
          }
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default_workspace = "notes",
            open_last_workspace = "default",
          }
        },
        ["core.journal"] = {
          config = {
            workspace = "notes",
            journal_folder = "journal",
            strategy = "nested",
          }
        }
      }
    })
  end
}
