-- Reload file when it changes on disk (pairs with vim.opt.autoread)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    command = "checktime",
})

-- Ensure treesitter parses the buffer on open so plugins like mini.ai can query it
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'php', 'lua', 'javascript', 'typescript', 'html', 'css', 'json' },
    callback = function(ev)
        vim.treesitter.start(ev.buf)
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
