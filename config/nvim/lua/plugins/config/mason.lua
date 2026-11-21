return {
    "mason-org/mason.nvim",
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    },
    config = function(_, opts)
        require("mason").setup(opts)

        local tools = { "stylua", "shfmt" }
        local registry = require("mason-registry")
        local function ensure()
            for _, name in ipairs(tools) do
                local ok, pkg = pcall(registry.get_package, name)
                if ok and not pkg:is_installed() then
                    pkg:install()
                end
            end
        end

        if not pcall(registry.refresh, ensure) then
            ensure()
        end
    end,
}
