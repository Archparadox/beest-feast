require 'singleton'

class MenuState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @message = Gosu::Image.from_text(
      $window, "2 0 4 8",
      Gosu.default_font_name, 55)

    @background = []
    8.times do |i|
      arr = Array.new(10) {rand(0..9)}
      if i == 1
        arr[3..6] = 2, 0, 4, 8
      end
      arr = arr.join(" ")
      @background << arr
    end
    @background = Gosu::Image.from_text(
      $window, @background.join("\n"),
      Gosu.default_font_name, 55)
  end

  def update
    continue_text = @play_state ? "C - Continue" : ""
    @info = Gosu::Image.from_text(
      $window, "Controls:
                \n#{continue_text}
                \nSpace - New Game
                \nEsc - Exit to Menu
                \nQ - Quit Game from Menu",
      Gosu.default_font_name, 20, - 7, 200, :left)
  end

  def draw
    @background.draw(11, -7, 10, 1, 1, 0xff_222211)
    @message.draw(
      $window.width / 2 - @message.width / 2,
      $window.height / 2 - @message.height / 2 - 140,
      10)
    @info.draw(
      $window.width / 2 - @info.width / 2 - 90,
      $window.height / 2 - @info.height / 2 + 120,
      10)
  end

  def button_down(id)
    case id
    when Gosu::KbQ
      $window.close
    when Gosu::KbSpace
      @play_state = PlayState.new
      GameState.switch(@play_state)
    when Gosu::KbC
      GameState.switch(@play_state) if @play_state
    end
  end
end
