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
        vim.keymap.set('n', '<leader>fb', function()
            builtin.buffers({
                attach_mappings = function(_, map)
                    map('n', '<C-d>', require('telescope.actions').delete_buffer)
                    map('i', '<C-d>', require('telescope.actions').delete_buffer)
                    return true
                end,
            })
        end, { desc = 'Buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags,   { desc = 'Help tags' })

        -- Scoped search: OG PHP
        local og_dirs = {
            'k12/lazphp/www/html/accounts',
            'k12/lazphp/www/html/internal',
            'k12/lazphp/www/html/objects',
            'k12/lazphp/www/html/kidsa-z',
            'k12/lazphp/www/html/kurzwebify',
            'k12/lazphp/www/html/kurzweil',
            'k12/lazphp/www/scripts',
        }
        vim.keymap.set('n', '<leader>fo', function() builtin.find_files({ search_dirs = og_dirs }) end, { desc = 'Find files (OG PHP)' })
        vim.keymap.set('n', '<leader>go', function() lga.live_grep_args({ search_dirs = og_dirs }) end,  { desc = 'Grep (OG PHP)' })

        -- Scoped search: NG PHP (Laravel backend)
        local ng_dirs = { 'k12/lazphp/www/html/ng/backend' }
        vim.keymap.set('n', '<leader>fn', function() builtin.find_files({ search_dirs = ng_dirs }) end, { desc = 'Find files (NG PHP)' })
        vim.keymap.set('n', '<leader>gn', function() lga.live_grep_args({ search_dirs = ng_dirs }) end,  { desc = 'Grep (NG PHP)' })

        -- Scoped search: Java webs (*web dirs, excluding generated WSDL in .bin/)
        local java_web_dirs = {
            'k12/kepler/accountsweb',
            'k12/kepler/fireflyweb',
            'k12/kepler/fsweb',
            'k12/kepler/mdrweb',
            'k12/kepler/rkweb',
            'k12/kepler/salesforceweb',
        }
        vim.keymap.set('n', '<leader>fw', function() builtin.find_files({ search_dirs = java_web_dirs }) end, { desc = 'Find files (Java webs)' })
        vim.keymap.set('n', '<leader>gw', function() lga.live_grep_args({ search_dirs = java_web_dirs }) end,  { desc = 'Grep (Java webs)' })

        -- Scoped search: Java backs (*back dirs + shared)
        local java_back_dirs = {
            'k12/kepler/accountsback',
            'k12/kepler/arback',
            'k12/kepler/fireflyback',
            'k12/kepler/fsback',
            'k12/kepler/rkback',
            'k12/kepler/salesforceback',
            'k12/kepler/shared',
        }
        vim.keymap.set('n', '<leader>fj', function() builtin.find_files({ search_dirs = java_back_dirs }) end, { desc = 'Find files (Java backs)' })
        vim.keymap.set('n', '<leader>gj', function() lga.live_grep_args({ search_dirs = java_back_dirs }) end,  { desc = 'Grep (Java backs)' })
        vim.keymap.set('n', 'gr',         builtin.lsp_references,       { desc = 'References' })
        vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols,  { desc = 'Document symbols' })
        vim.keymap.set('n', '<leader>fS', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })
    end,
}
