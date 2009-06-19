require 'qtutils'
require 'games/chess/chess'
require 'board/board'
require 'board/table'
require 'history'
require 'controller'

class MainWindow < KDE::XmlGuiWindow
  include ActionHandler
  
  Theme = Struct.new(:pieces, :board)
  
  def initialize(loader)
    super nil
    
    @loader = loader
    
    load_board
    
    setup_actions
    setupGUI
  end

private

  def setup_actions
    std_action :open_new do
      puts "new game"
    end
    std_action :quit, :close
  end
  
  def load_board
    game = Game.get(:chess)
    config = KDE::Global.config.group('themes')
    
    theme = Theme.new
    theme.pieces = @loader.get(config.read_entry('piece', 'Celtic'), game)
    theme.board = @loader.get(config.read_entry('board', 'Default'), game)
    
    scene = Qt::GraphicsScene.new
    
    state = game.state.new.tap {|s| s.setup }
    
    board = Board.new(scene, theme, game, state)
    
    table = Table.new(scene, self, board)
    self.central_widget = table

    history = History.new(state)
    controller = Controller.new(board, history)
  end
end