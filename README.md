# dotfiles

> :wrench: My personal, modular dotfiles. Powered by Ansible. [WIP]

## Requirements

[ansible]

## Bootstrap

[WIP]

```bash
./bootstrap.sh
```

You will need to [edit](#secrets) `secrets.yml`...

## Pick

install the role dependencies:

```bash
ansible-galaxy install -r requirements.yml
```

run individual playbooks:

```bash
ansible-playbook neovim.yml 
```

```bash
ansible-playbook fish.yml 
```

...

## Hack

I highly recommend forking this repository. 

#### secrets

I use some secret variables in a couple of these playbooks. They are encrypted in the file `secrets.yml`, so remove it & then do `ansible-vault create secrets.yml` 

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
[ansible]: http://www.ansible.com/
[aura]: https://github.com/aurapm/aura
[bash]: https://www.gnu.org/software/bash/manual/bashref.html
[coreutils]: http://www.gnu.org/software/coreutils/
[default variables]: defaults/main.yml
[dotstrap]: https://github.com/mwilliammyers/dotstrap
[fasd]: https://github.com/clvv/fasd
[files]: files/
[fish]: http://fishshell.com/
[homebrew]: https://github.com/Homebrew/homebrew
[neovim]: https://github.com/neovim/neovim
[pip]: https://github.com/pypa/pip
[pure]: https://github.com/sindresorhus/pure
[speedcola]: https://github.com/mwilliammyers/speedcola
[variables]: vars/main.yml
[yaourt]: https://github.com/archlinuxfr/yaourt
[z]: https://github.com/rupa/z
[zsh]: http://zsh.sourceforge.net
