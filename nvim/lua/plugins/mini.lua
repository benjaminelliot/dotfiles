return {
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
        require('mini.files').setup({})
        vim.keymap.set('n', '<leader>sf', function() MiniFiles.open() end, { desc = 'File picker' })
        vim.keymap.set('n', '<leader>sd', function()
            vim.ui.input({ prompt = 'Directory: ', completion = 'dir' }, function(input)
                if input then MiniFiles.open(input) end
            end)
        end, { desc = 'File picker (choose dir)' })

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
