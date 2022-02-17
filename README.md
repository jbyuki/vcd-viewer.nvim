vcd-viewer.nvim
===============

A waveform viewer for VCD files.

[![Screenshot-2022-02-17-100855.png](https://i.postimg.cc/x81kk2KT/Screenshot-2022-02-17-100855.png)](https://postimg.cc/Vr2sT2G3)


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
