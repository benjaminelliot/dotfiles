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
vim.opt.swapfile = false
vim.opt.exrc = true

-- Load .nvim.lua by walking up from the current file's directory
local _loaded_nvim_lua = {}
vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
        local dir = vim.fn.expand('%:p:h')
        while dir ~= '/' do
            local config = dir .. '/.nvim.lua'
            if vim.fn.filereadable(config) == 1 and not _loaded_nvim_lua[config] then
                _loaded_nvim_lua[config] = true
                local content = vim.secure.read(config)
                if content then load(content)() end
                break
            end
            local parent = vim.fn.fnamemodify(dir, ':h')
            if parent == dir then break end
            dir = parent
        end
    end,
})
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
    { 'tpope/vim-fugitive', lazy = false, priority = 200 },
    {
        'mg979/vim-visual-multi',
        init = function()
            vim.g.VM_maps = {
                ['Find Under']         = '<C-n>',
                ['Find Subword Under'] = '<C-n>',
                ['Select All']         = '<C-M-n>',
            }
            -- Also try to map Alt+J if the terminal supports it
            vim.g.VM_custom_remaps = { ['<M-j>'] = '<C-n>' }
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            current_line_blame = true,
            current_line_blame_opts = { delay = 500 },
        },
    },
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
vim.keymap.set('n', '<leader>yp', function()
    local loc = vim.fn.expand('%:p') .. ':' .. vim.fn.line('.')
    vim.fn.setreg('+', loc)
    vim.notify('Copied: ' .. loc)
end, { desc = 'Copy file path and line number' })


-- Fugitive keymaps
vim.keymap.set('n', '<leader>gv', ':vertical Git status<CR>')

-- Test runner keymaps (configured per-project via .nvim.lua)
local function run_test(filter_method)
    if not (_G.LazTest and _G.LazTest.cmd) then
        vim.notify('No test runner configured for this project', vim.log.levels.WARN)
        return
    end
    local rel_path = vim.fn.expand('%:p'):gsub('^' .. _G.LazTest.base_path, '')
    local cmd = _G.LazTest.cmd .. ' ' .. rel_path
    if filter_method then
        local line = vim.fn.search('function test', 'bnW')
        local method = line ~= 0 and vim.fn.getline(line):match('function%s+(%w+)')
        if method then cmd = cmd .. ' --filter ' .. method end
    end
    vim.cmd('botright split | resize 20 | terminal ' .. cmd)
end

vim.keymap.set('n', '<leader>tf', function() run_test(false) end, { desc = 'Run test file' })
vim.keymap.set('n', '<leader>tm', function() run_test(true)  end, { desc = 'Run test method' })

-- Gitsigns keymaps
local gs = require('gitsigns')
vim.keymap.set('n', '<leader>gb', gs.blame_line,                              { desc = 'Git blame line' })
vim.keymap.set('n', '<leader>gB', function() gs.blame_line({ full = true }) end, { desc = 'Git blame line (full)' })
vim.keymap.set('n', '<leader>gd', function()
    local file = vim.fn.expand('%:p')
    local line = vim.fn.line('.')
    local sha = vim.fn.system('git blame -L ' .. line .. ',' .. line .. ' --porcelain ' .. vim.fn.shellescape(file) .. ' | head -1 | cut -d" " -f1')
    sha = sha:gsub('%s+', '')
    if #sha == 40 then
        vim.cmd('Git show ' .. sha)
    end
end, { desc = 'Git show commit diff' })

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
