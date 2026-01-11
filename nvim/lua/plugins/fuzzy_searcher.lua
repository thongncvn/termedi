return {
  'ibhagwan/fzf-lua',
  config = function()
    require('fzf-lua').setup({
      'default',
      -- Đăng ký FzfLua làm UI handler cho code actions, etc (tắt warning)
      fzf_opts = {
        ['--layout'] = 'reverse',
      },
      winopts = {
        fullscreen = true,
        preview = {
          default = 'builtin',
          border = 'border',
          wrap = 'nowrap',
          hidden = 'nohidden',
          vertical = 'down:45%',
          horizontal = 'right:60%',
          layout = 'flex',
          flip_columns = 120,
        },
      },
      files = {
        prompt = 'Files❯ ',
        multiprocess = true,
        git_icons = false,
        file_icons = false,
        color_icons = false,
      },
      grep = {
        prompt = 'Rg❯ ',
        input_prompt = 'Grep For❯ ',
        multiprocess = true,
        git_icons = false,
        file_icons = false,
        color_icons = false,
      },
    })

    -- Đăng ký FzfLua làm UI handler global (code actions, rename, etc)
    require('fzf-lua').register_ui_select()

    -- Key mappings
    vim.keymap.set('n', '<leader>p', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
    vim.keymap.set('n', '<leader>P', '<cmd>FzfLua keymaps<cr>', { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>F', '<cmd>FzfLua live_grep<cr>', { desc = 'Live grep' })
  end,
}
