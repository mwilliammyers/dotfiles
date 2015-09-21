function mkcd --description 'creates given directory and then goes there'
	mkdir -p $argv[1]
	cd $argv[1]
end
