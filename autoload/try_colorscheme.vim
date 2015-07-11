let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('try_colorscheme')
let s:HTTP = s:V.import('Web.HTTP')
let s:JSON = s:V.import('Web.JSON')
let s:File = s:V.import('System.File')

function! s:error(msg) abort
    echohl ErrorMsg
    echomsg 'try-colorscheme.vim: ' . a:msg
    echohl None
endfunction

function! s:name_of(path) abort
    return matchstr(a:path, 'colors/\zs[^/]\+\ze\.vim')
endfunction

function! s:request_repo_files(path) abort
    " XXX: Branch is fixed to 'master'
    let url = 'https://api.github.com/repos/' . a:path . '/git/trees/master'
    let response =  s:HTTP.request({
                \ 'url' : url,
                \ 'headers' : {'Accept' : 'application/vnd.github.v3+json'},
                \ 'method' : 'GET',
                \ 'param' : {
                \   'recursive' : 10,
                \   'type' : 'blob',
                \ },
                \ 'client' : ['curl', 'wget'],
                \ })

    if !response.success
        call s:error(
            \ printf('API ''%s'' failed (%s)', url, response.statusText)
            \ )
        return []
    endif

    return s:JSON.decode(response.content).tree
endfunction

function! s:detect_cs_in_github_repo(path) abort
    let files = s:request_repo_files(a:path)

    call filter(files, 'v:val.path =~# ''colors/[^.]\+\.vim$''')
    if files == []
        return {}
    endif

    call map(files, '{
            \ "name" : s:name_of(v:val.path),
            \ "url" : "https://raw.githubusercontent.com/" . a:path . "/master/" . v:val.path,
            \ }')

    if len(files) == 1
        return files[0]
    endif

    let input_msg = ''
    for i in range(len(files))
        let input_msg .= printf("\n [%d] %s", i, files[i].name)
    endfor
    let input_msg .= "\nEnter the number of file you want to choose: "

    let idx = str2nr(input(input_msg))
    echo "\n"
    if idx >= len(files)
        return {}
    endif

    return files[idx]
endfunction

function! s:detect_colorscheme(cs_resource) abort
    let path = matchstr(a:cs_resource, '^https://github.com/\zs.\+')
    if path !=# ''
        let [repo_path, file_path] = matchlist(path, '\([^/]\+/[^/]\+\)\(.*\)')[1:2]
        if file_path !=# ''
            " XXX: Branch is hard-coded as 'master'
            return {
                \   'name' : s:name_of(file_path),
                \   'url' : 'https://raw.githubusercontent.com/' . repo_path . '/master/' . file_path
                \ }
        else
            return s:detect_cs_in_github_repo(path)
        endif
    endif

    if a:cs_resource =~# '[^/]\+/.\+'
        return s:detect_cs_in_github_repo(a:cs_resource)
    endif

    " TODO: Add non-github URL support
    " TODO: Should I add Gist support?

    return {}
endfunction

function! s:download_colorscheme(cs, dir) abort
    let downloaded = a:dir . '/' . a:cs.name . '.vim'
    let response = s:HTTP.request({
                \ 'url' : a:cs.url,
                \ 'method' : 'GET',
                \ 'client' : ['curl', 'wget'],
                \ 'outputFile' : a:dir . '/' . a:cs.name . '.vim',
                \ })
    if response.success
        return 1
    else
        call s:error('Failed to download: ' . downloaded . ' (' . response.statusText . ')')
        return 0
    endif
endfunction

function! s:try(cs) abort
    let rtp_save = &rtp

    try
        let tmpdir = tempname()
        let tmp_color_dir = tmpdir . '/colors'

        " Note: mkdir() is unavailable in some systems
        call mkdir(tmp_color_dir, 'p')

        let success = s:download_colorscheme(a:cs, tmp_color_dir)
        if !success
            return 0
        endif

        let &rtp = tmpdir . ',' . &rtp
        execute 'colorscheme' a:cs.name

        return 1
    finally
        let &rtp = rtp_save
        if isdirectory(tmpdir)
            call s:File.rmdir(tmpdir, 'r')
        endif
    endtry
endfunction

function! try_colorscheme#try(cs_resource) abort
    let cs = s:detect_colorscheme(a:cs_resource)
    if empty(cs)
        call s:error('Failed to detect colorscheme ''' . a:cs_resource . '''')
        return
    endif

    if s:try(cs)
        echomsg 'try-colorscheme.vim: Enjoy colorscheme ''' . cs.name . '''!'
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
