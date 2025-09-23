vim.g.wordmotion_nomap = 1
vim.g.wordmotion_on = 0

vim.api.nvim_create_user_command('WordMotionToggle', function()
    if vim.g.wordmotion_on == 1 then
        print("WordMotion off")
        vim.g.wordmotion_on = 0
        vim.api.nvim_del_keymap('n', 'w')
        vim.api.nvim_del_keymap('n', 'b')
        vim.api.nvim_del_keymap('n', 'e')
        -- vim.api.nvim_del_keymap('n', 'iw')
        -- vim.api.nvim_del_keymap('n', 'aw')
    else
        print("WordMotion on")
        vim.g.wordmotion_nomap = 0
        vim.g.wordmotion_on = 1

        -- Assuming you have the wordmotion functionality available
        vim.cmd([[call wordmotion#reload()]])
    end
end, {})

vim.g.darkmode = 0
vim.api.nvim_create_user_command('ColorschemeToggle', function()
    if vim.g.darkmode == 1 then
        vim.cmd("colorscheme onequarterlight")
        vim.g.darkmode = 0
    else
        vim.cmd("colorscheme tokyonight-night")
        vim.g.darkmode = 1
    end
end, {})

vim.api.nvim_create_user_command('ProseStart', function()
    vim.opt_local.linebreak = true
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(0, 'n', 'j', 'gj', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', 'k', 'gk', opts)
    vim.api.nvim_buf_set_keymap(0, 'v', 'j', 'gj', opts)
    vim.api.nvim_buf_set_keymap(0, 'v', 'k', 'gk', opts)
end, {})

vim.api.nvim_create_user_command('ProseStop', function()
    vim.opt_local.linebreak = false
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_del_keymap(0, 'n', 'j')
    vim.api.nvim_buf_del_keymap(0, 'n', 'k')
    vim.api.nvim_buf_set_keymap(0, 'v', 'j')
    vim.api.nvim_buf_set_keymap(0, 'v', 'k')
end, {})

vim.api.nvim_create_user_command('SynStack', function()
    -- Check if the synstack function exists
    if not vim.fn.exists("*synstack") then
        return
    end

    local line_num = vim.fn.line('.')
    local col_num = vim.fn.col('.')

    -- Use synstack to get the highlight groups on the current cursor position
    local stacks = vim.fn.synstack(line_num, col_num)
    
    -- Map the stack IDs to their names
    local highlight_names = {}
    for _, id in ipairs(stacks) do
        table.insert(highlight_names, vim.fn.synIDattr(id, "name"))
    end

    -- Print the result
    print(vim.inspect(highlight_names)) -- You can modify how you want to display the output
end, {})

vim.api.nvim_create_user_command('CompileLatex', function()
    -- Check if Makefile exists in the current directory
    print('Compiling...')
    local makefile = vim.fn.getcwd() .. '/Makefile'
    if vim.fn.filereadable(makefile) == 1 then
        -- Run make if Makefile exists
        vim.fn.jobstart({'make'}, {
            on_stdout = function(_, data)
                if data then
                    -- print(table.concat(data, '\n'))
                end
            end,
            on_stderr = function(_, data)
                if data then
                    -- print(table.concat(data, '\n'))
                end
            end,
            on_exit = function(_, code)
                if code == 0 then
                    print("Compile successful!")
                else
                    print("Compile failed!")
                end
            end,
        })
    else
        -- Run pdflatex on the current file if no Makefile exists
        local current_file = vim.fn.expand('%')
        vim.fn.jobstart({'pdflatex', current_file}, {
            on_stdout = function(_, data)
                if data then
                    -- print(table.concat(data, '\n'))
                end
            end,
            on_stderr = function(_, data)
                if data then
                    -- print(table.concat(data, '\n'))
                end
            end,
            on_exit = function(_, code)
                if code == 0 then
                    print("Compile successful!")
                else
                    print("Compile failed!")
                end
            end,
        })
    end
end, {})
