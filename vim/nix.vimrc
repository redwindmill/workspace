"------------------------------------------------------------------- unix-like "
"NOTE: USING $RED__KIND_OS (OSX/WIN/NIX) $RED__KIND_ARCH (X86/ARM)

"CONFIGURATION
"------------------------------------------------------------------------------"

"~ CORE ~"
set encoding=utf-8
set cm=blowfish2										"not secure
"set clipboard=unnamed									"copy to os clipboard
set ttyfast												"enable fast redraw
set maxmempattern=8192									"kib mem for pattern matching
set nobackup											"no pre ~ file
set nowritebackup										"write to orig file
set nowb
set noundofile											"no persist undo
set noswapfile											"no editing backup
set noshelltemp											"no tmp for stdin
set history=0											"no cmd history
set viminfo="NONE"
set modelines=0											"no modeline feat
set nomodeline
set secure												"no shell/write in

"~ FORM ~"
syntax on
colorscheme koehler
set background=dark
set gfn=IBM\ Plex\ Mono:h14,Consolas:h14,Courier:h14
set ruler												"show col/row
set tw=0												"disable nl injection w/ ln wrap
set cursorline											"highlight active line
set number												"show line numbers
set showmatch											"highlight matching [{()}]
set textwidth=128										"set text wrap
set colorcolumn=81										"highlight wrap column
set display=uhex										"show unprintable char as hex
set noshowmode											"disable mode toast
set showcmd												"show cmd at bottom
set laststatus=2										"always show status line
set formatoptions-=t									"don't autowrap text using textwidth
"set nowrap												"disable line wrapping
"set signcolumn=yes										"always show sign col

hi CursorLine term=bold cterm=bold ctermbg=darkBlue		"set highlight color for active line
hi clear MatchParen										"underline brackets
hi MatchParen cterm=underline

"~ FUNCTION ~"
set wildmenu											"autocomplete cmd menu
set incsearch											"auto search
set backspace=indent,eol,start							"allow backspace on
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<	"show special chars in list
"set magic												"enable regular expressions
"set mouse=a 											"enable mouse support

"~ INDENTING ~"
filetype plugin indent on								"use indent profiles
set tabstop=4											"viewing tab size
set softtabstop=4										"inserting tab size
set shiftwidth=4										"reindent size
set smarttab											"use shiftwidth w/del & tab
set foldmethod=indent
set nofoldenable
"set expandtab											"insert spaces for tab
"set autoindent
"set smartindent

"~ NETRW ~"
let g:netrw_liststyle = 3								"list mode (i)
"let g:netrw_banner = 0									"disable banner (I)
"let g:netrw_browse_split = 4							"browse split (open in prev win)
"let g:netrw_altv = 1
"let g:netrw_winsize = 25

"~ SPELLING ~"
set spelllang=en
set spellfile=$HOME/.vim/spell/tech.utf-8.add
hi clear SpellBad
hi clear SpellCap
hi clear SpellLocal
hi clear SpellRare
hi SpellBad cterm=underline ctermfg=red					"only highlight bad spelling
hi SpellCap cterm=underline
hi gitcommitBlank cterm=underline	ctermbg=NONE		"change default for vimspell

"~ OMNICOMPLETE ~"
filetype plugin on										"enable omni completion
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone

"CUSTOM COMMANDS"
"------------------------------------------------------------------------------"

aug red#dynamic_bghighlight
	au!
	au WinEnter * set cursorline
	au WinLeave * set nocursorline
aug END

aug red#file_options
	au!
	au FileType markdown,gitcommit,text setlocal spell complete+=kspell
	au BufRead,BufNewFile *.bash_profile setlocal filetype=sh
aug END

aug red#vim_notes
	au!
	au BufRead,BufNewFile *.vnote setlocal filetype=markdown ai bh=wipe fen fdm=indent fdo=insert fcl=all tw=0
aug END

"------------------------------------------------------------------------------"

function s:red__recycle_hidden_buffers()
	let tpbl=[]
	call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
	for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
		silent execute 'bwipeout' buf
	endfor
endf

com Dir Lexplore
com SpellLoad exec 'mkspell!' '$HOME/.vim/spell/tech.utf-8.add.spl' '$HOME/.vim/spell/tech.utf-8.add'
com BufRecycle call s:red__recycle_hidden_buffers()
com ReAlign exec 'normal! gg=G'
com ReTab :retab
com ReTrim :%s/\s\+$//e

com Spell setlocal spell
com NoSpell setlocal nospell
com Wspace setlocal list
com NoWspace setlocal nolist
com Hls setlocal hls
com NoHls setlocal nohls

"------------------------------------------------------------------------------"

let s:red__mode_str={
	\ '!'		: ' SHELL ',
	\ "\<C-v>"	: ' V-BLK ',
	\ "\<C-s>"	: ' S-BLK ',
	\ 'c'		: ' CMD-LN ',
	\ 'ce'		: ' EX ',
	\ 'cv'		: ' VIM-EX ',
	\ 'i'		: ' INSERT ',
	\ 'n'		: ' NORMAL ',
	\ 'no'		: ' NORM-O ',
	\ 'r?'		: ' CONFIRM ',
	\ 'r'		: ' PROMPT ',
	\ 'R'		: ' REPLACE ',
	\ 'rm'		: ' MORE   ',
	\ 'Rv'		: ' V-REPL ',
	\ 'S'		: ' S-LINE ',
	\ 's'		: ' SELECT ',
	\ 't'		: ' TERM   ',
	\ 'V'		: ' V-LINE ',
	\ 'v'		: ' VISUAL ',
	\}

