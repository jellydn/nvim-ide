local status_ok, aerial = pcall(require, "aerial")
if not status_ok then
  return
end

aerial.setup {

  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
}

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

telescope.load_extension "aerial"
