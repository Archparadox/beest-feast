module AddNumber
  def add_number(lines)
    x = rand(4)
    y = rand(4)
    if lines[x][y] == nil
      lines[x][y] = rand > 0.1 ? 2 : 4
    else
      add_number(lines)
    end
  end
end