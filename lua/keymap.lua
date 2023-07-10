local wo = vim.wo
local lsp = vim.lsp.buf

local dot_repeat = require('dot_repeat')
local l = require('lazyload')

local telescope = function(action, opts)
    return function() l.require('telescope.builtin')[action](opts) end
end

for _, keymap in ipairs({
    { '', '<C-/>g', telescope('live_grep') },
    { '', '<C-/>m', telescope('help_tags') },
    { '', '<C-/>t', telescope('find_files') },
    {
        '',
        '<C-/>z',
        telescope('buffers', { ignore_current_buffer = true, sort_mru = true }),
    },
    { '', '<Tab>a', lsp.code_action },
    { '', '<Tab>m', lsp.hover },
    { '', '<Tab>p', lsp.rename },
    { '', '<Tab>t', lsp.format },
    { '', '<Leader>b', ':TroubleToggle<CR>' },
    { '', '<Leader>d', dot_repeat.mk_cmd('Commentary', { cmdtype = 'range' }) },
    { '', '<Leader>t', lsp.format },
    {
        '',
        '<C-X>',
        function()
            local fm = wo.foldmethod
            wo.foldmethod = 'expr'
            vim.cmd.normal({ args = { 'zx' }, bang = true })
            wo.foldmethod = fm
        end,
    },
    { 'n', '<A-e>', dot_repeat.mk_cmd("move .-2") },
    { 'n', '<A-n>', dot_repeat.mk_cmd("move .+1") },
    { 'n', '<Space>', lsp.hover },
}) do
    local modes, lhs, rhs, opts = unpack(keymap)
    ---@diagnostic disable-next-line: cast-local-type
    modes = vim.fn.split(modes, '\\zs')
    modes[1] = modes[1] or ''
    for _, mode in ipairs(modes)
    do
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end