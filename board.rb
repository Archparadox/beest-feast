require_relative 'module'

class Board
  include AddNumber
	attr_accessor :rows, :columns, :grid, :score, :is_victory
	def initialize(rows = 4, columns = 4)
		@rows = rows
		@columns = columns
		@score = 0
    @is_victory = false
		@grid = Array.new(rows) do |row|
							Array.new(columns) do |column|
								column = nil
		 					end
		 				end
    2.times { add_number(@grid) }
	end

  def victory?
    true if @grid.flatten.include?(2048)
  end

  def lose?
    arr = @grid.flatten.select {|value| value.nil?}
    if arr.empty?
      add_counter = 0
      add_counter = check_shift(@grid, add_counter)
      add_counter = check_shift(@grid.transpose, add_counter)
      if add_counter == 0
        @is_victory = true
        true
      end
    end
  end

  # private
  def check_shift(lines, add_counter)
    lines.each { |line|
      counter = 0
      while counter < 3
         if line[counter] !=nil && line[counter] == line[counter + 1]
           add_counter += 1
         end
        counter += 1
      end
    }
    add_counter
  end
end