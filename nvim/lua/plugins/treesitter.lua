return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main = 'nvim-treesitter.config',
        opts = {
            ensure_installed = { 'php', 'lua', 'javascript', 'typescript', 'html', 'css', 'json' },
            highlight = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection    = '<C-space>',
                    node_incremental  = '<C-space>',
                    node_decremental  = '<C-S-space>',
                },
            },
        },
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            -- No setup needed — just ensure its queries/ dir is in runtimepath
            vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/nvim-treesitter-textobjects')
        end,
    },
}
