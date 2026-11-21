return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "saghen/blink.cmp",
        {
            "folke/lazydev.nvim",
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    },
    config = function()
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                },
            },
        })

        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = { border = "rounded" },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local buf = args.buf
                local map = function(lhs, rhs)
                    vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true })
                end
                map("gd", vim.lsp.buf.definition)
                map("gr", vim.lsp.buf.references)
                map("K", vim.lsp.buf.hover)
                map("<leader>rn", vim.lsp.buf.rename)
                map("<leader>ca", vim.lsp.buf.code_action)
            end,
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "bashls",
                "basedpyright",
                "ruff",
                "gopls",
            },
        })
    end,
}
