local wk = require("which-key")

wk.add({
  { "<leader>Ma", "<cmd>:Neotree filesystem reveal<CR>", desc = "現在のbufferのフォルダー位置を表示" },
  {
    "<leader>MA",
    "<cmd>lua copy_node_in_folder_neotree()<CR>",
    desc = "現在のフォルダーを深さに基づいてpathをコピー",
  },
  {
    "<leader>t",
    group = "Todo",
  },
  -- 現在のbufferのtodolistを見る
  {
    "<leader>tt",
    function()
      local current_file_path = vim.fn.expand("%:p")
      -- TodoTrouble コマンドを実行
      vim.cmd("TodoTrouble cwd=" .. current_file_path)
    end,
    desc = "TodoTrouble for Current Buffer",
  },
  {
    "<leader>M2",
    "viwb<esc>i**<esc>ea**<esc>",
    desc = "単語にダブルクォーテーションを追加",
    mode = "n",
  },

  -- mySnippet.luaから
  { "<leader>MC", group = "カスタムスニペット" },
  -- { "<leader>MCt", ":ToggleYankToMemo<CR>", desc = "yankの保存をon/off" },
  {
    "<leader>MR",
    function()
      vim.cmd("normal! ciw") -- カーソル上の単語を削除
      vim.cmd('normal! "0p') -- yankした内容で置き換え
    end,
    desc = "Replace word with yank",
  },
  { "<leader>Mm", group = "math" },
  -- // vimの置換コマンドを可視化しました
  {
    "<leader>Mr",
    function()
      local search = vim.fn.input("置換したい文字 (検索): ")
      if search == "" then
        return
      end

      local replace = vim.fn.input("置換後の文字: ")

      local escaped_search = vim.fn.escape(search, "/\\")
      local escaped_replace = vim.fn.escape(replace, "\\&")

      local flags = vim.fn.input("フラグ (例:,g=全体, gc=全体確認付き): ")
      if flags == "" then
        flags = "g"
      end

      local cmd = string.format("%%s/%s/%s/%s", escaped_search, escaped_replace, flags)
      vim.cmd(cmd)
    end,
    desc = "置換コマンド :%s",
  },
})
