vim.opt.foldlevel = 4

vim.api.nvim_create_autocmd({ 'FileType' }, {
  callback = function()
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
  end,
})
