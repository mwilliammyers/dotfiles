function port_kill --description 'kills the process using the provided port'
  if test -z $argv[1]
		set_color red
		printf "You must enter a port number"
		set_color normal
    return
  end 

	set -l pid (lsof -t -i:$argv[1])
	if count $pid >  /dev/null
		set -l cmd (ps -p $pid -o command | tail -n 1)

		set_color -o
		echo "Pew! Pew!"
		set_color normal

		kill $pid

		printf "We killed "
		set_color red
		printf $cmd
		set_color normal
		printf "!\n"
	else
		echo "It was not very effective"
	end
end
