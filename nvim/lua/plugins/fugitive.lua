return {
    'tpope/vim-fugitive',
    lazy = false,
    priority = 200,
    config = function()
        vim.keymap.set('n', '<leader>gv', ':vertical Git status<CR>', { desc = 'Git status (vertical)' })
    end,
}
