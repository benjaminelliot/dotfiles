return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-live-grep-args.nvim',
    },
    config = function()
        require('telescope').load_extension('live_grep_args')

        local builtin = require('telescope.builtin')
        local lga = require('telescope').extensions.live_grep_args
        vim.keymap.set('n', '<leader>ff', builtin.find_files,  { desc = 'Find files' })
        vim.keymap.set('n', '<leader>fg', lga.live_grep_args,  { desc = 'Live grep' })
        vim.keymap.set('n', '<leader>fF', function() builtin.find_files({ hidden = true, no_ignore = true }) end, { desc = 'Find files (all)' })
        vim.keymap.set('n', '<leader>fG', function() lga.live_grep_args({ additional_args = { '--no-ignore', '--hidden' } }) end, { desc = 'Live grep (all)' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers,     { desc = 'Buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags,   { desc = 'Help tags' })
        vim.keymap.set('n', 'gr',         builtin.lsp_references,       { desc = 'References' })
        vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols,  { desc = 'Document symbols' })
        vim.keymap.set('n', '<leader>fS', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })
    end,
}
