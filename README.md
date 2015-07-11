Try Colorscheme on Web at the Speed of Light
============================================
[![Build Status](https://travis-ci.org/rhysd/try-colorscheme.vim.svg)](https://travis-ci.org/rhysd/try-colorscheme.vim)

When you want to try some colorschemes, you must install it at first and then execute `:colorscheme`.
This plugin removes the annoying process.  This plugin detects and downloads colorscheme file temporarily and applies it automatically.  The temporary colorscheme file is automatically deleted.


## Usage

`:TryColorscheme` command is whole of this plugin.

For example, all of below apply [wallaby colorscheme](https://github.com/rhysd/wallaby.vim) instantly.

```vim
" Colorscheme repository (suppose GitHub repository)
:TryColorscheme rhysd/wallaby.vim

" GitHub URL of colorscheme
:TryColorscheme https://github.com/rhysd/wallaby.vim

" Direct URL to colorscheme file
:TryColorscheme https://github.com/rhysd/wallaby.vim/colors/wallaby.vim
```

![screenshot](https://raw.githubusercontent.com/rhysd/screenshots/master/try-colorscheme.vim/try-colorscheme.gif)

Note that this plugin may not work in Windows.

## Installation

- With [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'rhysd/try-colorscheme.vim'
```

- With [vundle](https://github.com/VundleVim/Vundle.vim)

```vim
Plugin 'rhysd/try-colorscheme.vim'
```

- With [neobundle](https://github.com/Shougo/neobundle.vim)

```vim
NeoBundle 'rhysd/try-colorscheme.vim'
```


## API

If you want to use a feature of this plugin from Vim script, please use `try_colorscheme#try()` function.

## License

    Copyright (c) 2015 rhysd

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
    of the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
    PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
    THE USE OR OTHER DEALINGS IN THE SOFTWARE.


