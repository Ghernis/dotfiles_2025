return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local parsers = {
            "bash",
            "c",
            "go",
            "json",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "vim",
            "vimdoc",
            "yaml",
        }

        if vim.fn.executable("tree-sitter") == 0 then
            vim.notify(
                "tree-sitter CLI is not on PATH, so parsers were not built. Install it, then restart Neovim.",
                vim.log.levels.WARN
            )
        else
            local ok, err = pcall(function()
                require("nvim-treesitter").install(parsers):wait(300000)
            end)
            if not ok then
                vim.notify("treesitter install failed: " .. tostring(err), vim.log.levels.WARN)
            end
        end

        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                if pcall(vim.treesitter.start) then
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo.foldlevel = 99
                end
            end,
        })
    end,
}
