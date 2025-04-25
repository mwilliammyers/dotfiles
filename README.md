# dotfiles

> :wrench: My modular dotfiles.


## usage

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


[@mwilliammyers]: https://github.com/mwilliammyers
[Fork]: https://github.com/mwilliammyers/dotfiles/fork
[`bootstrap.sh`]: ./bootstrap.sh
[rust]: https://www.rust-lang.org
[cargo]: https://doc.rust-lang.org/cargo/
