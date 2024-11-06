call pathogen#infect()
syntax enable
set background=dark
filetype plugin indent on
set shiftwidth=2
set tabstop=2
set autoindent
set expandtab
map <C-j> :tabnext<CR>
map <C-k> :tabprev<CR>

runtime macros/matchit.vim

let mapleader=","

" open up file in directory of current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" switch between the last two files
nnoremap <leader><leader> <c-^>

" Make the current window big
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

set regexpengine=2

" Set filetypes
au BufRead *.hbs setf html
au BufRead *.jbuilder setf ruby
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
au BufRead *.edn set filetype=clojure

" Turn on vim-airline
set laststatus=2

" Turn off paren match highlighting
set noshowmatch
function! g:DisableMatchParen ()
    if exists(":NoMatchParen")
        :NoMatchParen
    endif
endfunction

augroup plugin_initialize
    autocmd!
    autocmd VimEnter * call DisableMatchParen()
    autocmd BufRead,BufNewFile *.svelte set filetype=html
augroup END

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

hi CocPumSearch ctermfg=39
hi CocErrorFloat ctermfg=203
hi CocHintFloat ctermfg=14

" Do :PlugInstall to install any new plugins or for first time setup
call plug#begin()

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'junegunn/fzf'

Plug 'peitalin/vim-jsx-typescript'

Plug 'posva/vim-vue'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-solargraph',
  \ 'coc-rust-analyzer',
  \ 'coc-pyright',
  \ ]
nnoremap <silent> K :call CocAction('doHover')<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#insert() : "\<CR>"
inoremap <expr> <tab> coc#pum#visible() ? coc#_select_confirm() : "\<TAB>"

Plug 'github/copilot.vim'

call plug#end()
