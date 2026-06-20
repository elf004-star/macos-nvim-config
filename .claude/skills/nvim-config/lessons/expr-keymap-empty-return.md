# `expr = true` 返回空字符串丢失默认行为

**涉及文件**：`lua/config/keymaps.lua`

## 问题

`expr = true` 的 keymap 如果返回 `""`，Neovim 会消费该按键且**不执行任何操作**，包括按键原本的默认行为。

例如 `<C-j>` 的默认行为是插入换行，但 `jump_out` 返回 `""` 后连换行也失效了。

## 原理

`expr` mapping 返回空字符串 ≠ "透传"，而是"消费掉但不做任何事"。

## 解决方案

需要保留默认行为时，返回 `vim.v.key`：

```lua
return vim.v.key  -- 回退到按键的默认行为
```

## 调试技巧

可以临时 return 一个可见字符（如 `"x"`）来确认 mapping 确实被触发了。
