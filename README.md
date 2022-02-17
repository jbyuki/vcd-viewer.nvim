vcd-viewer.nvim
===============

A waveform viewer for VCD files.

[![Screenshot-2022-02-17-114832.png](https://i.postimg.cc/SN4sx50z/Screenshot-2022-02-17-114832.png)](https://postimg.cc/PN6h6S5t)


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
