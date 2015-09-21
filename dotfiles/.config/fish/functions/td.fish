function td --description 'creates a temporary dir and then goes there'
  if test -n "$TMPDIR"
    set tempdir $TMPDIR/temp-(random)
  else 
    set tempdir /tmp/temp-(random)
  end
	mkdir $tempdir
	cd $tempdir
end
