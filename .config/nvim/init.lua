-- Package manager setup {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local function create_augroup(filetype, callback)
	if type(filetype) == "table" then
		for _, ft in ipairs(filetype) do
			create_augroup(ft, callback)
		end
	else
		local group = vim.api.nvim_create_augroup(filetype .. "_augroup", {})
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = filetype,
			callback = callback,
			group = group,
		})
	end
end
-- }}}

require("lazy").setup({
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	{
        "mfussenegger/nvim-dap",
        config = function()

        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require("dapui").setup()
        end
    },

    {
        "f-person/git-blame.nvim",
        config = function()
            require("gitblame").setup({
                enabled = false
            })
        end
    },

	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/vim-vsnip",

	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"nvim-treesitter/playground",

	"tpope/vim-surround",
	"tpope/vim-endwise",
	"tpope/vim-repeat",
	"tpope/vim-fugitive",
	"tpope/vim-abolish",
	"tpope/vim-unimpaired",
	"tpope/vim-dispatch",
	"tpope/vim-vinegar",
	"tpope/vim-projectionist",
	"tpope/vim-commentary",
	"ntpeters/vim-better-whitespace", -- highlight trailing whitespace
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			disable_filetype = { "TelescopePrompt", "vim", "clojure" },
		}, -- this is equalent to setup({}) function
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{ "kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

	-- Java support
	{ "mfussenegger/nvim-jdtls" },

	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",

	{
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup({
				input = { enabled = false },
				select = {
					enabled = true,
					backend = { "telescope" },
				},
			})
		end,
	},

	{
		"miikanissi/modus-themes.nvim",
		config = function()
            require("modus-themes").setup {
                style = "auto",
                -- variant = "tinted",
                -- variant = "deuteranopia",
            }
            vim.o.background = "dark"
			vim.cmd("colorscheme modus")
		end,
	},

    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = false,
                    component_separators = { left = ' ', right = ' '},
                    section_separators = { left = ' ', right = ' '},
                }
            }
        end
    },
})

-- Vim options {{{
vim.o.termguicolors = true

vim.o.exrc = true
vim.o.showcmd = true
vim.o.mouse = "a"

vim.o.scrolloff = 5
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect"

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.expandtab = true

vim.o.wrap = true
vim.o.wildignore = vim.o.wildignore
	.. "*.so,*.swp,*.zip,*.o,*.png,*.jpg,*.jpeg,*/target/*,*/build/*,*/node_modules/*,tags,*.glb,*.gltf,*.hdr"
vim.o.hidden = true
vim.o.showmode = false
vim.o.modeline = true
vim.o.modelines = 1

vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("data") .. "/undodir"

vim.o.linebreak = true

vim.o.showbreak = ">   "
vim.o.shortmess = vim.o.shortmess .. "c"

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cinoptions = vim.o.cinoptions .. "L0"
vim.o.cinoptions = vim.o.cinoptions .. "l1"

vim.o.pumheight = 8 -- Completion menu height
vim.o.signcolumn = "yes:1" -- Configure minimum gutter width

vim.wo.number = false
-- vim.wo.cursorline = true
-- vim.wo.foldmethod = 'marker'
-- vim.wo.foldlevel = 0
-- }}}

-- Keybinds {{{
vim.g.mapleader = " "

vim.keymap.set("n", "<C-a>", ":A<CR>", { silent = true })
vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<C-b>", ":Telescope buffers<CR>", { silent = true })
vim.keymap.set("n", "<Leader>fg", ":Telescope live_grep<CR>", { silent = true })
vim.keymap.set("n", "<Leader>fv", vim.cmd.Ex, { silent = true })

vim.keymap.set("n", "<C-j>", "<C-w>w", { remap = false })
vim.keymap.set("n", "<C-k>", "<C-w>W", { remap = false })

vim.keymap.set("n", "<C-e>", ":CNext<CR>", { silent = true })
vim.keymap.set("n", "<C-q>", ":CPrev<CR>", { silent = true })

-- Continuous indentation shift
vim.keymap.set("v", "<", "<gv", { remap = false })
vim.keymap.set("v", ">", ">gv", { remap = false })
vim.keymap.set("v", "<s-lt>", "<gv", { remap = false })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { remap = false })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { remap = false })

vim.keymap.set("n", "n", "nzzzv", { remap = false })
vim.keymap.set("n", "N", "Nzzzv", { remap = false })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { remap = false })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { remap = false })

vim.keymap.set("n", "J", "mzJ`z", { remap = false })

vim.keymap.set("n", "<Leader>fed", ":e " .. vim.fn.stdpath("config") .. "/init.lua<CR>", { silent = true })

vim.keymap.set("n", "<Leader>w/", ":vsp<CR>", { silent = true })
vim.keymap.set("n", "<Leader>w-", ":sp<CR>", { silent = true })
vim.keymap.set("n", "<Leader>wd", ":q<CR>", { silent = true })
vim.keymap.set("n", "<Leader>wb", "<C-w>=", { silent = true })

vim.keymap.set("n", "<Leader>bd", ":bd<CR>", { silent = true })
vim.keymap.set("n", "<Leader>bcc", ":%bd|e#<CR>", { silent = true })

vim.keymap.set("n", "<Leader>gs", ":LazyGitCurrentFile<CR>", { silent = true })
vim.keymap.set("n", "<Leader>gb", ":GitBlameToggle<CR>", { silent = true })

