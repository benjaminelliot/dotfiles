-- Reload file when it changes on disk (pairs with vim.opt.autoread)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    command = "checktime",
})

-- Open a terminal on the left at 20% width on startup
-- vim.api.nvim_create_autocmd('VimEnter', {
--     once = true,
--     callback = function()
--         local width = math.floor(vim.o.columns * 0.30)
--         vim.cmd('topleft ' .. width .. 'vsplit | terminal')
--         vim.cmd('wincmd l')
--     end,
-- })

-- Ensure treesitter parses the buffer on open so plugins like mini.ai can query it
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'php', 'lua', 'javascript', 'typescript', 'html', 'css', 'json' },
    callback = function(ev)
        local filetype = vim.bo[ev.buf].filetype
        local lang = vim.treesitter.language.get_lang(filetype) or filetype
        if #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.so', false) > 0 then
            vim.treesitter.start(ev.buf, lang)
        end
    end,
})

-- In Fugitive buffers, open the working tree version of the file under cursor
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'fugitive', 'git' },
    callback = function()
        vim.keymap.set('n', '<leader>e', function()
            local cfile = vim.fn.expand('<cfile>')
            cfile = cfile:gsub('^[ab]/', '') -- strip git diff a/ b/ prefix
            if vim.fn.filereadable(cfile) == 1 then
                vim.cmd('edit ' .. vim.fn.fnameescape(cfile))
            else
                vim.notify('File not found: ' .. cfile, vim.log.levels.WARN)
            end
        end, { buffer = true, desc = 'Edit working tree file under cursor' })
    end,
})

-- Load .nvim.lua by walking up from the current file's directory.
-- Handles monorepos and projects opened from outside the project root.
local _loaded_nvim_lua = {}
vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
        local dir = vim.fn.expand('%:p:h')
        while dir ~= '/' do
            local config = dir .. '/.nvim.lua'
            if vim.fn.filereadable(config) == 1 and not _loaded_nvim_lua[config] then
                _loaded_nvim_lua[config] = true
                local content = vim.secure.read(config)
                if content then load(content)() end
                break
            end
            local parent = vim.fn.fnamemodify(dir, ':h')
            if parent == dir then break end
            dir = parent
        end
    end,
})
