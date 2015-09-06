# dotfiles

This is very much **WIP** as I am transitioning to [mackup] and more complete use of [antibody]. I might even use [ansible] and [battleschool].

## topical 
Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Erlang" — you can simply add a erlang directory and put files in there. Anything with an extension of .zsh will get automatically included into your shell. Anything with an extension of .symlink will get symlinked without extension into `$HOME` when you run the [bootstrap script](script/bootstrap).

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.
- **topic/install.sh**: Any file with this name and with exec permission, will
ran at bootstrap phase.

## plugins
Managed by [antibody],  a faster version of [antigen]
written in Go.

more info *coming soon* 

## compatibility

I try to keep it working in both Linux (no specific distro) and OS X,
mostly because I use OS X at home and Linux at work.


## thanks to…
* @mathiasbynens [legendary dotfiles](https://github.com/mathiasbynens/dotfiles)
* @caarlos0 and his [dotfiles](https://github.com/caarlos0/dotfiles),  as well as his super fast zsh bundler: [antibody]
* @Ira and his cool configuration syncing app [mackup]
* Many more people that I have copied/forked things from over the years.

[mackup]: https://github.com/lra/mackup
[antibody]: https://github.com/caarlos0/antibody
[antigen]: https://github.com/zsh-users/antigen
[battleschool]: https://github.com/spencergibb/battleschool
[ansible]: https://github.com/ansible/ansible

[pure]: https://github.com/sindresorhus/pure
[jvm]: https://github.com/caarlos0/jvm
[zsh-pg]: https://github.com/caarlos0/zsh-pg
[alias-tips]: https://github.com/djui/alias-tips
[zsh-mkc]: https://github.com/caarlos0/zsh-mkc
[zsh-git-sync]: https://github.com/caarlos0/zsh-git-sync
[zsh-completions]: https://github.com/zsh-users/zsh-completions
[zsh-open-pr]: https://github.com/caarlos0/zsh-open-pr
[zsh-syntax-highlighting]: https://github.com/zsh-users/zsh-syntax-highlighting
[zsh-history-substring-search]: https://github.com/zsh-users/zsh-history-substring-search
[Shellcheck]: https://github.com/koalaman/shellcheck
