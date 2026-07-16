return {
  {
    'adalessa/laravel.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-neotest/nvim-nio',
    },
    ft = { 'php', 'blade' },
    event = { 'BufEnter composer.json' },
    keys = {
      { '<leader>ll', function() Laravel.pickers.laravel() end,  desc = 'Laravel: Picker' },
      { '<leader>la', function() Laravel.pickers.artisan() end,  desc = 'Laravel: Artisan Picker' },
      { '<leader>lr', function() Laravel.pickers.routes() end,   desc = 'Laravel: Routes Picker' },
      { '<leader>lm', function() Laravel.pickers.make() end,     desc = 'Laravel: Make Picker' },
    },
    opts = {
      features = {
        pickers = {
          provider = 'telescope',
        },
      },
    },
  },
}
