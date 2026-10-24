return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      local config = vim.fn.stdpath("config") .. "/markdownlint.json"
      opts.linters = opts.linters or {}
      opts.linters["markdownlint-cli2"] = {
        args = { "--config", config, "-" },
      }
    end,
  },
}
