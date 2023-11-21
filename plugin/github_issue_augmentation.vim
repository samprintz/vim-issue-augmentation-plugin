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
      let parts = split(line, ',')
      let issue_id = parts[0]
      let title = parts[1]
      let s:issue_table[issue_id] = title
    endfor
  endif
endfunction

function! s:detect_issues()
  let lnum = 1
  while lnum <= line('$')
    call prop_clear(lnum)
    let line_text = getline(lnum)
    let [issue_id, starts, ends] = matchstrpos(line_text, '#\d\{1,5\}')
    let issue_id = substitute(issue_id, '#', '', '')
    let title = get(s:issue_table, issue_id, '')
    if title != ''
      call prop_add(lnum, ends + 1, { 'text': ' ' .. title, 'type': s:issue_prop_name })
    endif
    let lnum = lnum + 1
  endwhile
endfunction

function! s:update_issue_titles()
  call prop_type_add(s:issue_prop_name, { 'highlight': 'SpecialComment', 'priority': 10 })
  call prop_clear(1, line('$'), { 'name': s:issue_prop_name })

  call s:load_issue_titles()
  call s:detect_issues()
endfunction

augroup detectIssues
  autocmd!
  autocmd BufEnter * call s:update_issue_titles()
  autocmd TextChanged,TextChangedI * call s:detect_issues()
augroup END

let &cpo = s:cpo_save
unlet! s:cpo_save

