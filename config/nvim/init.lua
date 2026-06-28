-- Theme
vim.cmd.colorscheme("slate")
vim.api.nvim_set_hl(0, "Normal", { bg = NONE, ctermbg = NONE })
vim.api.nvim_set_hl(0, "Comment", { fg = "#87d787", ctermfg = 107, italic = true })
vim.cmd("hi MatchParen gui=underline cterm=underline guibg=NONE ctermbg=NONE guifg=NONE ctermfg=NONE")
vim.api.nvim_set_hl(0, "@markup.strikethrough", {
  strikethrough = true,
  -- optionally inherit from Normal so the color stays the same:
  link = None,
})
-- vim.opt.termguicolors = true

-- Indentation
vim.cmd("filetype plugin indent on")
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.incsearch = false

-- Leader commands
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>gr", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>hi", "<cmd>Telescope command_history<CR>", { desc = "Command history" })
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })

-- Other keymap stuff:
local opts = { silent = true }

vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)

-- Format Go files on save using LSP
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Remove trailing newline when yanking to system clipboard
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    if vim.v.event.regname == '*' or vim.v.event.regname == '+' then
      local content = vim.fn.getreg('*')
      -- Remove single trailing newline
      if content:sub(-1) == '\n' then
        vim.fn.setreg('*', content:sub(1, -2))
        vim.fn.setreg('+', content:sub(1, -2))
      end
    end
  end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {"nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }},
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "lua", "vim", "vimdoc", "html", "markdown", "go", "vue", "rust", "python" },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },
    { "tpope/vim-fugitive" },
    { "tpope/vim-rhubarb" },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        { "williamboman/mason.nvim", config = true },
        "williamboman/mason-lspconfig.nvim",
      },
      config = function()
        local lspconfig = require("lspconfig")
        local servers = { "ts_ls", "ruby_lsp", "rust_analyzer", "pyright", "gopls" }
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        require("mason-lspconfig").setup({
          ensure_installed = servers,
          automatic_installation = true,
        })

        vim.diagnostic.config({
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = '>>',
              [vim.diagnostic.severity.WARN] = '>>',
              [vim.diagnostic.severity.INFO] = '>>',
              [vim.diagnostic.severity.HINT] = '>>',
            },
          },
          virtual_text = true,
          update_in_insert = false,
        })

        local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
        local bg = normal.bg or "#171717"
        local ctermbg = normal.ctermbg or 234

        vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#ff0000", bg = bg, ctermfg = "Red", ctermbg = ctermbg })
        vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#ffa000", bg = bg, ctermfg = "Yellow", ctermbg = ctermbg })
        vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#00aaff", bg = bg, ctermfg = "Blue", ctermbg = ctermbg })
        vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#00ffff", bg = bg, ctermfg = "Cyan", ctermbg = ctermbg })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "#2a2a2a", ctermbg = "DarkGray" })

        vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = "#ff8080", ctermfg = 203 })

        vim.lsp.config('rust_analyzer', {
          capabilities = capabilities,
          settings = {
            ['rust-analyzer'] = {
              diagnostics = {
                disabled = { 'inactive-code' },
              },
            },
          },
        })
        vim.lsp.enable('rust_analyzer')
      end,
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = { "hrsh7th/cmp-nvim-lsp" },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({ select = false }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
          }),
        })
      end,
    },
    {
      "github/copilot.vim",
      cmd = "Copilot",
      build = ":Copilot setup",
    },
    {
      "nvim-lualine/lualine.nvim",
      config = function()
        local function filename_component()
          return vim.fn.expand("%:t") ~= "" and vim.fn.expand("%:t") or "[No Name]"
        end

        local function filename_color()
          if vim.bo.modified then
            return { fg = "#ffffff", bg = "#5f005f", ctermfg = 15, ctermbg = 53 }
          end
          return {}
        end

        local function ws_warning()
          local cur = vim.fn.mode():match('^i') and vim.fn.line('.') or nil
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local trailing, has_tabs, has_spaces = nil, false, false
          for i, line in ipairs(lines) do
            if not trailing and i ~= cur and line:match('%s+$') then  -- cur is nil in normal mode, so always checks
              trailing = i
            end
            if line:match('^\t') then has_tabs = true end
            if line:match('^ ') then has_spaces = true end
          end
          local parts = {}
          if trailing then table.insert(parts, string.format("trailing[%d]", trailing)) end
          if has_tabs and has_spaces then table.insert(parts, "mixed indent") end
          if #parts > 0 then return "! " .. table.concat(parts, ", ") end
          return ""
        end

        local function ws_warning_color()
          if ws_warning() ~= "" then
            return { fg = "#000000", bg = "#df5f00", ctermfg = 0, ctermbg = 166 }
          end
          return {}
        end

        require("lualine").setup({
          options = {
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            icons_enabled = true,
            theme = "powerline",
          },
          sections = {
            lualine_a = { "mode" },
            lualine_b = {},
            lualine_c = {
              { "filename", show_filename_only = false, path = 1, color = filename_color, padding = { left = 1, right = 1 } },
            },
            lualine_x = { },
            lualine_y = {},
            lualine_z = { "progress", "location", { ws_warning, color = ws_warning_color } },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = {},
            lualine_y = {},
            lualine_z = { "progress", "location" },
          },
        })
      end,
    },
    {
    "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown" },
      opts = {
        checkbox = {
          enabled = true,
          unchecked = {
            icon = "☐ ",
          },
          checked = {
            icon = "✔ ",
            scope_highlight = "@markup.strikethrough",
          },
        },
      },
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
