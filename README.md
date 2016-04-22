My Dotfiles
===========

## Installing

Clone the repo onto your local machine.

    $ git clone git@github.com:maxluzuriaga/dotfiles.git ~/dotfiles

Then run the install script from within the directory to set up the symlinks in `~`. The script automatically archives existing dotfiles that it replaces by moving them into the dotfiles folder with the extension `.old`. Useful if you want to keep the old dotfiles around for later.

    $ cd ~/dotfiles
    $ source install.sh

Note that you can override or add additional configuration on local machines for Bash and Vim by creating and editing `~/.bashrc_local` or `~/.vimrc_local` respectively.

## Credit

Inspiration / code for the install script came from [jeffaco's dotfile repo](https://github.com/jeffaco/msft-dotfiles).

Credit also to [anishathalye](https://github.com/anishathalye) for the idea of having a local vimrc file for each installation for machine-specific Vim config. Taken from [his .vimrc here](https://github.com/anishathalye/dotfiles/blob/master/vimrc).
