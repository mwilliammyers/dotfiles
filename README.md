# dotfiles

[![Build Status](https://travis-ci.org/mwilliammyers/dotfiles.svg?branch=master)](https://travis-ci.org/mwilliammyers/dotfiles)

> :wrench: My personal, modular dotfiles. Powered by [ansible].


## usage

1. Read [hacking](#hacking).
1. Install the role dependencies:

    ```bash
    ansible-galaxy install -r requirements.yml
    ```
1. Run all the playbooks: 

    ```bash
    ansible-playbook site.yml
    ```

Note: you might need to supply options to `ansible-playbook` like
`--ask-vault-password` or `--ask-become-pass`. Run `ansible-playbook --help`
for more options.

#### bootstrap 

Install [ansible] and then run every applicable playbook:

```bash
./bootstrap.sh
```

#### à la carte

Run individual playbooks:

```bash
ansible-playbook neovim.yml 
```

```bash
ansible-playbook fish.yml 
```

...


## notes

My dotfiles are under construction; use/fork/hack this repo at your own risk.

#### hacking

You might want to make your own dotfiles repo. This repo might be a good place to start:

1. [Fork] this repository.

1. (optional?) Edit `secrets.yml`.

1. Edit [host_vars].

#### secrets

I use some secret variables in a couple of these playbooks. They are encrypted
in the file `secrets.yml`, so remove it & then do `ansible-vault create
secrets.yml` 

My `secrets.yml` looks something like this:

```yaml
---

hosts:
  <host nickname>:
      user: <username on remote host>
      hostname: <hostname>
      ansible_shell_type: fish
      host_vars: ansible_ssh_pipelining=yes ansible_python_interpreter=/usr/local/bin/python
  <other host nickname>:
      user: <other username on remote host>
      hostname: <other hostname>
      ansible_shell_type: bash

github_username: <username>
github_email: <email>

homebrew_github_api_token: <token>
```


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
