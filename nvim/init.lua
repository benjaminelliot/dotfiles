vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.g.have_nerd_font = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoread = true
vim.opt.updatetime = 500
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    command = "checktime",
})

require("lazy").setup({
    {
        "rebelot/kanagawa.nvim", name = "kanagawa", priority = 1000,
        opts = { theme = "wave" },
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
    { 'tpope/vim-fugitive' },
    {
        'nvim-tree/nvim-web-devicons',
        opts = { default = true },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = { theme = 'kanagawa', icons_enabled = true },
        },
    },
    {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'default' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}
})

vim.cmd.colorscheme("kanagawa")

-- Other keymaps
vim.keymap.set('n', '<leader>bn', ':bnext<CR>')
vim.keymap.set('n', '<leader>bp', ':bprev<CR>')
vim.keymap.set('n', '<leader>be', ':enew<CR>')
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>')


-- Fugitive keymaps
vim.keymap.set('n', '<leader>gv', ':vertical Git<CR>')

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files,  { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep,   { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers,     { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags,   { desc = 'Help tags' })

-- LSP keymaps (set when an LSP attaches to a buffer)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,      vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
        vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration,     vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
        vim.keymap.set('n', 'gr',         vim.lsp.buf.references,      vim.tbl_extend('force', opts, { desc = 'References' }))
        vim.keymap.set('n', 'K',          vim.lsp.buf.hover,           vim.tbl_extend('force', opts, { desc = 'Hover docs' }))
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,          vim.tbl_extend('force', opts, { desc = 'Rename' }))
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,     vim.tbl_extend('force', opts, { desc = 'Code action' }))
        vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,    vim.tbl_extend('force', opts, { desc = 'Prev diagnostic' }))
        vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,    vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))
    end,
})

-- PHP: Intelephense (native nvim 0.11+ LSP API)
vim.lsp.config('intelephense', {
    cmd = { 'intelephense', '--stdio' },
    filetypes = { 'php' },
    root_markers = { 'composer.json', '.git' },
})
vim.lsp.enable('intelephense')
