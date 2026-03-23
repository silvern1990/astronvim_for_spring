return {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
        ensure_installed = { "js" },
        handlers = {
            js = function(config)
                local dap = require("dap")

                dap.adapters["pwa-node"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "js-debug-adapter",
                        args = { "${port}" },
                    },
                }

                dap.configurations.javascript = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach to process",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }

                dap.configurations.typescript = dap.configurations.javascript
            end,
        },
    },
}
