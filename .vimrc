" ----- General Config -----

" Enable per-file indenting and highlighting
set nocompatible
filetype plugin indent on
syntax on

" Show line numbers
set number

" Linebreaking options
set linebreak
set showbreak=++
set textwidth=100

" Jump to matching bracket when closing
set showmatch

" Flash screen instead of audible error bell
set visualbell

" Options for searching in files
set hlsearch
set smartcase
set ignorecase
set incsearch
set gdefault

" Indenting options
set autoindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2
set tabstop=2
set shiftround

" Automatically write and read
set autowriteall
set autoread

" Show cursor position in statusbar
set ruler

" Undo and backspace
set undolevels=1000
set backspace=indent,eol,start

" Show status bar at all times
set laststatus=2


" ----- Filetype-Specific Config -----

" Make php use 4 spaces for tabs
autocmd FileType php setlocal shiftwidth=4 tabstop=4

" Custom handling of blade templates
autocmd FileType blade setlocal ft=html syntax=blade shiftwidth=2 tabstop=2


" ----- Custom Mappings -----

" Set leader to comma
let mapleader = ","

" Save easily
nnoremap <Leader>s :w<CR>

" Use jk to esc out of insert/command mode
inoremap jk <Esc>
cmap jk <C-U><BS>

" Shortcut to clear highlighting
nnoremap <Esc> :noh<CR><Esc>

" Make Y consistent with C and D
nnoremap Y y$


" ----- Custom Commands -----

" Shortcut to expand tabs from 2 to 4 spaces
command Georgetabs %s/  /    /e | nohlsearch

" Shortcut to save as sudo
command Sudow w !sudo tee % >/dev/null

" Shortcut to remove trailing spaces
command -bar TrailingSpaces %s/\s\+$//e | nohlsearch
command W TrailingSpaces | w | exe "normal ``"

" Shortcut to dump-autoload
command DumpAutoload !composer -o dump-autoload; php artisan dump-autoload

" Command to re-run grunt dev:watch
command Grunt !screen -S cs-front-grunt -p 0 -X stuff "grunt dev:watch$(printf \\r)"

" Destroy all hidden buffers
command! -bang Wipeout :call Wipeout(<bang>0)
function! Wipeout(bang)
  " figure out which buffers are visible in any tab
  let visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  " close any buffer that are loaded and not visible
  let l:tally = 0
  let l:cmd = 'bw'
  if a:bang
    let l:cmd .= '!'
  endif
  for b in range(1, bufnr('$'))
    if buflisted(b) && !has_key(visible, b)
      let l:tally += 1
      exe l:cmd . ' ' . b
    endif
  endfor
  echon "Deleted " . l:tally . " buffers"
endfun


" ----- Plugins -----

" Initialize Pathogen for plugins
execute pathogen#infect()
call pathogen#helptags()

" --- Airline ---
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1

" --- NERDTree ---
let NERDTreeAutoDeleteBuffers = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden = 1
map <Leader>n :NERDTreeFind<CR>

" --- CtrlP ---
let g:ctrlp_by_filename = 1
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden --ignore .git ' .
  \ '--ignore .svn --ignore .hg --ignore .DS_Store -g ""'
nnoremap <Leader>f :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>

" --- EasyMotion ---
map <Space> <Plug>(easymotion-prefix)

" --- Syntastic ---
let g:syntastic_enable_signs = 1
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_html_checkers = []
let g:syntastic_php_checkers = ['php', 'phpcs']
let g:syntastic_php_phpcs_args = "--report=csv --standard=~/.elite50-phpcs-ruleset.xml"

" --- Tags ---
set tags=tags
let g:easytags_dynamic_files=1
let g:easytags_async=1
let g:easytags_auto_highlight=0
nmap <Leader>t :TagbarToggle<CR>

" --- Snippets ---
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction
au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-e>"

" --- Fugitive ---
nnoremap <Leader>ga :Git add %:p<CR><CR>
nnoremap <Leader>gA :Git add -A<CR><CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gC :Gcommit -a<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gb :Git branch<Space>
nnoremap <Leader>go :Git checkout<Space>
nnoremap <Leader>gm :Gmerge<Space>
nnoremap <Leader>gf :Gfetch<CR>
nnoremap <Leader>gt :Git tag<Space>
nnoremap <Leader>gpl :Gpull<CR>
nnoremap <Leader>gps :Gpush<CR>
nnoremap <Leader>gpt :Gpush --tags<CR>
nnoremap <Leader>p :Ggrep<Space>

" --- Surround ---
autocmd FileType php let b:surround_47 = "/* \r */"
autocmd FileType javascript let b:surround_47 = "/* \r */"
autocmd FileType scss let b:surround_47 = "/* \r */"
autocmd FileType html let b:surround_47 = "<!-- \r -->"

" --- Gundo ---
nnoremap <Leader>u :GundoToggle<CR>
let g:gundo_right = 1

" --- Emmet ---
let g:use_emmet_complete_tag = 1

" --- Instant Markdown ---
let g:instant_markdown_slow = 1

