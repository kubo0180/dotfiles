" bitwise operators
" moved from github.com/ynkdir/vim-funlib

let s:save_cpo = &cpo
set cpo&vim

" compare as unsigned int
function! s:compare(a, b)
  if (a:a >= 0 && a:b >= 0) || (a:a < 0 && a:b < 0)
    return a:a < a:b ? -1 : a:a > a:b ? 1 : 0
  else
    return a:a < 0 ? 1 : -1
  endif
endfunction

function! s:lshift(a, n)
  return  a:a * s:pow2[s:and(a:n, 0x1F)]
endfunction

function! s:rshift(a, n)
  let n = s:and(a:n, 0x1F)
  return n == 0 ? a:a :
  \  a:a < 0 ? (a:a - 0x80000000) / s:pow2[n] + 0x40000000 / s:pow2[n - 1]
  \          : a:a / s:pow2[n]
endfunction

let s:pow2 = [
      \ 0x1,        0x2,        0x4,        0x8,
      \ 0x10,       0x20,       0x40,       0x80,
      \ 0x100,      0x200,      0x400,      0x800,
      \ 0x1000,     0x2000,     0x4000,     0x8000,
      \ 0x10000,    0x20000,    0x40000,    0x80000,
      \ 0x100000,   0x200000,   0x400000,   0x800000,
      \ 0x1000000,  0x2000000,  0x4000000,  0x8000000,
      \ 0x10000000, 0x20000000, 0x40000000, 0x80000000,
      \ ]

if exists('*and')
  function! s:_vital_loaded(V) dict
    for op in ['and', 'or', 'xor', 'invert']
      let self[op] = function(op)
      let s:[op] = self[op]
    endfor
  endfunction
  finish
endif


function! s:invert(a)
  return -a:a - 1
endfunction

function! s:and(a, b)
  let a = a:a < 0 ? a:a - 0x80000000 : a:a
  let b = a:b < 0 ? a:b - 0x80000000 : a:b
  let r = 0
  let n = 1
  while a && b
    let r += s:and[a % 0x10][b % 0x10] * n
    let a = a / 0x10
    let b = b / 0x10
    let n = n * 0x10
  endwhile
  if (a:a < 0) && (a:b < 0)
    let r += 0x80000000
  endif
  return r
endfunction

function! s:or(a, b)
  let a = a:a < 0 ? a:a - 0x80000000 : a:a
  let b = a:b < 0 ? a:b - 0x80000000 : a:b
  let r = 0
  let n = 1
  while a || b
    let r += s:or[a % 0x10][b % 0x10] * n
    let a = a / 0x10
    let b = b / 0x10
    let n = n * 0x10
  endwhile
  if (a:a < 0) || (a:b < 0)
    let r += 0x80000000
  endif
  return r
endfunction

function! s:xor(a, b)
  let a = a:a < 0 ? a:a - 0x80000000 : a:a
  let b = a:b < 0 ? a:b - 0x80000000 : a:b
  let r = 0
  let n = 1
  while a || b
    let r += s:xor[a % 0x10][b % 0x10] * n
    let a = a / 0x10
    let b = b / 0x10
    let n = n * 0x10
  endwhile
  if (a:a < 0) != (a:b < 0)
    let r += 0x80000000
  endif
  return r
endfunction

let s:and = [
      \ [0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0],
      \ [0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1],
      \ [0x0, 0x0, 0x2, 0x2, 0x0, 0x0, 0x2, 0x2, 0x0, 0x0, 0x2, 0x2, 0x0, 0x0, 0x2, 0x2],
      \ [0x0, 0x1, 0x2, 0x3, 0x0, 0x1, 0x2, 0x3, 0x0, 0x1, 0x2, 0x3, 0x0, 0x1, 0x2, 0x3],
      \ [0x0, 0x0, 0x0, 0x0, 0x4, 0x4, 0x4, 0x4, 0x0, 0x0, 0x0, 0x0, 0x4, 0x4, 0x4, 0x4],
      \ [0x0, 0x1, 0x0, 0x1, 0x4, 0x5, 0x4, 0x5, 0x0, 0x1, 0x0, 0x1, 0x4, 0x5, 0x4, 0x5],
      \ [0x0, 0x0, 0x2, 0x2, 0x4, 0x4, 0x6, 0x6, 0x0, 0x0, 0x2, 0x2, 0x4, 0x4, 0x6, 0x6],
      \ [0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7],
      \ [0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x8, 0x8, 0x8, 0x8, 0x8, 0x8, 0x8],
      \ [0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x0, 0x1, 0x8, 0x9, 0x8, 0x9, 0x8, 0x9, 0x8, 0x9],
      \ [0x0, 0x0, 0x2, 0x2, 0x0, 0x0, 0x2, 0x2, 0x8, 0x8, 0xA, 0xA, 0x8, 0x8, 0xA, 0xA],
      \ [0x0, 0x1, 0x2, 0x3, 0x0, 0x1, 0x2, 0x3, 0x8, 0x9, 0xA, 0xB, 0x8, 0x9, 0xA, 0xB],
      \ [0x0, 0x0, 0x0, 0x0, 0x4, 0x4, 0x4, 0x4, 0x8, 0x8, 0x8, 0x8, 0xC, 0xC, 0xC, 0xC],
      \ [0x0, 0x1, 0x0, 0x1, 0x4, 0x5, 0x4, 0x5, 0x8, 0x9, 0x8, 0x9, 0xC, 0xD, 0xC, 0xD],
      \ [0x0, 0x0, 0x2, 0x2, 0x4, 0x4, 0x6, 0x6, 0x8, 0x8, 0xA, 0xA, 0xC, 0xC, 0xE, 0xE],
      \ [0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF]
      \ ]

