def chinese_reminder_theorem(mods, reminders)
  product = mods.inject(:*)
  result = mods.each_with_index.reduce(0) do |sum, (mod_i, index)|
    product_i = product / mod_i
    sum + remainders[index] * product_i * mod_inverse(product_i, mod_i)
  end
end
