return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- Parsers are compiled with the tree-sitter CLI (installed by bin/setup)
    require("nvim-treesitter").install({ "markdown", "markdown_inline", "lua", "vim", "vimdoc" })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
