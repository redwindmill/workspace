"------------------------------------------------------------------- unix-like "
call plug#begin('~/.vim/plugged')

if $RED__KIND_OS == "OSX"
	Plug '/usr/local/opt/fzf'
elseif $RED__KIND_OS == "NIX"
	Plug '~/.fzf'
endif

Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ajh17/vimcompletesme'
Plug 'rip-rip/clang_complete', { 'for': ['c', 'cpp', 'objc', 'objcpp'] }

call plug#end()
"------------------------------------------------------------------------------"

"LSP - C-LANGUAGES" "TODO:: clangd has issues with std hdrs and default params
"if $RED__KIND_OS == "OSX"
"	let s:path_clangd='/usr/local/opt/llvm/bin/clangd'
"	let s:path_hdrs='/usr/local/opt/llvm/include/'
""	let s:path_hdrs='/Library/Developer/CommandLineTools/usr/include'
""	let s:path_hdrs='/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include'
"else
"	let s:path_clangd='clangd'
"	let s:path_hdrs='/usr/local/include'
"endif
"
"if executable(s:path_clangd)
"	aug red#lsp_clangd
"		au!
"		" '-resource-dir="' . s:path_hdrs . '"',
"		" '-completion-style=bundled',
"		au User lsp_setup call lsp#register_server({
"			\ 'name': 'clangd',
"			\ 'cmd': {server_info->[
"					\ s:path_clangd,
"					\ '-background-index',
"					\ '-j=4',
"					\ '-limit-results=0'
"					\ ]},
"			\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
"			\ })
"		au Filetype c,cpp,objc,objcpp setlocal omnifunc=lsp#complete
"		aug END
"endif

"LSP - GOLANG"
if executable("gopls")
	aug red#lsp_gopls
		au!
		au User lsp_setup call lsp#register_server({
			\ 'name': 'gopls',
			\ 'cmd': {server_info->[
					\ "gopls",
					\ ]},
			\ 'whitelist': ['go'],
			\ })
		au Filetype go setlocal omnifunc=lsp#complete
		aug END
endif

"LSP - PYTHON"
if executable("pyls")
	aug red#lsp_pyls
		au!
		au User lsp_setup call lsp#register_server({
			\ 'name': 'pyls',
			\ 'cmd': {server_info->[
					\ "pyls",
					\ ]},
			\ 'whitelist': ['python'],
			\ })
		au Filetype python setlocal omnifunc=lsp#complete
		aug END
endif

"------------------------------------------------------------------------------"

"PRABIRSHRESTHA/VIM-LSP
let g:lsp_diagnostics_enabled = 0
let g:lsp_highlight_references_enabled = 0
"let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand('~/vim-lsp.log')

"AJH17/VIMCOMPLETESME
let g:vcm_default_maps = 0
let g:vcm_s_tab_behavior = 1
imap <S-Tab>   <plug>vim_completes_me_forward

"RIP-RIP/CLANG_COMPLETE
aug red#clang_complete
	au Filetype c,cpp,objc,objcpp setlocal omnifunc=ClangComplete
aug END

let g:clang_snippets=1
let g:clang_conceal_snippets=1
let g:clang_snippets_engine = 'clang_complete'
let g:clang_complete_optional_args_in_snippets = 1
let g:clang_omnicppcomplete_compliance = 1
let g:clang_complete_macros = 1

if $RED__KIND_OS == "OSX"
	let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
else
	"let g:clang_library_path=''
endif

"------------------------------------------------------------------------------"

command FilesP call fzf#vim#files('', fzf#vim#with_preview('right'))
command GFilesP call fzf#vim#gitfiles('', fzf#vim#with_preview('right'))
