# dotfiles

> :wrench: My modular dotfiles.


## usage

1. Read [hacking](#hacking).

#### bootstrap

```bash
curl -fsSL git.io/mwilliammyers-dotfiles | sh
```

Or omit some things (see [`bootstrap.sh`](./bootstrap.sh) :
```bash
curl -fsSL git.io/mwilliammyers-dotfiles | DOTFILES_SKIP_NODEJS=1 sh
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
* [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) - combines the usability of The Silver Searcher with the raw speed of grep
* [dandavison/delta](https://github.com/dandavison/delta) - A syntax-highlighting pager for `git` and diff output
* [eza-community/eza](https://github.com/eza-community/eza) - A replacement for `ls`
* [sharkdp/bat](https://github.com/sharkdp/bat) - A `cat(1)` clone with wings.
* [sharkdp/fd](https://github.com/sharkdp/fd) - A simple, fast and user-friendly alternative to find.
* [junegunn/fzf](https://github.com/junegunn/fzf) - 🌸 A command-line fuzzy finder
* [stedolan/jq](https://github.com/stedolan/jq) - Command-line JSON processor

[rust]/[cargo]:
* [messense/rust-musl-cross](https://github.com/messense/rust-musl-cross) - Docker images for compiling static Rust binaries using musl-cross

\* WIP: these dotfiles do not install this yet

## notes

My dotfiles are under construction; use/fork/hack this repo at your own risk.

#### hacking

You might want to make your own dotfiles repo. This repo might be a good place to start:

1. [Fork] this repository.
1. TODO


[@mwilliammyers]: https://github.com/mwilliammyers
