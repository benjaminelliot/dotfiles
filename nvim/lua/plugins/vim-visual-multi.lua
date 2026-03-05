return {
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
}
