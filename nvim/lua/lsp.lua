-- LSP keymaps (set when an LSP attaches to a buffer)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,     vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
        vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration,    vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
        vim.keymap.set('n', 'gI',         vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
        vim.keymap.set('n', 'gT',         vim.lsp.buf.type_definition,vim.tbl_extend('force', opts, { desc = 'Go to type definition' }))
        vim.keymap.set('n', 'gr',         vim.lsp.buf.references,     vim.tbl_extend('force', opts, { desc = 'References' }))
        vim.keymap.set('n', 'K',          vim.lsp.buf.hover,          vim.tbl_extend('force', opts, { desc = 'Hover docs' }))
        vim.keymap.set('i', '<C-k>',      vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature help' }))
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,         vim.tbl_extend('force', opts, { desc = 'Rename' }))
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,    vim.tbl_extend('force', opts, { desc = 'Code action' }))
        vim.keymap.set('n', '<leader>e',  vim.diagnostic.open_float,  vim.tbl_extend('force', opts, { desc = 'Show diagnostic' }))
        vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,   vim.tbl_extend('force', opts, { desc = 'Prev diagnostic' }))
        vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,   vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))
    end,
})

-- PHP: Intelephense (native nvim 0.11+ LSP API)
-- Give Node more heap so intelephense doesn't OOM on large projects (e.g. vendor/)
vim.env.NODE_OPTIONS = '--max-old-space-size=4096'

local ok, secrets = pcall(require, 'secrets')
if not ok then secrets = {} end

vim.lsp.config('intelephense', {
    cmd          = { 'intelephense', '--stdio' },
    filetypes    = { 'php' },
    init_options = { licenceKey = secrets.intelephense_licence_key },
    root_markers = { 'composer.json', '.git' },
    settings = {
        intelephense = {
            diagnostics = { enable = true },
            completion  = { triggerParameterHints = true },
            files = {
                -- Don't index vendor/ or node_modules/ — they're the main OOM culprit
                exclude = {
                    '**/.git/**',
                    '**/node_modules/**',
                    '**/storage/**',
                },
            },
        },
    },
})

vim.lsp.enable('intelephense')
