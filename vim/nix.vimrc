"------------------------------------------------------------------- unix-like "
syntax on
colorscheme elflord

set background=dark
set encoding=utf-8
set cm=blowfish2										"not secure

set ruler												"show col/row
"set cursorline											"highlight active line
set number												"show line numbers
set showmatch											"highlight matching [{()}]

set showcmd												"show cmd at bottom
set laststatus=2										"always show status line
set wildmenu											"autocomplete cmd menu
set incsearch

filetype plugin indent on								"use indent profiles
"set expandtab											"insert spaces for tab
set tabstop=4											"viewing tab size
set softtabstop=4										"inserting tab size
set shiftwidth=4										"reindent size
set smarttab

set backspace=indent,eol,start							"allow backspace on
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<	"show special chars
														"call set list

set nobackup											"no pre ~ file
set nowritebackup										"write to orig file
set noundofile											"no persist undo
set noswapfile											"no editing backup
set noshelltemp											"no tmp for stdin
set history=0											"no cmd history
set viminfo="NONE"
set modelines=0											"no modeline feat
set nomodeline
set secure												"no shell/write in
														"vimrc/exrc
