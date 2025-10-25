
```shell
git clone https://github.com/silvern1990/astronvim_for_spring ~/.config/nvim
```

## troubleshooting

I'm using JDK 21, java-test doesn't work properly.

I confirmed that it works if I manually download and compile the latest source of vscode-java-test, and replace the contents of the mason package folder for java-test with the updated version



### On MacOS, nvim-dap-view not work 

nvim-dap-view not work in MacOS because of missing of lua 5.1.

brew could not support lua5.1 install, instead of making symlink of lua5.1 to luajit

