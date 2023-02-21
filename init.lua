require "config.options"
require "config.lazy"

-- load the autocommands and keymaps only if the user didn't specify any files
if vim.fn.argc(-1) == 0 then
  -- autocmds and keymaps can wait to load
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      require "config.autocommands"
      require "config.keymaps"
    end,
  })
else
  -- load them now so they affect the opened buffers
  require "config.autocommands"
  require "config.keymaps"
end
