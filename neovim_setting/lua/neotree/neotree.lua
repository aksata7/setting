function copy_node_in_folder_neotree()
  -- 現在のバッファのフォルダーを取得
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    print("❌ No file in buffer!")
    return nil
  end
  local folder = vim.fn.fnamemodify(bufname, ":h") -- ":h" でフォルダー部分を取得
  --最後のフォルダー名を取得
  local last_folder = vim.fn.fnamemodify(folder, ":t") -- ":t" で最後のフォルダー名を取得
  -- ユーザーに `depth` の入力を求める
  local depth_input = vim.fn.input("Enter depth_ネストの深さ (default: 1): ")
  local user_depth = tonumber(depth_input) or 1 -- 入力が空なら `1`、数値変換できなければ `1`

  -- `plenary.scandir` を使ってフォルダー内のファイルとディレクトリを取得
  local scan = require("plenary.scandir")
  -- 隠しファイル除外
  local files = scan.scan_dir(folder, { hidden = false, depth = user_depth, add_dirs = true }) -- フォルダーも取得

  if not files or #files == 0 then
    print("📂 No files or folders found in " .. folder)
    return
  end

  -- フォルダー名を含めた相対パスを作成
  local relative_paths = {}
  local unique_folders = {}

  for _, file in ipairs(files) do
    local relative_path = file:gsub(vim.pesc(folder .. "/"), "") -- `folder/path` 形式
    table.insert(relative_paths, last_folder .. "/" .. relative_path)

    -- フォルダーの場合は `folder/` の形式で追加（重複防止）
    local parent_folder = relative_path:match("(.*/).*") -- 最上位のフォルダーを取得
    if parent_folder and not unique_folders[parent_folder] then
      table.insert(relative_paths, parent_folder)
      unique_folders[parent_folder] = true
    end
  end
  -- 結果を `yank` してクリップボードにコピー
  local result = table.concat(relative_paths, "\n")
  vim.fn.setreg("+", result) -- `+` レジスタ（クリップボード）にコピー
  print("✅ Copied " .. #relative_paths .. " paths to clipboard!")
  -- 結果を表示（デバッグ用）
  print("📂 Files and folders in folder: " .. folder)
  print(vim.inspect(relative_paths))
end
