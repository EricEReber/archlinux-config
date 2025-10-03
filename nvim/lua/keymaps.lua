local function map(m, k, v)
	vim.keymap.set(m, k, v, { silent = true })
end

-- Clear search highlights with <leader><CR>
vim.keymap.set('n', '<leader><CR>', function()
  vim.cmd('nohlsearch')
end, { silent = true, desc = 'Clear search highlights' })

-- Do an operator on every line in the file (dag, yag, =ag)
map("x", "ag", "ggoG")
map("o", "ag", ":normal Vag<cr>")

map("n", "<A-j>", ":m .+1<CR>")
map("n", "<A-k>", ":m .-2<CR>")
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")

map("n", "<leader>tt", ":ColorschemeToggle<cr>")
map("n", "<leader>p", "\"+p")
map("n", "<leader>y", "\"+y")
map("n", "<leader>Y", "\"+y$")
map("v", "<leader>y", "\"+y")



map("n", "gp", ":put<CR>")
vim.keymap.set("n", "<leader>w", ":WordMotionToggle<cr>", { nowait = true})
map("n", "<BS>", ":NvimTreeToggle<CR>")

-- remove ighlight for last searched
map("n", "<leader><BS>", ":noh<CR>")

-- schmoovement
vim.keymap.set("n", "J", ":keepjumps normal! }<CR>", { remap = true, silent = true })
vim.keymap.set("n", "K", ":keepjumps normal! {<CR>", { remap = true, silent = true })
vim.keymap.set("o", "J", ":keepjumps normal! }<CR>", { remap = true, silent = true })
vim.keymap.set("o", "K", ":keepjumps normal! {<CR>", { remap = true, silent = true })

map("x", "J", ":<C-u>keepjumps normal! gv}<CR>")
map("x", "K", ":<C-u>keepjumps normal! gv{<CR>")


map("n", "}", "J")
map("n", "{", "?")


-- S is cc so pointless. S is for save
map("n", "S", ":w<CR>")
-- M is for middle of screen but who cares. M for Make this damn file close
map("n", "M", ":q<CR>")

-- U is undo line which is stupid
map("n", "U", "<C-r>")


-- move mellom tabs
map("n", "H", ":bprev<CR>")
map("n", "L", ":bnext<CR>")
-- aapne tabs og splits
map("n", "<leader>v", ":vsplit")
-- replace alt som ble soekt paa sist
vim.keymap.set("n", "<leader>s", ":%s///g<Left><Left>")
vim.keymap.set("v", "<leader>s", ":s///g<Left><Left>")
-- bedre shift yank
vim.keymap.set("n", "Y", "y$", { remap = true})

-- format python
-- make print(x) into print(f"{x=}")
map("n", "<leader>f", "0f(af'{<ESC>$i=}'<ESC>")
map("n", "<leader>m", ":delmarks!<CR>")
map("n", "<leader>z", ":!zathura %<.pdf & <CR><CR>")
map("n", "<leader>d", ":bp<BAR>bd#<CR>")
vim.keymap.set("n", "<leader>c", ":colorscheme ")

map("n", "<leader>h", ":SynStack<CR>")
