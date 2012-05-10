"-------------------------------------------------------------------------------
" gVimのメニュー非表示 
"-------------------------------------------------------------------------------
set guioptions& guioptions+=M

set nocompatible
filetype off
set rtp+=~/.vim/vundle.git/
call vundle#rc()

"-------------------------------------------------------------------------------
" プラグイン Plug-IN
"-------------------------------------------------------------------------------
" neocomplcacheを起動時に有効化
" let g:neocomplcache_enable_at_startup = 1

Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/unite.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'tpope/vim-rails'
Bundle 'vim-ruby/vim-ruby'
Bundle 'vim-scripts/surround.vim'
" Vundleの処理後、ftpluginとindentを読み込む
filetype plugin indent on


"-------------------------------------------------------------------------------
" 基本設定 Basics
"-------------------------------------------------------------------------------
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする
set nowrap                       " 一行に長い文章を書いていても自動折り返しをしない 

" OSのクリップボードを使用する
set clipboard+=unnamed

" ターミナルでマウスを使用できるようにする
set mouse=a
set guioptions+=a
set ttymouse=xterm2

"ヤンクした文字は、システムのクリップボードに入れる"
set clipboard=unnamed

" 挿入モードでCtrl+kを押すとクリップボードの内容を貼り付けられるようにする "
imap <C-p>  <ESC>"*pa

" ファイルタイプ判定をon
filetype plugin on


"-------------------------------------------------------------------------------
" 表示 Apperance
"-------------------------------------------------------------------------------
set number         " 行番号表示
set ruler          " カーソルが何行目の何列目に置かれているかを表示する
set showmatch      " 括弧の対応をハイライト
set cursorline     " カーソル行をハイライト
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/


"-------------------------------------------------------------------------------
" カラー関連 Colors
"-------------------------------------------------------------------------------
syntax on
highlight Normal ctermbg=black ctermfg=grey
highlight StatusLine term=none cterm=none ctermfg=black ctermbg=grey
highlight CursorLine term=none cterm=none ctermfg=none ctermbg=darkgray


"-------------------------------------------------------------------------------
" 補完・履歴 Complete
"-------------------------------------------------------------------------------
set wildmenu               " コマンド補完を強化
set wildmode=list:full     " リスト表示，最長マッチ


"-------------------------------------------------------------------------------
" 編集関連 Edit
"-------------------------------------------------------------------------------
" y9で行末までヤンク
nmap y9 y$
" y0で行頭までヤンク
nmap y0 y^
" Tabキーを空白に変換
set expandtab
" 保存時にtabをスペースに変換する
autocmd BufWritePre * :%s/\t/  /ge
" コンマの後に自動的にスペースを挿入
inoremap , ,<Space>


"-------------------------------------------------------------------------------
" エンコーディング関連 Encoding
"-------------------------------------------------------------------------------
set ffs=unix,dos,mac  " 改行文字
set encoding=utf-8    " デフォルトエンコーディング
" cvsの時は文字コードをeuc-jpに設定
autocmd FileType cvs :set fileencoding=euc-jp
" 以下のファイルの時は文字コードをutf-8に設定
autocmd FileType svn :set fileencoding=utf-8
autocmd FileType js :set fileencoding=utf-8
autocmd FileType css :set fileencoding=utf-8
autocmd FileType html :set fileencoding=utf-8
autocmd FileType xml :set fileencoding=utf-8
autocmd FileType java :set fileencoding=utf-8
autocmd FileType scala :set fileencoding=utf-8

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932

"-------------------------------------------------------------------------------
" インデント Indent
"-------------------------------------------------------------------------------
set autoindent   " 自動でインデント
set smartindent  " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0

"-------------------------------------------------------------------------------
" 移動設定 Move
"-------------------------------------------------------------------------------
" 0, 9で行頭、行末へ
nmap 1 0
nmap 0 ^
nmap 9 $

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif


"-------------------------------------------------------------------------------
" 検索設定 Search
"-------------------------------------------------------------------------------
set incsearch  " インクリメンタルサーチ
set wrapscan   " 最後まで検索したら先頭へ戻る
set ignorecase " 大文字小文字無視
set smartcase  " 検索文字列に大文字が含まれている場合は区別して検索する
set hlsearch   " 検索文字をハイライト


"-------------------------------------------------------------------------------
" ステータスライン StatusLine
"-------------------------------------------------------------------------------
set laststatus=2         " 常にステータスラインを表示
set statusline=%F%r%h%=  " ステータスライン表示項目


"-------------------------------------------------------------------------------
" gVimのメニュー非表示
"-------------------------------------------------------------------------------
\set guioptions-=T 
\set guioptions-=m
