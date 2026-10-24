return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "ty")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- ty finds the project .venv (or $VIRTUAL_ENV) on its own.
        ty = {},
      },
    },
  },
}
