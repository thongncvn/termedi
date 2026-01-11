return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- 1. Bảng màu (bạn có thể chỉnh mã Hex tùy thích)
    local colors = {
      blue   = '#8aadf4', -- Normal
      green  = '#a6da95', -- Insert
      violet = '#c6a0f6', -- Visual
      yellow = '#eed49f', -- Command
      red    = '#ed8796', -- Replace
      black  = '#24273a', -- Màu chữ
    }

    -- 2. Theme tối giản: Chỉ cần định nghĩa section 'c' vì các section khác mình sẽ để trống
    local solid_theme = {
      normal = {
        c = { fg = colors.black, bg = colors.blue },
      },
      insert = {
        c = { fg = colors.black, bg = colors.green },
      },
      visual = {
        c = { fg = colors.black, bg = colors.violet },
      },
      command = {
        c = { fg = colors.black, bg = colors.yellow },
      },
      replace = {
        c = { fg = colors.black, bg = colors.red },
      },
      inactive = {
        c = { fg = '#ffffff', bg = '#333333' },
      },
    }

    require('lualine').setup({
      options = {
        theme = solid_theme,
        component_separators = '',
        section_separators = '',
        globalstatus = true,
      },
      sections = {
        -- Bỏ trống a và b để nội dung dồn hết về bên trái (section c)
        lualine_a = {}, 
        lualine_b = {}, 
 
        lualine_c = {
          {
            function()
              -- 1. Lấy tên file (đường dẫn tương đối giống path = 1)
              local fname = vim.fn.expand('%:~:.')
              if fname == '' then return '[No Name]' end

              -- 2. Kiểm tra trạng thái
              local is_mod = vim.bo.modified
              local is_ro  = vim.bo.readonly or not vim.bo.modifiable

              -- 3. Xử lý symbol
              local mod_icon = is_mod and '*' or '' -- Dấu * nếu đã sửa
              local ro_icon = is_ro and ' ' or ''  -- Icon khoá nếu readonly

              -- 4. Kết hợp (Nối chuỗi trực tiếp không dùng dấu cách)
              return fname .. mod_icon .. ro_icon
            end,

            -- Padding = 0 để sát lề trái màn hình
            padding = { left = 0, right = 0 },

            -- Giữ nguyên logic màu sắc của bạn
            color = function()
              return { gui = vim.bo.modified and 'bold' or 'none' }
            end,
          }
        },

        -- Giữ trống bên phải cho sạch
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }
    })
  end
}
