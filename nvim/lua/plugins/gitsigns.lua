return {
    'lewis6991/gitsigns.nvim',
    opts = {
        current_line_blame = true,
        current_line_blame_opts = { delay = 500 },
    },
    config = function(_, opts)
        local gs = require('gitsigns')
        gs.setup(opts)
        vim.keymap.set('n', '<leader>gb', gs.blame_line,                              { desc = 'Git blame line' })
        vim.keymap.set('n', '<leader>gB', function() gs.blame_line({ full = true }) end, { desc = 'Git blame line (full)' })
        vim.keymap.set('n', '<leader>gd', function()
            local file = vim.fn.expand('%:p')
            local line = vim.fn.line('.')
            local sha = vim.fn.system('git blame -L ' .. line .. ',' .. line .. ' --porcelain ' .. vim.fn.shellescape(file) .. ' | head -1 | cut -d" " -f1')
            sha = sha:gsub('%s+', '')
            if #sha == 40 then vim.cmd('Git show ' .. sha) end
        end, { desc = 'Git show commit diff' })
    end
}
