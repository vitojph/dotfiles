return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            if not config.root_dir then
              return
            end
            local venv_python = vim.fs.joinpath(config.root_dir, ".venv", "bin", "python")
            if vim.fn.executable(venv_python) == 1 then
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = venv_python
            end
          end,
        },
      },
    },
  },
}
