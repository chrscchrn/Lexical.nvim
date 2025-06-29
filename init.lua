local lexical = require('lexical')

vim.keymap.set('n', '<leader>d', lexical.lookup_word_under_cursor, { desc = 'Lookup word definition with lexical' })
