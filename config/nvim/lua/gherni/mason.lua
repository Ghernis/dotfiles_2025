require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        },
    }
})
require("mason-lspconfig").setup({
    ensure_installed = {
        "azure_pipelines_ls",
        "cmake",
        "gopls",
        "jedi_language_server",
        "lua_ls",
        "powershell_es",
        "pyright",
        "bashls",
    },
    automatic_installation = true,
})
