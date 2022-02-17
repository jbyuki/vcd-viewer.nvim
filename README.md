vcd-viewer.nvim
===============

A waveform viewer for VCD files.

[![Screenshot-2022-02-17-121954.png](https://i.postimg.cc/WbkXV5RK/Screenshot-2022-02-17-121954.png)](https://postimg.cc/56fwqq2q)


Installation
------------

Install using your prefered method:
- [vim-plug](https://github.com/junegunn/vim-plug).
```vim
Plug 'jbyuki/vcd-viewer.nvim'
```

- [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use "jbyuki/vcd-viewer.nvim"
```

Usage
-----

* Open a *.vcd file
* Invoke `:lua require"vcd-viewer".view()`
