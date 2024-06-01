-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {

    "nvim-lua/plenary.nvim",

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup()
        end,
        ft = { "css", "html", "lua", "rust", "typescript", "cpp", "c" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },

    {
        "NvChad/base46",
        branch = "v2.0",
        build = function()
            require("base46").load_all_highlights()
        end,
    },

    {
        "NvChad/ui",
        branch = "v2.0",
        lazy = false,
    },

    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = function()
            require("crates").setup()
        end,
    },

    {
        "stevearc/conform.nvim",
        lazy = false,
        opts = function()
            return require "plugins.configs.conforme"
        end,

        config = function()
            require("conform").setup {

                -- Map of filetype to formatters
                formatters_by_ft = {
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                    h = { "clang-format" },
                    hpp = { "clang-format" },
                    lua = { "stylua" },
                    -- Conform will run multiple formatters sequentially
                    go = { "goimports", "gofmt" },
                    -- Use a sub-list to run only the first available formatter
                    javascript = { { "prettierd", "prettier" } },
                    -- You can use a function here to determine the formatters dynamically
                    python = function(bufnr)
                        if require("conform").get_formatter_info("ruff_format", bufnr).available then
                            return { "ruff_format" }
                        else
                            return { "isort", "black" }
                        end
                    end,
                    -- -- Use the "*" filetype to run formatters on all filetypes.
                    -- ["*"] = { "codespell" },
                    -- -- Use the "_" filetype to run formatters on filetypes that don't
                    -- -- have other formatters configured.
                    -- ["_"] = { "trim_whitespace" },
                },
                -- If this is set, Conform will run the formatter on save.
                -- It will pass the table to conform.format().
                -- This can also be a function that returns the table.
                format_on_save = {
                    -- I recommend these options. See :help conform.format for details.
                    lsp_fallback = true,
                    timeout_ms = 500,
                },
                -- If this is set, Conform will run the formatter asynchronously after save.
                -- It will pass the table to conform.format().
                -- This can also be a function that returns the table.
                format_after_save = {
                    lsp_fallback = true,
                },
                -- Set the log level. Use `:ConformInfo` to see the location of the log file.
                log_level = vim.log.levels.ERROR,
                -- Conform will notify you when a formatter errors
                notify_on_error = true,
                -- Custom formatters and changes to built-in formatters
            }
        end,
    },

    {
        "NvChad/nvterm",
        init = function()
            require("core.utils").load_mappings "nvterm"
        end,
        config = function(_, opts)
            require "base46.term"
            require("nvterm").setup(opts)
        end,
    },

    {
        "NvChad/nvim-colorizer.lua",
        init = function()
            require("core.utils").lazy_load "nvim-colorizer.lua"
        end,
        config = function(_, opts)
            require("colorizer").setup(opts)

            -- execute colorizer as soon as possible
            vim.defer_fn(function()
                require("colorizer").attach_to_buffer(0)
            end, 0)
        end,
    },

    {
        "nvim-tree/nvim-web-devicons",
        opts = function()
            return { override = require "nvchad.icons.devicons" }
        end,
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "devicons")
            require("nvim-web-devicons").setup(opts)
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        version = "2.20.7",
        init = function()
            require("core.utils").lazy_load "indent-blankline.nvim"
        end,
        opts = function()
            return require("plugins.configs.others").blankline
        end,
        config = function(_, opts)
            require("core.utils").load_mappings "blankline"
            dofile(vim.g.base46_cache .. "blankline")
            require("indent_blankline").setup(opts)
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        init = function()
            require("core.utils").lazy_load "nvim-treesitter"
        end,
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate",
        opts = function()
            return require "plugins.configs.treesitter"
        end,
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "syntax")
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- git stuff
    {
        "lewis6991/gitsigns.nvim",
        ft = { "gitcommit", "diff" },
        init = function()
            -- load gitsigns only when a git file is opened
            vim.api.nvim_create_autocmd({ "BufRead" }, {
                group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
                callback = function()
                    vim.fn.jobstart({ "git", "-C", vim.loop.cwd(), "rev-parse" }, {
                        on_exit = function(_, return_code)
                            if return_code == 0 then
                                vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
                                vim.schedule(function()
                                    require("lazy").load { plugins = { "gitsigns.nvim" } }
                                end)
                            end
                        end,
                    })
                end,
            })
        end,
        opts = function()
            return require("plugins.configs.others").gitsigns
        end,
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "git")
            require("gitsigns").setup(opts)
        end,
    },

    -- lsp stuff
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
        opts = function()
            return require "plugins.configs.mason"
        end,
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "mason")
            require("mason").setup(opts)

            -- custom nvchad cmd to install all mason binaries listed
            vim.api.nvim_create_user_command("MasonInstallAll", function()
                if opts.ensure_installed and #opts.ensure_installed > 0 then
                    vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
                end
            end, {})

            vim.g.mason_binaries_list = opts.ensure_installed
        end,
    },

    {
        "neovim/nvim-lspconfig",
        init = function()
            require("core.utils").lazy_load "nvim-lspconfig"
        end,
        config = function()
            require "plugins.configs.lspconfig"
        end,
    },

    -- load luasnips + cmp related in insert mode only
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                -- snippet plugin
                "L3MON4D3/LuaSnip",
                dependencies = "rafamadriz/friendly-snippets",
                opts = { history = true, updateevents = "TextChanged,TextChangedI" },
                config = function(_, opts)
                    require("plugins.configs.others").luasnip(opts)
                end,
            },

            -- autopairing of (){}[] etc
            {
                "windwp/nvim-autopairs",
                opts = {
                    fast_wrap = {},
                    disable_filetype = { "TelescopePrompt", "vim" },
                },
                config = function(_, opts)
                    require("nvim-autopairs").setup(opts)

                    -- setup cmp for autopairs
                    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
                    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end,
            },

            -- cmp sources plugins
            {
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
            },
        },
        opts = function()
            return require "plugins.configs.cmp"
        end,
        config = function(_, opts)
            require("cmp").setup(opts)
        end,
    },

    {
        "numToStr/Comment.nvim",
        keys = {
            { "gcc", mode = "n", desc = "Comment toggle current line" },
            { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
            { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
            { "gbc", mode = "n", desc = "Comment toggle current block" },
            { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
            { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
        },
        init = function()
            require("core.utils").load_mappings "comment"
        end,
        config = function(_, opts)
            require("Comment").setup(opts)
        end,
    },

    -- file managing , picker etc
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        init = function()
            require("core.utils").load_mappings "nvimtree"
        end,
        opts = function()
            return require "plugins.configs.nvimtree"
        end,
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "nvimtree")
            require("nvim-tree").setup(opts)
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        cmd = "Telescope",
        init = function()
            require("core.utils").load_mappings "telescope"
        end,
        opts = function()
            return require "plugins.configs.telescope"
        end,
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "telescope")
            local telescope = require "telescope"
            telescope.setup(opts)

            -- load extensions
            for _, ext in ipairs(opts.extensions_list) do
                telescope.load_extension(ext)
            end
        end,
    },

    -- Only load whichkey after all the gui
    {
        "folke/which-key.nvim",
        keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
        init = function()
            require("core.utils").load_mappings "whichkey"
        end,
        cmd = "WhichKey",
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "whichkey")
            require("which-key").setup(opts)
        end,
    },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
    table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
