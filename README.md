
```shell
git clone https://github.com/silvern1990/astronvim_for_spring ~/.config/nvim
```

## troubleshooting

I'm using JDK 21, java-test doesn't work properly.

I confirmed that it works if I manually download and compile the latest source of vscode-java-test, and replace the contents of the mason package folder for java-test with the updated version



### On MacOS, nvim-dap-view not work 

nvim-dap-view does not work on macOS because Lua 5.1 is missing.
Homebrew does not support installing Lua 5.1, so instead, you can make a symlink from luajit to lua5.1.
