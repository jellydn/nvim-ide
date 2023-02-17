local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct

-- Install your plugins here
require("lazy").setup {
  -- My plugins here
  -- library used by other plugins
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = function()
      require "user.autopairs"
    end,
  }, -- Autopairs, integrates with both cmp and treesitter
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require "user.comment"
    end,
  },
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  { "kyazdani42/nvim-web-devicons", lazy = true },
  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      { "<leader>fe", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
      { "<leader>e", "<leader>fe", desc = "Explorer NvimTree", remap = true },
    },
    config = function()
      require "user.nvim-tree"
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = function()
      require "user.bufferline"
    end,
  },
  { "moll/vim-bbye" },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require "user.lualine"
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
      require "user.toggleterm"
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require "user.project"
    end,
  },
  {
    "lewis6991/impatient.nvim",
    config = function()
      require "user.impatient"
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    config = function()
      require "user.indentline"
    end,
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      require "user.alpha"
    end,
  },

  -- Colorschemes
  {
    "folke/tokyonight.nvim",
    config = function()
      require "user.colorscheme"
    end,
  },

  -- cmp plugins
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      { "hrsh7th/cmp-buffer" }, -- buffer completions
      { "hrsh7th/cmp-path" }, -- path completions
      { "hrsh7th/cmp-nvim-lsp" },
      { "saadparwaiz1/cmp_luasnip", ft = "lua" },
      { "tzachar/cmp-tabnine", build = "./install.sh" },
    },
    config = function()
      require "user.cmp"
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        return
      end
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})
    end,
  }, -- The completion plugin

  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPost",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      -- for formatters and linters
      { "jose-elias-alvarez/null-ls.nvim" },
      { "lukas-reineke/lsp-format.nvim" },
      {
        "glepnir/lspsaga.nvim",
        config = function()
          require("lspsaga").setup {}
        end,
      },
    },
    config = function()
      require "user.lsp"
    end,
  },

  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    config = function()
      require "user.illuminate"
    end,
  },

  -- copilot
  {
    "github/copilot.vim",
    event = "VeryLazy",
    config = function()
      require "user.copilot"
    end,
  },

  -- which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup {}
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    config = function()
      require "user.telescope"
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = "BufReadPost",
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Schrink selection", mode = "x" },
    },
    config = function()
      require "user.treesitter"
    end,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require "user.gitsigns"
    end,
  },

  -- DAP
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      { "rcarriga/nvim-dap-ui" },
      { "ravenxrz/DAPInstall.nvim" },
    },
    config = function()
      require "user.dap"
    end,
  },

  -- Rust
  {
    "simrat39/rust-tools.nvim",
    -- lazy-load on filetype
    ft = "rust",
    config = function()
      local rt = require "rust-tools"
      rt.setup {
        server = {
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      }
    end,
  },

  -- Go
  {
    "crispgm/nvim-go",
    ft = "go",
    config = function()
      require("go").config.update_tool("quicktype", function(tool)
        tool.pkg_mgr = "yarn"
      end)
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    event = "BufReadPost",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  -- Outline
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    config = function()
      require "user.aerial"
    end,
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },
}

require "config.options"

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
