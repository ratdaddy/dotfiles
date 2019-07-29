call pathogen#infect()
syntax enable
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

" Set filetypes
au BufRead *.hbs setf html
au BufRead *.jbuilder setf ruby
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
au BufRead *.edn set filetype=clojure

" Turn on vim-airline
set laststatus=2
