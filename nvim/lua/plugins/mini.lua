return {
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
        require('mini.files').setup({})
        vim.keymap.set('n', '<leader>sf', function() MiniFiles.open() end, { desc = 'File picker' })

        require('mini.surround').setup()

        local ai = require('mini.ai')
        ai.setup({
            custom_textobjects = {
                f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
                c = ai.gen_spec.treesitter({ a = '@class.outer',    i = '@class.inner'    }),
            },
        })
    end,
}
