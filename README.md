# dotfiles

> :wrench: My modular dotfiles.


## usage

1. Read [hacking](#hacking).

#### bootstrap

```bash
curl -fsSL git.io/mwilliammyers-dotfiles | sh
```

#### à la carte

Configure/install individual apps:
```bash
./rust.sh
```
...

## features

#### app highlights

general:
* [alacritty](https://github.com/jwilm/alacritty)* — A cross-platform, GPU enhanced terminal emulator
* [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) - combines the usability of The Silver Searcher with the raw speed of grep
* [chmln/sd](https://github.com/chmln/sd)* - Intuitive find & replace CLI
* [cristianoliveira/funzzy](https://github.com/cristianoliveira/funzzy)* - A configurable filesystem watcher inspired by [entr](http://entrproject.org/)
* [dandavison/delta](https://github.com/dandavison/delta) - A syntax-highlighting pager for `git` and diff output
* [denoland/deno](https://github.com/denoland/deno)* — A secure JavaScript/TypeScript runtime built with V8, Rust, and Tokio
* [jhspetersson/fselect](https://github.com/jhspetersson/fselect)* - Find files with SQL-like queries
* [ogham/exa](https://github.com/ogham/exa) - A replacement for `ls`
* [Peltoche/lsd](https://github.com/Peltoche/lsd)* - An ls with a lot of pretty colors and awesome icons
* [sharkdp/bat](https://github.com/sharkdp/bat) - A `cat(1)` clone with wings.
* [sharkdp/fd](https://github.com/sharkdp/fd) - A simple, fast and user-friendly alternative to find.
* [sitkevij/hex](https://github.com/sitkevij/hex)* - A colorized hexdump terminal utility.
* [toshi-search/Toshi](https://github.com/toshi-search/Toshi)* - A full-text search engine in rust
* [XAMPPRocky/tokei](https://github.com/XAMPPRocky/tokei)* - counts the lines of code
* [xi-editor](https://github.com/xi-editor/xi-editor)* - A modern editor with a backend written in Rust.
* [lotabout/skim](https://github.com/lotabout/skim)* - A fuzzy finder in pure rust
* [junegunn/fzf](https://github.com/junegunn/fzf) - 🌸 A command-line fuzzy finder
* [stedolan/jq](https://github.com/stedolan/jq) - Command-line JSON processor

[rust]/[cargo]:
* [cargo-edit](https://crates.io/crates/cargo-edit) - allows you to add and list dependencies by reading/writing to your Cargo.toml file from the command line
* [cargo-watch](https://crates.io/crates/cargo-watch) - utility for cargo to compile projects when sources change
* [cargo-tree](https://github.com/sfackler/cargo-tree) – Cargo subcommand that visualizes a crate's dependency graph in a tree-like format
* [messense/rust-musl-cross](https://github.com/messense/rust-musl-cross) - Docker images for compiling static Rust binaries using musl-cross

\* WIP: these dotfiles do not install this yet

## notes

My dotfiles are under construction; use/fork/hack this repo at your own risk.

#### hacking

You might want to make your own dotfiles repo. This repo might be a good place to start:

1. [Fork] this repository.
1. TODO



[@mwilliammyers]: https://github.com/mwilliammyers
[GNU]: http://www.gnu.org/
[OS X]: http://www.apple.com/osx/
[Xcode]: https://developer.apple.com/xcode/
[ansible]: https://www.ansible.com/
[ansible_install]: http://docs.ansible.com/ansible/intro_installation.html
[aura]: https://github.com/aurapm/aura
[bash]: https://www.gnu.org/software/bash/manual/bashref.html
[coreutils]: http://www.gnu.org/software/coreutils/
[default variables]: defaults/main.yml
[dotstrap's]: https://github.com/dotstrap
[dotstrap]: https://github.com/dotstrap
[fasd]: https://github.com/clvv/fasd
[files]: files/
[Fork]: #fork-destination-box
[fish]: http://fishshell.com/
[homebrew]: https://github.com/Homebrew/homebrew
[host_vars]: host_vars/
[neovim]: https://github.com/neovim/neovim
[pip]: https://github.com/pypa/pip
[pure]: https://github.com/sindresorhus/pure
[speedcola]: https://github.com/mwilliammyers/speedcola
[variables]: vars/main.yml
[yaourt]: https://github.com/archlinuxfr/yaourt
[z]: https://github.com/rupa/z
[zsh]: http://zsh.sourceforge.net
[rust]: https://www.rust-lang.org
[cargo]: https://doc.rust-lang.org/cargo/
