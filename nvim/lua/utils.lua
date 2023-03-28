function map(modes, lhs, rhs)
  vim.keymap.set(modes, lhs, rhs, {
    noremap = true,
    silent = true,
  })
end

function remap(modes, lhs, rhs)
  vim.keymap.set(modes, lhs, rhs, {
    silent = true,
  })
end
