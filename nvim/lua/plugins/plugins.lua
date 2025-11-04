return {
    { 'numToStr/Comment.nvim' }, -- gc to comment
    { 'itchyny/vim-gitbranch' }, -- git branch in statusline
    { 'kshenoy/vim-signature' }, -- see marks
    { 'preservim/vim-pencil' }, -- SoftPencil
    { 'folke/tokyonight.nvim' }, -- other colorscheme
    { 'chaoren/vim-wordmotion' }, -- CamelCase and snake_case word boundaries
    { 'tpope/vim-surround' }, -- surround motions
    { 'tpope/vim-repeat' }, -- repeat vim-surround
    { 'ap/vim-css-color' }, -- see colors in the editor
    { 'stevearc/vim-arduino', ft = { 'arduino' } }, -- arduino builds
    {
        "R-nvim/R.nvim",
         -- Only required if you also set defaults.lazy = true
        lazy = false,
        -- R.nvim is still young and we may make some breaking changes from time
        -- to time (but also bug fixes all the time). If configuration stability
        -- is a high priority for you, pin to the latest minor version, but unpin
        -- it and try the latest version before reporting an issue:
        -- version = "~0.1.0"
        config = function()
            -- Create a table with the options to be passed to setup()
            ---@type RConfigUserOpts
            local opts = {
                hook = {
                    on_filetype = function()
                        vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
                        vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
                    end
                },
                R_args = {"--quiet", "--no-save"},
                min_editor_width = 72,
                rconsole_width = 78,
                objbr_mappings = { -- Object browser keymap
                    c = 'class', -- Call R functions
                    ['<localleader>gg'] = 'head({object}, n = 15)', -- Use {object} notation to write arbitrary R code.
                    v = function()
                        -- Run lua functions
                        require('r.browser').toggle_view()
                    end
                },
                disable_cmds = {
                    "RClearConsole",
                    "RCustomStart",
                    "RSPlot",
                    "RSaveClose",
                },
            }
            -- Check if the environment variable "R_AUTO_START" exists.
            -- If using fish shell, you could put in your config.fish:
            -- alias r "R_AUTO_START=true nvim"
            if vim.env.R_AUTO_START == "true" then
                opts.auto_start = "on startup"
                opts.objbr_auto_start = true
            end
            require("r").setup(opts)
        end,
    },
    {
      "hrsh7th/nvim-cmp",
    },
    {
        "R-nvim/cmp-r",
        {
            "hrsh7th/nvim-cmp",
            config = function()
                require("cmp").setup({ sources = {{ name = "cmp_r" }}})
                require("cmp_r").setup({})
            end,
        },
    },
    -- {
    --   "jalvesaq/Nvim-R",
    --   ft = { "r", "rmd", "quarto" },
    --   config = function()
    --     vim.g.R_assign = 0
    --     vim.g.R_auto_start = 1
    --   end
    -- },
    {
        'ggandor/leap.nvim',
        config = function()
            vim.keymap.set('n',        's', '<Plug>(leap-anywhere)')
            vim.keymap.set({'x', 'o'}, 's', '<Plug>(leap)')
            -- require('leap').opts.safe_labels = {}
        end,
    },
    {
        'neoclide/coc.nvim', -- lsp, still faster than native sadly
        branch = release,
        config = function()
            -- Function to check backspace
            function _G.CheckBackspace()
                local col = vim.fn.col('.') - 1
                return col == 0 or string.match(vim.fn.getline('.'):sub(col, col), '%s') ~= nil
            end

            -- Tab completion mapping
            vim.api.nvim_set_keymap('i', '<TAB>', [[coc#pum#visible() ? coc#pum#next(1) : v:lua.CheckBackspace() ? "\<Tab>" : coc#refresh()]], {expr = true, silent = true})
            vim.api.nvim_set_keymap('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], {expr = true, silent = true})



            -- Function to show documentation
            function ShowDocumentation()
                if vim.fn.CocAction('hasProvider', 'hover') then
                    vim.fn.CocActionAsync('doHover')
                else
                    vim.api.nvim_feedkeys('K', 'in', false)
                end
            end

            -- GoTo code navigation
            vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', {silent = true})

            -- Toggle documentation preview
            vim.api.nvim_set_keymap('n', '?', ':lua ShowDocumentation()<CR>', {silent = true})
        end,
    },
    {
        'vimwiki/vimwiki', -- wikis
        event = { "BufEnter *.wiki", "BufRead *.wiki" },
        config = function()
            vim.g.vimwiki_ext2syntax = {}
            vim.g.vimwiki_key_mappings = { global = 0 }
        end,
    },
    {
        'ap/vim-buftabline', -- buffers in the tabline
        config = function()
            vim.g.buftabline_show = 1
        end,
    },
    {
        'nvim-tree/nvim-tree.lua', -- file view
        config = function()
            local function my_on_attach(bufnr)
                local api = require "nvim-tree.api"

                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- default mappings
                -- api.config.mappings.default_on_attach(bufnr)

                -- custom mappings
                vim.keymap.set('n', '?', api.tree.toggle_help, opts("Help"))
                vim.keymap.set('n', '<CR>', api.node.open.edit, opts("Open"))
            end

            vim.api.nvim_create_autocmd("QuitPre", {
                callback = function()
                    local invalid_win = {}
                    local wins = vim.api.nvim_list_wins()
                    for _, w in ipairs(wins) do
                        local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                        if bufname:match("NvimTree_") ~= nil then
                            table.insert(invalid_win, w)
                        end
                    end
                    if #invalid_win == #wins - 1 then
                        -- Should quit, so we close all invalid windows.
                        for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
                    end
                end
            })


            -- pass to setup along with your other options
            require("nvim-tree").setup {
                on_attach = my_on_attach,
                disable_netrw = False,
                hijack_netrw = True,
                git = {
                    enable = false
                }
            }
        end,
    },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    {
        'nvim-treesitter/nvim-treesitter', -- better highlights
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

        opts = {
            ensure_installed = { 'r','markdown','rnoweb','yaml','bash','c','diff','html',
                               'latex','lua','luadoc','markdown','markdown_inline',
                               'query','vim','vimdoc','python' },
            auto_install = true,

            highlight = { enable = true },
            indent = { enable = true },

            incremental_selection = {
                enable = true,
                keymaps = {
                  init_selection    = "gnn",
                  node_incremental  = "<cr>",
                  node_decremental  = "<backspace>",
                  scope_incremental = "grc",
                },
            },

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["al"] = "@loop.outer",
                        ["il"] = "@loop.inner",
                        ["ai"] = "@conditional.outer", 
                        ["ii"] = "@conditional.inner", 
                    },
                },
            },
        },
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config Release'
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>tf', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>tp', builtin.live_grep, { desc = 'Telescope grep pattern' })
            vim.keymap.set('n', '<leader>tg', builtin.git_files, { desc = 'Telescope git files' })
            vim.keymap.set('n', '<leader>ts', builtin.grep_string, { desc = 'Telescope grep string' })
            vim.keymap.set('n', '<leader>tc', function()
                builtin.find_files {
                    cwd = vim.fn.expand('~/.config')
                }
            end)
        end
    },
    {
        'stevearc/aerial.nvim',
        config = function()
            require('aerial').setup({
                backends = {
                    ['_']  = {"lsp", "treesitter"},
                    python = {"treesitter"},
                    rust   = {"lsp"},
                },
                keymaps = {
                    ["<esc>"] = "actions.close",
                    ["H"] = "actions.tree_decrease_fold_level",
                    ["L"] = "actions.tree_increase_fold_level",
                },

                post_jump_cmd = false,

                close_on_select = true,
                layout = {
                    default_direction = 'prefer_left',
                    min_width = {50, 0.3},
                },
            })
            -- You probably also want to set a keymap to toggle aerial
            vim.keymap.set("n", "<CR>", "<cmd>AerialToggle<CR>")
            opts = {} 
        end
    }, -- navigate
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        end
    }, -- see colors in the editor

    -- {
    --     'neovim/nvim-lspconfig',
    --     config = function()
    --         vim.cmd[[set completeopt+=menuone,noselect,popup,preview]]
    --         vim.lsp.enable('pyright')
    --         vim.api.nvim_create_autocmd('LspAttach', {
    --             group = vim.api.nvim_create_augroup('my.lsp', {}),
    --             callback = function(args)
    --                 local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    --                 if client:supports_method('textDocument/implementation') then
    --                     -- Create a keymap for vim.lsp.buf.implementation ...
    --                 end
    --                 -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    --                 if client:supports_method('textDocument/completion') then
    --                     local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
    --                     client.server_capabilities.completionProvider.triggerCharacters = chars
    --                     vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    --                 end
    --                 -- Auto-format ("lint") on save.
    --                 -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    --                 if not client:supports_method('textDocument/willSaveWaitUntil')
    --                     and client:supports_method('textDocument/formatting') then
    --                     vim.api.nvim_create_autocmd('BufWritePre', {
    --                         group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
    --                         buffer = args.buf,
    --                         callback = function()
    --                             vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
    --                         end,
    --                     })
    --                 end
    --             end,
    --         })
    --     end
    -- }, -- lsp defaults

}
