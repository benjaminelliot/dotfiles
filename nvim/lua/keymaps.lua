vim.keymap.set('n', '<leader>bn', ':bnext<CR>')
vim.keymap.set('n', '<leader>bp', ':bprev<CR>')
vim.keymap.set('n', '<leader>be', ':enew<CR>')
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>')
vim.keymap.set('n', '<leader>yp', function()
    local loc = vim.fn.expand('%:p') .. ':' .. vim.fn.line('.')
    vim.fn.setreg('+', loc)
    vim.notify('Copied: ' .. loc)
end, { desc = 'Copy file path and line number' })

-- Test runner keymaps (configured per-project via .nvim.lua)
local function run_test(filter_method)
    if not _G.LazTest then
        vim.notify('No test runner configured for this project', vim.log.levels.WARN)
        return
    end
    -- Support a list of configs, each with an optional path_pattern.
    -- The first config whose path_pattern matches the current file is used.
    -- A config without path_pattern acts as a fallback/catch-all.
    local config = _G.LazTest
    if vim.islist(_G.LazTest) then
        local file = vim.fn.expand('%:p')
        for _, c in ipairs(_G.LazTest) do
            if not c.path_pattern or file:find(c.path_pattern, 1, true) then
                config = c
                break
            end
        end
    end
    if not config.cmd then
        vim.notify('No test runner configured for this project', vim.log.levels.WARN)
        return
    end
    local rel_path = vim.fn.expand('%:p'):gsub('^' .. config.base_path, '')
    local cmd = config.cmd .. ' ' .. rel_path
    if filter_method then
        local line = vim.fn.search('function test', 'bnW')
        local method = line ~= 0 and vim.fn.getline(line):match('function%s+(%w+)')
        if method then cmd = cmd .. ' --filter ' .. method end
    end
    vim.cmd('botright split | resize 20 | terminal ' .. cmd)
end

vim.keymap.set('n', '<leader>tf', function() run_test(false) end, { desc = 'Run test file' })
vim.keymap.set('n', '<leader>tm', function() run_test(true)  end, { desc = 'Run test method' })
