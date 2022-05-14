local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")

if not status_ok then
	return
end

local lspconfig = require("lspconfig")

local servers = { "jsonls", "sumneko_lua", "sourcekit" }

lsp_installer.setup {
	ensure_installed = servers
}

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
	end
	lspconfig[server].setup(opts)
end

local wilder = require('wilder')
wilder.setup({ modes = { ':', '/', '?' } })

-- wilder.set_option('pipeline', {
--   wilder.branch(
--     wilder.cmdline_pipeline({
--       -- sets the language to use, 'vim' and 'python' are su:pported
--       language = 'python',
--       -- 0 turns off fuzzy matching
--       -- 1 turns on fuzzy matching
--       -- 2 partial fuzzy matching (match does not have to begin with the same first letter)
--       fuzzy = 1,
--     }),
--     wilder.python_search_pipeline({
--       -- can be set to wilder#python_fuzzy_delimiter_pattern() for stricter fuzzy matching
--       pattern = wilder.python_fuzzy_pattern(),
--       -- omit to get results in the order they appear in the buffer
--       sorter = wilder.python_difflib_sorter(),
--       -- can be set to 're2' for performance, requires pyre2 to be installed
--       -- see :h wilder#python_search() for more details
--       engine = 're',
--     })
--   ),
-- })
-- wilder.set_option('pipeline', {
--   wilder.branch(
--     wilder.python_file_finder_pipeline({
--       -- to use ripgrep : {'rg', '--files'}
--       -- to use fd      : {'fd', '-tf'}
--       file_command = { 'find', '.', '-type', 'f', '-printf', '%P\n' },
--       -- to use fd      : {'fd', '-td'}
--       dir_command = { 'find', '.', '-type', 'd', '-printf', '%P\n' },
--       -- use {'cpsm_filter'} for performance, requires cpsm vim plugin
--       -- found at https://github.com/nixprime/cpsm
--       filters = { 'fuzzy_filter', 'difflib_sorter' },
--     }),
--     wilder.cmdline_pipeline(),
--     wilder.python_search_pipeline()
--   ),
-- })

-- wilder.set_option('renderer', wilder.wildmenu_renderer({
--   highlighter = wilder.basic_highlighter(),
--   separator = ' · ',
--   left = { ' ', wilder.wildmenu_spinner(), ' ' },
--   right = { ' ', wilder.wildmenu_index() },
-- }))
wilder.set_option('renderer', wilder.popupmenu_renderer({
  -- highlighter applies highlighting to the candidates
  highlighter = wilder.basic_highlighter(),
  pumblend = 20,
  min_width = '20%', -- minimum height of the popupmenu, can also be a number
  min_height = '20%', -- to set a fixed height, set max_height to the same value
  max_height = '20%',
  reverse = 0, 
  left = {' ', wilder.popupmenu_devicons()},
  right = {' ', wilder.popupmenu_scrollbar()},
}))