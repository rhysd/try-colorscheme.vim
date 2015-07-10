if (exists('g:loaded_try_colorscheme') && g:loaded_try_colorscheme) || &cp
    finish
endif

command -nargs=1 TryColorscheme call try_colorscheme#try(<q-args>)

let g:loaded_try_colorscheme = 1
