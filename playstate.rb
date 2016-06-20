require_relative 'board'
require_relative 'module'
require_relative 'command'

class PlayState < GameState

  def initialize
    @background   = Gosu::Color.new(0xffbbf6e2)
    @free         = 0xffb6e3f0
    @font         = Gosu::Font.new($window, Gosu::default_font_name, 20)
    @colors_array = [ 0xff75cae3,
                      0xff238dac,
                      0xff124a5a,
                      0xff0c2f3a,
                      0xff91f22e,
                      0xff2df22c,
                      0xff0dc30c,
                      0xff087a07,
                      0xffe0c613,
                      0xff74660a,
                      0xffef19f1,
                      0xff780779,
                      0xff1d021d,
                      0xff1d021d,
                      0xff1d021d,
                      0xff1d021d ]

    @column_w     = 100
    @row_h        = 100
    @board        = Board.new()
    @timer      ||= 0
    @pause        = false
  end

  def draw
    $window.draw_quad(0,             0,              @background,
                      $window.width, 0,              @background,
                      $window.width, $window.height, @background,
                      0,             $window.height, @background)

    for_display_cells(@board.grid)
    @font.draw("Score: #{@board.score}", 10, 10, 1, 1.0, 1.0, 0xff7b1934)
    @font.draw("Time: #{@timer/60}", 300, 10, 1, 1.0, 1.0, 0xff7b1934)

    display_victory(@board.victory?) if @board.victory? && !@board.is_victory
    display_lose(@board.lose?) if @board.lose?
  end

  def update
    @timer += 1 unless @pause
  end


  def for_display_cells(lines)
    counter_line = 0
    while counter_line < 4
      counter = 0
      while counter < 4
        16.times do |degree|
          if lines[counter_line][counter] == 2**(degree + 1)
            draw_cell(Gosu::Color.new(@colors_array[degree]), counter_line, counter)
          end
        end
        draw_cell(@free, counter_line, counter) unless lines[counter_line][counter]
        counter += 1
      end
      counter_line += 1
    end
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      GameState.switch(MenuState.instance)
    when Gosu::KbLeft
      doMove Left
    when Gosu::KbRight
      doMove Right
    when Gosu::KbUp
      doMove Up
    when Gosu::KbDown
      doMove Down
    when Gosu::KbSpace
      unless @board.is_victory
        @board.is_victory = true
        @pause = false
      end
    end
  end

  def display_victory(win)
    @pause = true
    $window.draw_quad(40,  50,  0xff4d9900,
                      340, 50,  0xff4d9900,
                      340, 280, 0xff73e600,
                      40,  280, 0xff73e600, 2)
    @font.draw("Congratulations!", 53, 80, 2, 2.0, 2.0, 0xffd9ffb3)
    @font.draw("You've managed to reach the goal", 50, 130, 2, 1.0, 1.0, 0xffd9ffb3)
    @font.draw("Time taken #{Time.at(@timer/60).utc.strftime("%k:%M:%S")}", 108, 160, 2, 1.0, 1.0, 0xffd9ffb3)
    @font.draw("Press 'Space' to proceed", 87, 250, 2, 1.0, 1.0, 0xff408000)
  end

  def display_lose(lose)
    @pause = true
    $window.draw_quad(40,  50,  0xff1f1f14,
                      340, 50,  0xff1f1f14,
                      340, 340, 0xff3e3e28,
                      40,  340, 0xff3e3e28, 2)
    @font.draw("WASTED", 80, 90, 2, 3.0, 3.0, 0xffcdcdb1)
    @font.draw("Your score is #{@board.score}", 80, 170, 2, 1.3, 1.3, 0xffe1e1d0)
    @font.draw("Time spent #{Time.at(@timer/60).utc.strftime("%k:%M:%S")}", 80, 200, 2, 1.3, 1.3, 0xffe1e1d0)
    @font.draw("Press 'Escape' to exit to the Main Menu", 60, 320, 2, 0.8, 0.8, 0xff6d6d46)
  end

  def draw_cell(color, counter_line, counter)
    $window.draw_quad(counter * @column_w + 4,   counter_line * @row_h + 30,          color,
                     (counter + 1) * @column_w,  counter_line * @row_h + 30,          color,
                     (counter + 1) * @column_w, (counter_line + 1) * @row_h - 4 + 30, color,
                     counter * @column_w + 4,   (counter_line + 1) * @row_h - 4 + 30, color)
    @font.draw(" #{@board.grid[counter_line][counter]}", counter * (@column_w + 1) + (90 - @board.grid[counter_line][counter].to_s.size * 22)/2, counter_line * @row_h + 60, 1, 2.0, 2.0, 0xffffff00)
  end

  def doMove(command)
    command.new(@board).execute
  end

  def needs_redraw?
    true
  end

end
