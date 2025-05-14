-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugins.plugin")
require("neotree.neotree")
require("config.keymaps")
require("plugins.mason-workaround")

-- which-key.nvim の設定
local wk = require("which-key")
wk.add({
  {
    "<leader>cp",
    function()
      local current_buffer_full_path = vim.fn.expand("%:p")
      vim.fn.setreg("+", current_buffer_full_path)
      print("Copied buffer path: " .. current_buffer_full_path)
    end,
    desc = "Copy Buffer Path",
  },
})
wk.add(
  {
    {
      "<leader>cP",
      function()
        local current_buffer_full_path = vim.fn.expand("%:p")
        local app_subpath_start = string.find(current_buffer_full_path, "/app/")

        if app_subpath_start then
          -- 'app/' 以降のパスを抽出し、'app/' 自体は含めない
          local app_subpath = string.sub(current_buffer_full_path, app_subpath_start + 1)
          -- 'page.tsx' やファイル名自体をパスの終わりから除外
          local import_path = string.gsub(app_subpath, "%.tsx$", "")
          import_path = string.gsub(import_path, "%.jsx$", "")
          import_path = string.gsub(import_path, "%.js$", "")
          import_path = string.gsub(import_path, "%.ts$", "")
          -- コンポーネント名をファイル名から推測
          local component_name = import_path:match("([^/]+)$")
          -- `@/` プレフィックスを付けてインポート文を生成
          local import_statement = "import " .. component_name .. ' from "@/' .. import_path .. '"'
          -- インポート文をクリップボードにコピー
          vim.fn.setreg("+", import_statement)
          print("Copied import statement: " .. import_statement)
        else
          print("No 'app/' subpath found in the current buffer path")
        end
      end,
      desc = "@以下のimport文コピー,nextjs用のimport文を作る",
    },
  }
  -- # @以下のimport文コピー
)

require("lspconfig").marksman.setup({
  -- 他の設定...
  autostart = false,
})
require("lspconfig").html.setup({})

-- @でimportできるようにしたい
require("lspconfig").tsserver.setup({
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "non-relative",
      importModuleSpecifierEnding = "minimal",
    },
  },
})
-- swp スワップファイルを無効にしたい
vim.opt.swapfile = false
vim.lsp.set_log_level("warn")
-- 環境変数の追加
-- 環境変数を設定
vim.env.MY_VAR = "TestValue"
-- c++のフォーマット clang-format
local function preserve_cursor()
  local cursor = vim.fn.winsaveview()
  vim.cmd("%!clang-format")
  vim.fn.winrestview(cursor)
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.cpp", "*.hpp", "*.c", "*.h" },
  callback = preserve_cursor,
})

wk.register({
  ["<leader>MT"] = {
    function()
      vim.api.nvim_put({ vim.fn.strftime("%s") }, "c", true, true)
    end,
    "1970年からのタイムを取得",
  },
})
-- :terminalでnormalモードへ移行
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

-- docker からclipboardを共有
vim.g.clipboard = {
  name = "osc52-copy-only",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    -- ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    -- ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    ["+"] = function()
      return ""
    end,
    ["*"] = function()
      return ""
    end,
  },
}

-- fishの場合
-- init.lua（または lazyvim の場合は lua/config/options.lua など）に追加
vim.opt.shell = "/usr/bin/fish"
