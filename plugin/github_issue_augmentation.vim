let s:cpo_save = &cpo
set cpo&vim

" github_issue_augmentation.vim

let s:issue_prop_name = 'IssueDescription'

function! s:load_issue_titles()
  let s:issue_table = {}
  let file_path = expand(g:github_issue_map_file)
  if filereadable(file_path)
    let lines = readfile(file_path)
    for line in lines
      let parts = split(line, '\t')
      let issue_id = parts[0]
      let title = parts[1]
      let s:issue_table[issue_id] = title
    endfor
  endif
endfunction

function! s:detect_issues()
  let lnum = line('w0') " first visible line
  while lnum <= line('w$') " last visible line
    call prop_clear(lnum)
    let line_text = getline(lnum)
    let match_start_index = 0
    while match_start_index >= 0
      let [issue_id, starts, ends] = matchstrpos(line_text, '#\d\{1,5\}', match_start_index)
      if issue_id != ''
        let match_start_index = match_start_index + ends + 1
        let issue_id = substitute(issue_id, '#', '', '')
        let title = get(s:issue_table, issue_id, '')
        if title != ''
          call prop_add(lnum, ends + 1, { 'text': ' ' .. title, 'type': s:issue_prop_name })
        endif
      else
        let match_start_index = -1
      endif
    endwhile
    let lnum = lnum + 1
  endwhile
endfunction

function! s:update_issue_titles()
  if prop_type_list()->index(s:issue_prop_name) == -1
    call prop_type_add(s:issue_prop_name, { 'highlight': 'Comment', 'priority': 10 })
  endif

  call prop_clear(1, line('$'), { 'name': s:issue_prop_name })

  call s:load_issue_titles()
  call s:detect_issues()
endfunction

augroup detectIssues
  autocmd!
  autocmd BufEnter * call s:update_issue_titles()
  autocmd CursorMoved,CursorMovedI * call s:detect_issues()
  autocmd TextChanged,TextChangedI * call s:detect_issues()
augroup END

let &cpo = s:cpo_save
unlet! s:cpo_save

