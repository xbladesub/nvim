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

local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.sourcekit = {
  default_config = {
    cmd = { 'xcrun', 'sourcekit-lsp' },
    filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objective-cpp' },
    root_dir = util.root_pattern('Package.swift', '.git'),
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/apple/sourcekit-lsp/main/Editors/vscode/package.json',
    description = [[
https://github.com/apple/sourcekit-lsp
Language server for Swift and C/C++/Objective-C.
    ]],
    default_config = {
      root_dir = [[root_pattern("Package.swift", ".git")]],
    },
  },
}

