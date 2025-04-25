# dotfiles

> :wrench: My modular dotfiles.


## usage

1. Read [hacking](#hacking).

#### bootstrap

```bash
curl -fsSL git.io/mwilliammyers-dotfiles | sh
```

Or omit some things (see [`bootstrap.sh`](./bootstrap.sh) for more ideas):
```bash
curl -fsSL git.io/mwilliammyers-dotfiles | DOTFILES_SKIP_NODEJS=1 sh
```

#### à la carte

Configure/install individual apps:
```bash
./bootstrap/rust.sh
```

#### hacking

You might want to make your own dotfiles repo. This repo might be a good place to start:

1. [Fork] this repository.
1. TODO


[@mwilliammyers]: https://github.com/mwilliammyers
[Fork]: https://github.com/mwilliammyers/dotfiles/fork
[`bootstrap.sh`]: ./bootstrap.sh
[rust]: https://www.rust-lang.org
[cargo]: https://doc.rust-lang.org/cargo/
