-- ============================================================================
-- CẤU HÌNH: Thêm/xóa LSP servers tại đây
-- ============================================================================
-- Danh sách servers sẽ tự động cài đặt khi khởi động Neovim
-- Tìm thêm LSP servers tại: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers

local LSP_SERVERS = {
  "lua_ls",    -- Lua
  "pyright",   -- Python
  "ts_ls",     -- TypeScript/JavaScript
  "ruby_lsp",  -- Ruby
  -- Uncomment để thêm hỗ trợ các ngôn ngữ khác:
  -- "gopls",         -- Go
  -- "rust_analyzer", -- Rust
  -- "clangd",        -- C/C++
  -- "zls",           -- Zig
  -- "html",          -- HTML
  -- "cssls",         -- CSS
  -- "jsonls",        -- JSON
  -- "tailwindcss",   -- Tailwind CSS
}

-- ============================================================================

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Autocomplete dependencies
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",     -- LSP source
        "hrsh7th/cmp-buffer",       -- Buffer source
        "hrsh7th/cmp-path",         -- Path source
        "L3MON4D3/LuaSnip",         -- Snippet engine
        "saadparwaiz1/cmp_luasnip", -- Snippet source
      },
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },

          mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          }),

          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
          }),
        })
      end,
    },

    "ibhagwan/fzf-lua", -- Dùng fzf-lua để hiển thị kết quả tìm kiếm
  },
  config = function()
    -- 1. Setup Mason (Quản lý cài đặt server)
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    -- 2. Chuẩn bị Capabilities (Khả năng) để giao tiếp với nvim-cmp
    -- (Giúp LSP biết là Editor có thể hiển thị menu gợi ý code)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- 3. Setup Mason-Lspconfig với handlers tự động
    require("mason-lspconfig").setup({
      ensure_installed = LSP_SERVERS, -- Sử dụng danh sách ở đầu file
      automatic_installation = true,

      -- Handler mặc định: Tự động setup TẤT CẢ language servers
      handlers = {
        -- Handler mặc định cho tất cả servers
        function(server_name)
          vim.lsp.config(server_name, {
            capabilities = capabilities,
          })
          vim.lsp.enable(server_name)
        end,

        -- Override riêng cho Lua (cần config đặc biệt)
        ["lua_ls"] = function()
          vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } }, -- Đỡ báo lỗi biến 'vim'
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              },
            },
          })
          vim.lsp.enable('lua_ls')
        end,

        -- Override riêng cho Python (nếu muốn custom)
        ["pyright"] = function()
          vim.lsp.config('pyright', {
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic", -- hoặc "off" nếu thấy quá ồn ào
                }
              }
            }
          })
          vim.lsp.enable('pyright')
        end,
      }
    })

    -- 5. PHÍM TẮT (KEYMAPPING) - PHẦN QUAN TRỌNG NHẤT
    -- Chỉ map phím khi LSP đã attach vào buffer hiện tại
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Helper function để map phím gọn hơn
        local function map(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'LSP: ' .. desc })
        end

        local fzf = require('fzf-lua')

        -- === NHÓM PHÍM GIỐNG VS CODE ===

        map('gd', fzf.lsp_definitions, '[G]o to [D]efinition')
        map('gr', fzf.lsp_references, '[G]o to [R]eferences')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', fzf.lsp_code_actions, '[C]ode [A]ction')
        map('<leader>.', fzf.lsp_code_actions, 'Code Action (VSCode style)')

        -- === CÁC PHÍM KHÁC ===

        -- K: Hover Documentation (Xem tài liệu)
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- gl: Show diagnostic (Xem lỗi/cảnh báo tại dòng hiện tại)
        map('gl', vim.diagnostic.open_float, 'Show [L]ine Diagnostics')

        -- [d và ]d: Di chuyển giữa các lỗi
        map('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
        map(']d', vim.diagnostic.goto_next, 'Next Diagnostic')

        -- <leader>oi: Organize Imports (Sắp xếp imports)
        map('<leader>oi', function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "source.organizeImports" },
              diagnostics = {},
            },
          })
        end, '[O]rganize [I]mports')
      end,
    })

    -- Cấu hình hiển thị diagnostics
    vim.diagnostic.config({
      virtual_text = true,  -- Hiển thị lỗi inline
      signs = true,         -- Hiển thị icon bên trái
      update_in_insert = false, -- Không update khi đang gõ
      underline = true,     -- Gạch chân lỗi
      severity_sort = true, -- Sắp xếp theo mức độ nghiêm trọng
      float = {
        border = 'rounded',
        source = 'always',  -- Luôn hiển thị nguồn (LSP server name)
        header = '',
        prefix = '',
      },
    })

    -- Thêm icon cho diagnostics
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end,
}