vim.keymap.set("n", "<A-p>", "<nop>", { silent = true })

vim.keymap.set("n", "<f7>", ":Make<CR>", { silent = true })
vim.keymap.set("n", "<Leader>mb", ":Make<CR>", { silent = true })
vim.keymap.set("n", "<A-r>", ":Make<CR>", { silent = true })

vim.keymap.set("n", "<Leader>tt", ":TestSuite<CR>", { silent = true })
vim.keymap.set("n", "<Leader>tf", ":TestFile<CR>", { silent = true })

vim.keymap.set("n", "<Leader>dd", require("dapui").toggle, { silent = true })
vim.keymap.set("n", "<Leader>db", require("dap").toggle_breakpoint, { silent = true })
vim.keymap.set("n", "<Leader>dc", require("dap").continue, { silent = true })
vim.keymap.set("n", "<Leader>dn", require("dap").step_over, { silent = true })
vim.keymap.set("n", "<Leader>dt", require("jdtls").test_nearest_method, { silent = true })
vim.keymap.set("n", "<Leader>du", ":JdtUpdateDebugConfig<CR>", { silent = true })

vim.keymap.set("n", "<Leader>en", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, wrap = false })
end, { silent = true })
vim.keymap.set("n", "<Leader>ep", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, wrap = false })
end, { silent = true })

-- Disable ex mode binding
vim.cmd([[map Q <Nop>]])
-- }}}

-- Telescope {{{
local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		preview = true,
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
})
-- }}}

-- LSP {{{
vim.diagnostic.config({
	virtual_text = false,
	signs = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require("lspconfig")
local lsp_configs = require("lspconfig.configs")

local function format_buffer(bufnr)
	local bufnr = bufnr or 0
	vim.lsp.buf.format({
		async = true,
		filter = function(client)
			if #vim.lsp.get_active_clients({ bufnr = bufnr, name = "null-ls" }) >= 1 then
				-- If null-ls is active, don't format with other clients
				return client.name == "null-ls"
			end
			return true
		end,
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

		local opts = { remap = false, silent = true, buffer = ev.bufnr }

		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<c-]>", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "<leader>mf", format_buffer, opts)
		vim.keymap.set("n", "<leader>mr", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("n", "<leader>mR", ":LspRestart<CR>", opts)
		vim.keymap.set("n", "<M-CR>", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("i", "<M-CR>", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>mc", ":Copilot toggle<CR>", opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_prev()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "<C-y>", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)

		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- Disable semantic highlighting
		client.server_capabilities.semanticTokensProvider = nil
	end,
})
-- }}}

-- Nvim-cmp {{{
local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" },
	}),
})
-- }}}

-- Small quality of life stuff {{{

-- Remap :W to :w
vim.cmd([[
	cnoreabbrev W w
	cnoreabbrev Q q
	cnoreabbrev Wq wq
	cnoreabbrev WQ wq
]])

-- Clear highlights with escape
vim.cmd([[
	nnoremap <silent> <esc> :noh<return><esc>
]])

-- Create non-existing directories before writing buffer
vim.cmd([[
    function! Mkdir()
        let dir = expand('%:p:h')

        if !isdirectory(dir)
            call mkdir(dir, 'p')
            echo 'Created non-existing directory: '.dir
        endif
    endfunction

    augroup on_buffer_write
        autocmd BufWritePre * call Mkdir()
    augroup END
]])

-- Open help vertically
vim.cmd([[
    autocmd FileType help wincmd L
    autocmd FileType man wincmd L
]])

--  Fix false positive C bracket error
vim.cmd([[
    let c_no_bracket_error=1
    let c_no_curly_error=1
]])

-- Quickfix helpers
vim.cmd([[
    command! CNext try | cnext | catch | clast | catch | endtry
    command! CPrev try | cprev | catch | cfirst | catch | endtry
]])
-- }}}

-- Indentation {{{
vim.cmd([[
    autocmd FileType lua setlocal shiftwidth=4 tabstop=4 expandtab
    autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 expandtab
    autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 expandtab
    autocmd FileType typescriptreact setlocal shiftwidth=2 tabstop=2 expandtab
    autocmd FileType html setlocal shiftwidth=2 tabstop=2 expandtab
    autocmd FileType sql setlocal shiftwidth=4 tabstop=4 expandtab
    autocmd FileType java setlocal shiftwidth=4 tabstop=4 expandtab
]])
-- }}}

-- Treesitter {{{
require("nvim-treesitter.configs").setup({
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	ensure_installed = {
		"bash",
		"css",
		"html",
		"http",
		"java",
		"lua",
		"make",
		"markdown",
		"tsx",
		"typescript",
		"yaml",
	},
	-- ignore_install = { "javascript" }, -- List of parsers to ignore installing

	highlight = {
		enable = true, -- false will disable the whole extension
		disable = {
			-- "cpp",
		},
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		disable = {
			"c",
			"cpp",
			"sql",
			-- "html",
			-- "htmldjango",
		},
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<A-n>", -- set to `false` to disable one of the mappings
			node_incremental = "<A-n>",
			-- scope_incremental = "grc",
			node_decremental = "<A-p>",
		},
	},
})
-- }}}

-- Other filetypes {{{
vim.cmd([[
autocmd BufRead,BufNewFile Dockerfile.* set filetype=dockerfile
]])
-- }}}
