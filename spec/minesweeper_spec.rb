require_relative 'spec_helper.rb'

describe '#Inicialização do jogo' do
  before :each do
    @game = Minesweeper.new(10, 15, 20)
  end
  context 'Consistencia dos dados' do
    it 'instanciado' do
      expect(@game).to be_an_instance_of(Minesweeper)
    end
    it 'n_bombs inicializado' do
      expect(@game.n_bombs).to eql(20)
    end
    it 'row inicializado' do
      expect(@game.row).to eql(10)
    end
    it 'col inicializado' do
      expect(@game.col).to eql(15)
    end
    it 'left_cells inicializado' do
      expect(@game.left_cells).to eql(130)
    end
    it 'game_over inicializado' do
      expect(@game.game_over).to be false
    end
  end
end

describe "#Create table" do
  before :each do
    @game = Minesweeper.new(10, 10, 20)
  end
  it 'table created' do
    expect(@game.create_table).to be_an_instance_of(Matrix)
    expect(@game.create_table.first).to be_an_instance_of(Cell)
  end
  it 'bombs seted' do
    @game.set_bombs
    expect(@game.left_cells).to eql(80)
  end
end

describe '#Play test' do
  before :each do
    @game = Minesweeper.new(10, 15, 20)
  end
  context 'Testar play valido e invalido' do
    it 'play valido' do
      @game.table[1, 1].discovered = false
      expect(@game.play(1, 1)).to be true
    end
    it 'play fora do campo' do
      expect(@game.play(-1, 1)).to_not be true
    end
    it 'play em celula descoberta' do
      @game.table[1, 1].discovered = true
      expect(@game.play(1, 1)).to_not be true
    end
    it 'play em celula com bandeira' do
      @game.table[1, 1].flagged = true
      expect(@game.play(1, 1)).to_not be true
    end
  end
end

describe '#Flag test' do
  before :each do
    @game = Minesweeper.new(10, 10, 15)
  end
  context 'Testar flag valido e invalido' do
    it 'flag valido' do
      expect(@game.flag(1, 1)).to be true
    end
    it 'flag fora do campo' do
      expect(@game.flag(-1, 1)).to_not be true
    end
    it 'flag em celula descoberta' do
      @game.table[1, 1].discovered = true
      expect(@game.flag(1, 1)).to_not be true
    end
    it 'flag em celula com flag' do
      @game.table[1, 1].flagged = true
      expect(@game.flag(1, 1)).to be true
    end
  end
end

describe '#Game conditions' do
  before :each do
    @game = Minesweeper.new(10, 10, 15)
  end
  context 'Testar condições do jogo' do
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
