class Move
  include AddNumber
	attr_accessor :lines
	def initialize(object)
		@lines = object.grid
    @object = object
	end
  def execute
    lines_check = @lines.flatten
    lines.each do |line|
      move(line)
    end
    add_number(@lines) if lines_check != @lines.flatten
  end

	private

  def move(line)
    counter = 0

    line.compact!
    while counter < 3
      if !line[counter].nil? && line[counter] == line[counter+1]
        merge(line, counter)
      end
      counter += 1
    end
    (4 - line.size).times { line << nil }
    line
  end

  def merge(line, index)
    line[index] *= 2
    @object.score += line[index]
    line.delete_at(index+1)
  end
end

class Left < Move
end

class Right < Move
	def execute
		@lines.each { |line| line.reverse!}
    super
    @lines.each { |line| line.reverse!}
	end
end

class Up < Move
	def execute
    @lines = @lines.transpose
		super
    @object.grid = @lines.transpose
	end
end

class Down < Move
  def execute()
    @lines = @lines.transpose
    @lines.each { |line| line.reverse!}
    super
    @lines.each { |line| line.reverse!}
    @object.grid = @lines.transpose
  end
end
