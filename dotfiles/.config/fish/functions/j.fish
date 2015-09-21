function --on-event fish_preexec _run_fasd
  fasd --proc (fasd --sanitize "$argv") > "/dev/null" 2>&1
end 

function j
  cd (fasd -d -e 'printf %s' "$argv")
end
