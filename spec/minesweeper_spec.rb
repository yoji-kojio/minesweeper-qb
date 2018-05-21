require_relative 'spec_helper.rb'

describe '#Inicialização do jogo' do
  before :each do
    @game = Minesweeper.new(10, 15, 20)
  end
  context 'Verifica se o jogo' do
    it 'foi instanciado' do
      expect(@game).to be_an_instance_of(Minesweeper)
    end
    it 'inicializou n_bombs' do
      expect(@game.n_bombs).to eql(20)
    end
    it 'inicializou row' do
      expect(@game.row).to eql(10)
    end
    it 'inicializou col' do
      expect(@game.col).to eql(15)
    end
    it 'inicializou left_cells' do
      expect(@game.left_cells).to eql(130)
    end
    it 'inicializou game_over' do
      expect(@game.game_over).to be false
    end
  end
end

describe "#Create table" do
  before :each do
    @game = Minesweeper.new(10, 10, 20)
  end
  it 'Criou matriz corretamente' do
    expect(@game.create_table).to be_an_instance_of(Matrix)
    expect(@game.create_table.first).to be_an_instance_of(Cell)
  end
  it 'Bombas/Left cells' do
    @game.set_bombs
    expect(@game.left_cells).to eql(80)
  end
end

describe '#Play test' do
  before :each do
    @game = Minesweeper.new(10, 15, 20)
  end
  context 'Testar jogada' do
    it 'válida' do
      @game.table[1, 1].discovered = false
      expect(@game.play(1, 1)).to be true
    end
    it 'fora do campo' do
      expect(@game.play(-1, 1)).to_not be true
    end
    it 'em celula descoberta' do
      @game.table[1, 1].discovered = true
      expect(@game.play(1, 1)).to_not be true
    end
    it 'em celula com bandeira' do
      @game.table[1, 1].flagged = true
      expect(@game.play(1, 1)).to_not be true
    end
  end
end

describe '#Flag test' do
  before :each do
    @game = Minesweeper.new(10, 10, 15)
  end
  context 'Testar flag' do
    it 'valido' do
      expect(@game.flag(1, 1)).to be true
    end
    it 'fora do campo' do
      expect(@game.flag(-1, 1)).to_not be true
    end
    it 'celula descoberta' do
      @game.table[1, 1].discovered = true
      expect(@game.flag(1, 1)).to_not be true
    end
    it 'celula com flag' do
      @game.table[1, 1].flagged = true
      expect(@game.flag(1, 1)).to be true
    end
  end
end

describe '#Game conditions' do
  before :each do
    @game = Minesweeper.new(10, 10, 15)
  end
  context 'Testar se o jogo' do
    it 'Still playing? yes' do
      @game.game_over = true
      expect(@game.still_playing?).to be false
    end
    it 'Still playing? no' do
      @game.game_over = false
      expect(@game.still_playing?).to be true
    end
    it 'Victory? yes' do
      @game.left_cells = 0
      expect(@game.victory?).to be true
    end
    it 'Victory? no' do
      @game.left_cells = 10
      expect(@game.victory?).to be false
    end
  end
end

describe '#Game state' do
  before :each do
    @game = Minesweeper.new(10, 10, 15)
    @cell = Cell.new(9, 9)
  end
  it 'Board state' do
    expect(@game.board_state).to be_an_instance_of(Matrix)
  end
  it 'Map game state (flagged)' do
    @cell.flagged = true
    expect(@game.map_game_state(@cell)).to eql('F'.colorize(:yellow))
  end
  it 'Map game state (undiscovered)' do
    @cell.discovered = false
    expect(@game.map_game_state(@cell)).to eql('#')
  end
  it 'Map game state (bomb)' do
    @cell.is_bomb = true
    @cell.discovered = true
    expect(@game.map_game_state(@cell)).to eql('B'.colorize(:red))
  end
end
