require_relative 'spec_helper.rb'

describe '#Nova célula' do
  before :each do
    @cell = Cell.new(10, 15)
    @game = Minesweeper.new(10, 15, 20)
  end
  context 'Verificar se a célula' do
    it 'foi instanciada' do
      expect(@cell).to be_an_instance_of(Cell)
    end
    it 'inicializou linha' do
      expect(@cell.row).to eql(10)
    end
    it 'inicializou coluna' do
      expect(@cell.col).to eql(15)
    end
    it 'inicializou discovered' do
      expect(@cell.discovered).to be false
    end
    it 'inicializou flagged' do
      expect(@cell.flagged).to be false
    end
    it 'inicializou neighbor_bombs' do
      expect(@cell.neighbor_bombs).to eql(0)
    end
    it 'inicializou is_bomb' do
      expect(@cell.is_bomb).to be false
    end
  end
end

describe '#On Click method' do
  before :each do
    @cell = Cell.new(10, 15)
    @game = Minesweeper.new(10, 15, 20)
    @lc = @game.left_cells
  end
  it 'Clique em bomba' do
    @cell.is_bomb = true
    @cell.onclick_action(@game)
    expect(@game.game_over).to be true
  end
  it 'Clique em não bomba' do
    @cell.is_bomb = false
    @cell.onclick_action(@game)
    expect(@game.game_over).to be false
    expect(@cell.discovered).to be true
    expect(@game.left_cells).to be < @lc
  end
end

describe '#Validar Posição' do
  before :each do
    @cell = Cell.new(10, 15)
    @game = Minesweeper.new(10, 10, 20)
  end
  it 'Célula dentro do tabuleiro (borda)' do
    expect(@cell.validate_position(@game, 1, 1)).to be true
  end
  it 'Célula dentro do tabuleiro (centro)' do
    expect(@cell.validate_position(@game, 5, 5)).to be true
  end
  it 'Célula fora do tabuleiro (x)' do
    expect(@cell.validate_position(@game, -1, 1)).to be false
  end
  it 'Célula fora do tabuleiro (y)' do
    expect(@cell.validate_position(@game, 2, -5)).to be false
  end
end
