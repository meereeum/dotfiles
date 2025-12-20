" try cycle for days of the week
" based on: https://github.com/zef/vim-cycle/blob/master/plugin/cycle.vim


let g:days = ['M', 'T', 'W', 'R', 'F', 'Sat', 'Sun'] " globally scoped
let g:time = ['am', 'pm']


let g:groups = [days, time]



function! s:Cycle(direction)

    " let l:group = g:days " simplify: just define one cycle group
	let match = s:matchInList(g:groups)

	if empty(match)
		if a:direction == 1
			exe "norm! " . v:count1 . "\<C-A>"
		else
			exe "norm! " . v:count1 . "\<C-X>"
		endif
	else
		" let [start, end, string] = match
		let [group, start, end, string] = match

		let index = index(group, string) + a:direction
		let max_index = (len(group) - 1)

		if index > max_index
			let index = 0
		endif

		call s:replaceinline(start,end,group[index])
	endif

endfunction


" returns the following list if a match is found:
" [start, end, string]
"
" returns [] if no match is found
function! s:matchInList(list_of_groups)

    for group in copy(a:list_of_groups)
        " We must iterate each group with the longest values first.
        " This covers a case like ['else', 'else if'] where the
        " first will match successfuly even if the second could
        " be matched. Checking for the longest values first
        " ensures that the most specific match will be returned
        for item in sort(copy(group), "s:sorterByLength")
            let match = s:findinline(item)
            if match[0] >= 0
                " return match
                return [group] + match
            endif
        endfor
    endfor

    return []
endfunction



function! s:sorterByLength(item, other)
	return len(a:other) - len(a:item)
endfunction


function! s:findinline(pattern)
    return s:findatoffset(getline('.'),a:pattern,col('.')-1)
endfunction


" pulled the following out of speeddating.vim
" modified slightly
function! s:findatoffset(string,pattern,offset)
    let line = a:string
    let curpos = 0
    let offset = a:offset
    while strpart(line,offset,1) == " "
        let offset += 1
    endwhile
    let [start,end,string] = s:match(line,a:pattern,curpos,0)
    while start >= 0
        if offset >= start && offset < end
            break
        endif
        let curpos = start + 1
        let [start,end,string] = s:match(line,a:pattern,curpos,0)
    endwhile
    return [start,end,string]
endfunction


function! s:replaceinline(start,end,new)
    let line = getline('.')
    let before_text = strpart(line,0,a:start)
    let after_text = strpart(line,a:end)
    " If this generates a warning it will be attached to an ugly backtrace.
    " No warning at all is preferable to that.
    silent call setline('.',before_text.a:new.after_text)
    call setpos("'[",[0,line('.'),strlen(before_text)+1,0])
    call setpos("']",[0,line('.'),a:start+strlen(a:new),0])
endfunction


function! s:match(...)
    let start   = call("match",a:000)
    let end     = call("matchend",a:000)
    let matches = call("matchlist",a:000)
    if empty(matches)
      let string = ''
    else
      let string = matches[0]
    endif
    return [start, end, string]
endfunction


" map stuff
nnoremap <silent> <Plug>CycleNext     :<C-U>call <SID>Cycle(1)<CR>
nnoremap <silent> <Plug>CyclePrevious :<C-U>call <SID>Cycle(-1)<CR>
nmap    <C-A>   <Plug>CycleNext
nmap	<C-X>   <Plug>CyclePrevious
