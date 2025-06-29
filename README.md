# lexical.nvim

A Neovim plugin to get word definitions using the [`lexical`](https://github.com/chrscchrn/lexical) Python CLI tool.

## Features
- Press `<leader>d` to get the definition of the word under the cursor in a floating window.
- Automatically installs `lexical` from GitHub if not present (requires `pip`).

## Requirements
- Neovim 0.5+
- Python 3 with `pip` available in your `$PATH`

## Installation
Place this repo in your Neovim `runtimepath`, e.g.:

```
# Using packer.nvim
use({ 'your-username/lexical.nvim', rtp = '.' })

# Or clone directly
git clone https://github.com/your-username/lexical.nvim ~/.config/nvim/pack/plugins/start/lexical.nvim
```

The plugin will try to install the `lexical` CLI from GitHub using pip automatically on first use. If you have issues, you can install it manually:

```
pip install git+https://github.com/chrscchrn/lexical
```

## Usage
- Open a file in Neovim
- Move the cursor over a word
- Press `<leader>d`
- The definition will appear in a floating window

## Troubleshooting
- If you see errors about missing `pip` or permissions, install `lexical` manually as shown above.
- Make sure `python3` and `pip` are in your system `PATH`.

## License
MIT
