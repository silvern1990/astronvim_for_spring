

User Configuration file for using astronvim as spring IDE.



# apply configuration 

1. move contents of this to ~/.config/nvim/lua/user directory.

2. edit init.lua for personal environments.


# Required Install:
1. java-debug - https://github.com/microsoft/java-debug
2. <a href="https://github.com/mfussenegger/nvim-jdtls#nvim-dap-setup">vscode-java-test</a> - https://github.com/microsoft/vscode-java-test


# Required LspInstall:

1. jdtls
2. html


# For Debugging

have to call setup_dap_main_class_configs() to find main class of project after require"jdtls" is completed
to do that, insert code calling function
into ~/.local/share/nvim/lazy/nvim-jdtls/lua/jdtls/setup.lua
like below example.

```
---@param opts? jdtls.start.opts
function M.start_or_attach(config, opts)
  opts = opts or {}
  assert(config, 'config is required')
  assert(
    config.cmd and type(config.cmd) == 'table',
    'Config must have a `cmd` property and that must be a table. Got: '
      .. table.concat(config.cmd, ' ')
  )
  config.name = 'jdtls'
  local on_attach = config.on_attach
  config.on_attach = function(client, bufnr)
    if on_attach then
      on_attach(client, bufnr)
      require("jdtls.dap").setup_dap_main_class_configs()   <----- this code 
    end
    add_commands(client, bufnr, opts)
  end

```

