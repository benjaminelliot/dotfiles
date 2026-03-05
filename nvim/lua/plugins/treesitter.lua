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
            -- Ensure its queries/ dir is in runtimepath
            vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/nvim-treesitter-textobjects')

            local move = require('nvim-treesitter-textobjects.move')
            local maps = {
                { key = ']f', fn = move.goto_next_start,     arg = '@function.outer', desc = 'Next function start' },
                { key = ']a', fn = move.goto_next_start,     arg = '@parameter.inner', desc = 'Next parameter' },
                { key = ']c', fn = move.goto_next_start,     arg = '@class.outer',    desc = 'Next class start' },
                { key = ']F', fn = move.goto_next_end,       arg = '@function.outer', desc = 'Next function end' },
                { key = '[f', fn = move.goto_previous_start, arg = '@function.outer', desc = 'Prev function start' },
                { key = '[a', fn = move.goto_previous_start, arg = '@parameter.inner', desc = 'Prev parameter' },
                { key = '[c', fn = move.goto_previous_start, arg = '@class.outer',    desc = 'Prev class start' },
                { key = '[F', fn = move.goto_previous_end,   arg = '@function.outer', desc = 'Prev function end' },
            }
            for _, m in ipairs(maps) do
                vim.keymap.set('n', m.key, function() m.fn(m.arg) end, { desc = m.desc })
            end
        end,
    },
}
