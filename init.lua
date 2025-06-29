local lexical = require('lexical')
lexical.setup()
vim.keymap.set('n', '<leader>d', lexical.lookup_word_under_cursor, { desc = 'Lookup word definition with lexical' })