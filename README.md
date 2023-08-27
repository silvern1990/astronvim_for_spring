

User Configuration file for using astronvim as spring IDE.



# apply configuration 

move contents of this to ~/.config/nvim/lua/user directory.



# Required LspInstall:

1. jdtls
2. lemminx



# For Debugging

have to call setup_dap_main_class_configs() to find main class of project after require"jdtls" is completed
to do that, insert code calling function
into ~/.local/share/nvim/lazy/nvim-jdtls/lua/jdtls/setup.lua
like below example.

```
config.name = 'jdtls'
local on_attach = config.on_attach
config.on_attach = function(client, bufnr)
  if on_attach then
    on_attach(client, bufnr)
    require("jdtls.dap").setup_dap_main_class_configs()
  end
  add_commands(client, bufnr, opts)
end
```

