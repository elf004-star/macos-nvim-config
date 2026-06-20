# jump_out 函数 off-by-one 索引错误

**涉及文件**：`lua/config/keymaps.lua`

## 问题

`nvim_win_get_cursor(0)[2]` 返回 0-based 列号，但 Lua `string.sub()` 是 1-based。最初代码用了 `col + 2`，导致跳过一个字符，`jump_out` 几乎永远找不到右括号。

## 修复

```diff
- local next = line:sub(col + 2, col + 2)
+ local next = line:sub(col + 1, col + 1)
```

## 影响

`<C-j>` 和 `<C-]>` 在 insert mode 下完全无反应。`expr = true` 返回 `""` 消费了按键但不执行任何操作，用户误以为 keymap 没生效。

## 教训

涉及光标位置和 Lua 字符串索引时，Neovim 列号是 0-based，Lua string index 是 1-based，转换公式始终是 `col + 1`。
