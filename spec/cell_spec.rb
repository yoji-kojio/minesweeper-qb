require_relative 'spec_helper.rb'

describe 'Nova célula' do
  before :each do
    @cell = Cell.new(10, 15)
  end
  context 'Verificar consistencia das informações' do
    it 'retorna mesma linha' do
      expect(@cell.row).to eql(10)
    end
    it 'retorna mesma coluna' do
      expect(@cell.col).to eql(15)
    end
    it 'retorna discovered false' do
      expect(@cell.discovered).to be false
    end
    it 'retorna flagged false' do
      expect(@cell.flagged).to be false
    end
    it 'retorna neighbor_bombs' do
      expect(@cell.neighbor_bombs).to eql(0)
    end
    it 'retorna is_bomb false' do
      expect(@cell.is_bomb).to be false
    end
  end
end