let s:red__mode_color_bg={
	\ 'n'		: 7,
	\ 'no'		: 7,
	\ 'rm'		: 7,
	\ 'i'		: 10,
	\ 'R'		: 9,
	\ 'Rv'		: 9,
	\ 'r?'		: 9,
	\ 'r'		: 9,
	\ 's'		: 214,
	\ 'v'		: 214,
	\ 'S'		: 214,
	\ 'V'		: 214,
	\ "\<C-s>"	: 214,
	\ "\<C-v>"	: 214,
	\ '!'		: 14,
	\ 'c'		: 14,
	\ 'ce'		: 14,
	\ 'cv'		: 14,
	\ 't'		: 14,
	\}

let s:red__mode_color_fg={
	\ 'n'		: 0,
	\ 'no'		: 0,
	\ 'rm'		: 0,
	\ 'i'		: 0,
	\ 'R'		: 0,
	\ 'Rv'		: 0,
	\ 'r?'		: 0,
	\ 'r'		: 0,
	\ 's'		: 0,
	\ 'v'		: 0,
	\ 'S'		: 0,
	\ 'V'		: 0,
	\ "\<C-s>"	: 0,
	\ "\<C-v>"	: 0,
	\ '!'		: 0,
	\ 'c'		: 0,
	\ 'ce'		: 0,
	\ 'cv'		: 0,
	\ 't'		: 0,
	\}

function RED__SETMODECOLOR()
	let cmode = mode()
	let cmode_color_fg = get(s:red__mode_color_fg, cmode, 231)
	let cmode_color_bg = get(s:red__mode_color_bg, cmode, 16)
	exe 'hi! StatusLine cterm=bold ctermfg='cmode_color_fg
	exe 'hi! StatusLine ctermbg='cmode_color_bg
	return ''
endf

function RED__GETMODESTR()
	let cmode = mode()
	return get(s:red__mode_str, cmode, cmode)
endf

function RED__GETFILESIZE()
	let bytes = getfsize(expand('%:p'))
	let kib = bytes / 1024
	let mib = kib / 1024

	if (mib > 0)
		return ' ' . mib . 'M '
	elseif (kib > 0)
		return ' ' . kib . 'K '
	elseif (bytes > 0)
		return ' ' . bytes . 'B '
	else
		return ' '
	endif
endf

function RED__GET_GBRANCH()
	if exists('b:red__git_branch')
		return b:red__git_branch
	else
		return ''
	endif
endf

function s:cache_git_branch()
	let b:red__git_branch = ''
	if executable('git')
		let cur_dir = expand('%:p:h')
		let branch = system('git -C ' . cur_dir . ' symbolic-ref --short HEAD 2>/dev/null')

		if v:version >= 801
			let b:red__git_branch = trim(branch) . ' '
		else
			let b:red__git_branch = substitute(branch, '\n$', ' ', '')
		endif
	endif
endf

aug red#populate_git_branch
	au!
	au VimEnter,BufEnter * call s:cache_git_branch()
aug END

"------------------------------------------------------------------------------"

set statusline=%{RED__SETMODECOLOR()}					"clear statusline
set statusline+=%#StatusLineNC#							"set color
set statusline+=[%n/									"set buffer number
set statusline+=%{len(filter(range(1,bufnr('$')),'buflisted(v:val)'))}]	"show buffer number

set statusline+=%#StatusLine#							"set color
set statusline+=%{RED__GETMODESTR()}					"show vim mode

set statusline+=%#StatusLineNC#							"set color
set statusline+=\ %{RED__GET_GBRANCH()}					"show git branch (cur file)

set statusline+=%#CursorColumn#							"set color
set statusline+=\ %<%f\ %h%m%r%w						"show file path

set statusline+=%=										"set right align

set statusline+=%#CursorColumn#							"set color
set statusline+=\ %3l,%02c%03V\ %3p%% 					"row/col/real-col/percent-of-file

set statusline+=\ %#StatusLineNC#						"set color
set statusline+=\ %04o									"show cursor byte
set statusline+=\(0x%02B\)								"show cursor character

set statusline+=\ %#CursorColumn#						"set color
set statusline+=\ %y									"show file type
set statusline+=[%{&fileencoding?&fileencoding:&encoding}/	"show file encoding
set statusline+=%{&fileformat}] 						"show file format

set statusline+=\ %#StatusLine#							"set color
set statusline+=%{RED__GETFILESIZE()}					"show file size

"LOAD SOURCE"
"------------------------------------------------------------------------------"
function s:if_source_exists(file)
	if filereadable(expand(a:file))
		exe 'source' a:file
	endif
endf

call s:if_source_exists("~/.vimrc.plug")
call s:if_source_exists("~/.vimrc.local")
