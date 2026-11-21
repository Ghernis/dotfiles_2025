local scheme_file = vim.fn.stdpath("state") .. "/colorscheme"

local function saved_scheme()
    if vim.uv.fs_stat(scheme_file) == nil then
        return nil
    end
    local lines = vim.fn.readfile(scheme_file)
    if lines[1] and lines[1] ~= "" then
        return lines[1]
    end
end

return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
    },
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 900,
        opts = { style = "night" },
        config = function(_, opts)
            require("tokyonight").setup(opts)

            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function(args)
                    vim.fn.mkdir(vim.fn.stdpath("state"), "p")
                    vim.fn.writefile({ args.match }, scheme_file)
                end,
            })

            local saved = saved_scheme()
            if not (saved and pcall(vim.cmd.colorscheme, saved)) then
                vim.cmd.colorscheme("tokyonight")
            end
        end,
    },
}
