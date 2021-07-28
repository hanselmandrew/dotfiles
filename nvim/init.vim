
""""" Install VimPlug if necessary
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

""""" All the plugins!!!
call plug#begin('~/.vim/plugged')

  " Dependencies
  Plug 'nvim-lua/plenary.nvim'

  " LSP Server
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
  Plug 'simrat39/symbols-outline.nvim'

	" Visuals
	Plug 'morhetz/gruvbox'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'navarasu/onedark.nvim'
  " Plug 'wfxr/minimap.vim' " Disabled because of bug when closing tab
  Plug 'psliwka/vim-smoothie'

  Plug 'lukas-reineke/indent-blankline.nvim'

  " Tmux
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'edkolev/tmuxline.vim'

	" Scala
	Plug 'scalameta/nvim-metals'

  " Git
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'sindrets/diffview.nvim'

  " Fast file switching/searching with telescope + dependencies
  Plug 'nvim-lua/popup.nvim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Nerdtree for sidebar
  Plug 'preservim/nerdtree'

  " Completion
  Plug 'nvim-lua/completion-nvim'

call plug#end()

""""" Always needs these basic settings
set relativenumber
set number
set scrolloff=10
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set showtabline=2
set nowrap

set ignorecase
set smartcase

set mouse=a
set updatetime=300

let mapleader = ' '

nnoremap <Tab>   :tabnext <cr>
nnoremap <S-Tab> :tabprevious <cr>

nnoremap <leader><leader> :nohl <cr>


""""" Plug 'sindrets/diffview.nvim'
function! DiffBranch()
  let forkhash = system('git merge-base HEAD master')
  echo forkhash
  execute 'DiffviewOpen' forkhash
endfunction
command! DiffBranch call DiffBranch()

lua << EOF
local cb = require'diffview.config'.diffview_callback
require'diffview'.setup {
  diff_binaries = false,    -- Show diffs for binaries
  file_panel = {
    width = 35,
    use_icons = false
  },
  key_bindings = {
    disable_defaults = true,                   -- Disable the default key bindings

    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<leader>e"] = cb("focus_files"),        -- Bring focus to the files panel
      ["<leader>b"] = cb("toggle_files"),       -- Toggle the files panel.
    },
    file_panel = {
      ["j"]             = cb("next_entry"),         -- Bring the cursor to the next file entry
      ["<down>"]        = cb("next_entry"),
      ["k"]             = cb("prev_entry"),         -- Bring the cursor to the previous file entry.
      ["<up>"]          = cb("prev_entry"),
      ["<cr>"]          = cb("select_entry"),       -- Open the diff for the selected entry.
      ["o"]             = cb("select_entry"),
      ["<2-LeftMouse>"] = cb("select_entry"),
      ["-"]             = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
      ["S"]             = cb("stage_all"),          -- Stage all entries.
      ["U"]             = cb("unstage_all"),        -- Unstage all entries.
      ["R"]             = cb("refresh_files"),      -- Update stats and entries in the file list.
      ["<leader>e"]     = cb("focus_files"),
      ["<leader>b"]     = cb("toggle_files"),
    }
  }
}
EOF

""""" Plug 'lewis6991/gitsigns.nvim'
lua << EOF
require("gitsigns").setup {
  current_line_blame = true,
  current_line_blame_delay = 1000,
}
EOF

"""""
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}
EOF

"""""
let g:smoothie_experimental_mappings = 1

""""" Plug 'junegunn/fzf.vim'
nnoremap <C-p> :Files <cr>

""""" Plug 'wfxr/minimap.vim'
" let g:minimap_width = 10

""""" Plug 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1

""""" Plug 'edkolev/tmuxline.vim'
" Theme
" set termguicolors
" let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme onedark
let g:airline_theme='onedark'

" force transparent vim background, not needed if you dont use terminal transparency
hi Normal guibg=NONE ctermbg=NONE

""""" Plug 'lukas-reineke/indent-blankline.nvim'
" Must appear after colorscheme call
highlight IndentBlanklineChar guifg=grey20 gui=nocombine
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

"=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
" These are example settings to use with nvim-metals and the nvim built in
" LSP.  Be sure to thoroughly read the the help docs to get an idea of what
" everything does.
"
" The below configuration also makes use of the following plugins besides
" nvim-metals
" - https://github.com/nvim-lua/completion-nvim
"=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+

"-----------------------------------------------------------------------------
" nvim-lsp Mappings
"-----------------------------------------------------------------------------
nnoremap <silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K           <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gds         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gws         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>rn  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>f   <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>ca  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>ws  <cmd>lua require'metals'.worksheet_hover()<CR>
nnoremap <silent> <leader>a   <cmd>lua require'metals'.open_all_diagnostics()<CR>
nnoremap <silent> <space>d    <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> [c          <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
nnoremap <silent> ]c          <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>

"-----------------------------------------------------------------------------
" nvim-lsp Settings
"-----------------------------------------------------------------------------

"-----------------------------------------------------------------------------
" nvim-metals setup with a few additions such as nvim-completions
"-----------------------------------------------------------------------------
lua << EOF
  metals_config = require'metals'.bare_config
  metals_config.settings = {
     showImplicitArguments = true,
  }
  metals_config.on_attach = function()
    require'completion'.on_attach();
  end
EOF

if has('nvim-0.5')
  augroup lsp
    au!
    au FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)
  augroup end
endif

"-----------------------------------------------------------------------------
" completion-nvim settings
"-----------------------------------------------------------------------------
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"-----------------------------------------------------------------------------
" Helpful general settings
"-----------------------------------------------------------------------------
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Ensure autocmd works for Filetype
set shortmess-=F
