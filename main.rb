require 'gosu'

require_relative 'classes/window'
require_relative 'classes/gamestate'
require_relative 'classes/menustate'
require_relative 'classes/playstate'

$window = GameWindow.new
GameState.switch(MenuState.instance)
$window.show
