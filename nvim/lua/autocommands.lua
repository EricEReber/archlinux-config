-- Start on last edited line
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        if vim.fn.line('\'"') > 0 and vim.fn.line('\'"') <= vim.fn.line('$') then
            vim.cmd("normal g'\"")
        end
    end,
})

-- Make enter work on command line
vim.api.nvim_create_augroup("CommandLineWindow", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
    group = "CommandLineWindow",
    pattern = "*",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<CR>', { noremap = true, silent = true })
    end
})
vim.api.nvim_create_autocmd("CmdwinLeave", {
    group = "CommandLineWindow",
    pattern = "*",
    callback = function()
        vim.api.nvim_buf_del_keymap(0, 'n', '<CR>')
    end
})

-- Text files
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"text", "markdown", "vimwiki", "tex"},
    callback = function()
        vim.cmd("ProseStart")
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"text", "tex"},
    callback = function()
        vim.opt_local.spell = true
    end,
})

-- Python
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ":w<CR>:exec '!python3' shellescape(@%, 1)<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'i', '<C-b>', "<esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>", { noremap = true, silent = true })
        vim.b.coc_diagnostic_disable = 1
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>b', ":!ruff format %<CR>", { noremap = true, silent = true })
        vim.opt_local.foldmethod = 'indent'
        vim.fn.matchadd("Todo", [[\v<(TODO|FIXME|NOTE)>]])
    end,
})

-- LaTeX
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ":w<CR>:CompileLatex<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'i', '<C-b>', "<esc>:w<CR>:CompileLatex<CR>", { noremap = true, silent = true })
        vim.opt_local.conceallevel = 0
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>b', ":!bibtex %<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>v', ":!biber %<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>l', ":w<CR>:exec '!pdflatex %'<CR>", { noremap = true, silent = true })
    end,
})

-- C
vim.api.nvim_create_autocmd("FileType", {
    pattern = "c",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ":w<CR>:!gcc -g -Wall -Wextra -std=gnu11 % -o %< && ./%<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'i', '<C-b>', "<esc>:w<CR>:!gcc -g -Wall -Wextra -std=gnu11 % -o %< && ./%<CR>", { noremap = true, silent = true })
    end,
})

-- C++
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ":w<CR>:!g++ % && ./a.out<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'i', '<C-b>', "<esc>:w<CR>:!g++ % -o %< && ./%<CR>", { noremap = true, silent = true })
    end,
})

-- Java
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ":w<CR>:exec '!javac *.java && java %'<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'i', '<C-b>', "<esc>:w<CR>:!javac *.java && java %<CR>", { noremap = true, silent = true })
    end,
})

-- VHDL
vim.api.nvim_create_autocmd("FileType", {
    pattern = "vhdl",
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 2
    end,
})

-- -------- shell --------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "sh",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ':w<CR>:!sh %<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'i', '<C-b>', '<esc>:w<CR>:!sh %<CR>', { noremap = true, silent = true })
    end,
})

-- -------- lua --------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ':w<CR>:!lua %<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'i', '<C-b>', '<esc>:w<CR>:!lua %<CR>', { noremap = true, silent = true })
    end,
})

-- --------- R -----------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "r",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ':w<CR>:!Rscript %<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'i', '<C-b>', '<esc>:w<CR>:!Rscript %<CR>', { noremap = true, silent = true })
        vim.opt_local.shiftwidth = 2
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>r', '{opng("temp")<esc>}Odev.off()<CR>system("xdg-open temp")<esc>', { noremap = true, silent = true })
    end,
})

-- ------- gdscript --------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gdscript",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ':w<CR>:exec "!godot --path $(pwd)"<CR>', { noremap = true, silent = true })
        vim.opt_local.expandtab = false
    end,
})

-- ------- arduino --------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "arduino",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ':w<CR>:ArduinoUpload<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, 'i', '<C-b>', '<esc>:w<CR>:ArduinoUpload<CR>', { noremap = true, silent = true })
    end,
})

-- ------ markdown --------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<C-b>', ':w<CR>:exec "!pandoc % --standalone --output %<.pdf"<CR>', { noremap = true, silent = true })
    end,
})

-- Remote files
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "scp://*",
    callback = function()
        vim.opt.cmdheight = 2  -- to stop stupid confirmation message
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("WordMotionToggle")
  end,
})