let s:or = [
      \ [0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF],
      \ [0x1, 0x1, 0x3, 0x3, 0x5, 0x5, 0x7, 0x7, 0x9, 0x9, 0xB, 0xB, 0xD, 0xD, 0xF, 0xF],
      \ [0x2, 0x3, 0x2, 0x3, 0x6, 0x7, 0x6, 0x7, 0xA, 0xB, 0xA, 0xB, 0xE, 0xF, 0xE, 0xF],
      \ [0x3, 0x3, 0x3, 0x3, 0x7, 0x7, 0x7, 0x7, 0xB, 0xB, 0xB, 0xB, 0xF, 0xF, 0xF, 0xF],
      \ [0x4, 0x5, 0x6, 0x7, 0x4, 0x5, 0x6, 0x7, 0xC, 0xD, 0xE, 0xF, 0xC, 0xD, 0xE, 0xF],
      \ [0x5, 0x5, 0x7, 0x7, 0x5, 0x5, 0x7, 0x7, 0xD, 0xD, 0xF, 0xF, 0xD, 0xD, 0xF, 0xF],
      \ [0x6, 0x7, 0x6, 0x7, 0x6, 0x7, 0x6, 0x7, 0xE, 0xF, 0xE, 0xF, 0xE, 0xF, 0xE, 0xF],
      \ [0x7, 0x7, 0x7, 0x7, 0x7, 0x7, 0x7, 0x7, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF],
      \ [0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF],
      \ [0x9, 0x9, 0xB, 0xB, 0xD, 0xD, 0xF, 0xF, 0x9, 0x9, 0xB, 0xB, 0xD, 0xD, 0xF, 0xF],
      \ [0xA, 0xB, 0xA, 0xB, 0xE, 0xF, 0xE, 0xF, 0xA, 0xB, 0xA, 0xB, 0xE, 0xF, 0xE, 0xF],
      \ [0xB, 0xB, 0xB, 0xB, 0xF, 0xF, 0xF, 0xF, 0xB, 0xB, 0xB, 0xB, 0xF, 0xF, 0xF, 0xF],
      \ [0xC, 0xD, 0xE, 0xF, 0xC, 0xD, 0xE, 0xF, 0xC, 0xD, 0xE, 0xF, 0xC, 0xD, 0xE, 0xF],
      \ [0xD, 0xD, 0xF, 0xF, 0xD, 0xD, 0xF, 0xF, 0xD, 0xD, 0xF, 0xF, 0xD, 0xD, 0xF, 0xF],
      \ [0xE, 0xF, 0xE, 0xF, 0xE, 0xF, 0xE, 0xF, 0xE, 0xF, 0xE, 0xF, 0xE, 0xF, 0xE, 0xF],
      \ [0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF]
      \ ]

let s:xor = [
      \ [0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF],
      \ [0x1, 0x0, 0x3, 0x2, 0x5, 0x4, 0x7, 0x6, 0x9, 0x8, 0xB, 0xA, 0xD, 0xC, 0xF, 0xE],
      \ [0x2, 0x3, 0x0, 0x1, 0x6, 0x7, 0x4, 0x5, 0xA, 0xB, 0x8, 0x9, 0xE, 0xF, 0xC, 0xD],
      \ [0x3, 0x2, 0x1, 0x0, 0x7, 0x6, 0x5, 0x4, 0xB, 0xA, 0x9, 0x8, 0xF, 0xE, 0xD, 0xC],
      \ [0x4, 0x5, 0x6, 0x7, 0x0, 0x1, 0x2, 0x3, 0xC, 0xD, 0xE, 0xF, 0x8, 0x9, 0xA, 0xB],
      \ [0x5, 0x4, 0x7, 0x6, 0x1, 0x0, 0x3, 0x2, 0xD, 0xC, 0xF, 0xE, 0x9, 0x8, 0xB, 0xA],
      \ [0x6, 0x7, 0x4, 0x5, 0x2, 0x3, 0x0, 0x1, 0xE, 0xF, 0xC, 0xD, 0xA, 0xB, 0x8, 0x9],
      \ [0x7, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1, 0x0, 0xF, 0xE, 0xD, 0xC, 0xB, 0xA, 0x9, 0x8],
      \ [0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF, 0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7],
      \ [0x9, 0x8, 0xB, 0xA, 0xD, 0xC, 0xF, 0xE, 0x1, 0x0, 0x3, 0x2, 0x5, 0x4, 0x7, 0x6],
      \ [0xA, 0xB, 0x8, 0x9, 0xE, 0xF, 0xC, 0xD, 0x2, 0x3, 0x0, 0x1, 0x6, 0x7, 0x4, 0x5],
      \ [0xB, 0xA, 0x9, 0x8, 0xF, 0xE, 0xD, 0xC, 0x3, 0x2, 0x1, 0x0, 0x7, 0x6, 0x5, 0x4],
      \ [0xC, 0xD, 0xE, 0xF, 0x8, 0x9, 0xA, 0xB, 0x4, 0x5, 0x6, 0x7, 0x0, 0x1, 0x2, 0x3],
      \ [0xD, 0xC, 0xF, 0xE, 0x9, 0x8, 0xB, 0xA, 0x5, 0x4, 0x7, 0x6, 0x1, 0x0, 0x3, 0x2],
      \ [0xE, 0xF, 0xC, 0xD, 0xA, 0xB, 0x8, 0x9, 0x6, 0x7, 0x4, 0x5, 0x2, 0x3, 0x0, 0x1],
      \ [0xF, 0xE, 0xD, 0xC, 0xB, 0xA, 0x9, 0x8, 0x7, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1, 0x0]
      \ ]

let &cpo = s:save_cpo
