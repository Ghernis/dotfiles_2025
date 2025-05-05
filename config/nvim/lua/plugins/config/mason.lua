-- Mason Setup
--require("mason").setup({
--    ui = {
--        icons = {
--            package_installed = "",
--            package_pending = "",
--            package_uninstalled = "",
--        },
--    }
--})
--require("mason-lspconfig").setup()
return {
    {
        "williamboman/mason.nvim",
        dependencies = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
        build = ":MasonUpdate",
        config = function()
            require("gherni.mason")
        end,
    },
}
