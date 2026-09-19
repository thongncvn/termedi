return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = "markdown",
  opts = {
    -- No Nerd Font: keep everything plain text
    heading = { icons = {}, sign = false },
    code = { sign = false, language_icon = false },
    checkbox = {
      unchecked = { icon = "[ ]" },
      checked = { icon = "[x]" },
      custom = { todo = { raw = "[-]", rendered = "[-]", highlight = "RenderMarkdownTodo" } },
    },
    link = { image = "", email = "", hyperlink = "", custom = { web = { pattern = "^http", icon = "" } } },
  },
}
