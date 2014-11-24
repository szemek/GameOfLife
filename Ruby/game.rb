require 'set'

class Game
  attr_accessor :cells

  def initialize(cells = [])
    @cells = Set.new(cells)
  end

  def count_neighbours(cell)
    x, y = cell

    count = 0

    moves = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

    moves.each do |dx,dy|
      count += 1 if cells.include?([x+dx, y+dy])
    end

    count
  end

  def next_generation!
    next_generation_cells = Set.new

    environment.each do |cell|
      neighbours = count_neighbours(cell)
      if cells.include?(cell) && [2, 3].include?(neighbours)
        next_generation_cells.add(cell)
      elsif !cells.include?(cell) && neighbours == 3
        next_generation_cells.add(cell)
      end
    end

    @cells = next_generation_cells
  end

  def environment
    @environment = Set.new

    cells.each do |x,y|
      [x-1, x, x+1].product([y-1, y, y+1]).each do |cell|
        @environment.add(cell)
      end
    end

    @environment
  end
end

describe Game do
  describe 'empty cells' do
    it 'has empty cells at start' do
      game = Game.new
      expect(game.cells).to be_empty
    end
  end

  describe 'one cell' do
    before do
      @game = Game.new([[0,0]])
    end

    it 'has one cell at start' do
      expect(@game.cells.size).to eq(1)
    end

    it 'has zero cells in next generation' do
      @game.next_generation!
      expect(@game.cells).to be_empty
    end
  end

  describe 'blinker (3 cells in column/row)' do
    before do
      cells = []
      (-1..1).each{|x| cells << [x, 0]}
      @game = Game.new(cells)
    end

    it 'has 3 cells at start' do
      expect(@game.cells.size).to eq(3)
    end

    it 'has 3 cells in next generation' do
      @game.next_generation!
      expect(@game.cells.size).to eq(3)
    end
  end

  describe '6 cells (3x2)' do
    before do
      cells = [
        [0,1], [1,1], [2,1],
        [0,0], [1,0], [2,0]
      ]
      @game = Game.new(cells)
    end

    it 'has 6 cells at start' do
      expect(@game.cells.size).to eq(6)
    end

    it 'has 6 cells in next generation (2 dies, 2 comes alive)' do
      @game.next_generation!
      expect(@game.cells.size).to eq(6)
      expect(@game.cells).to include([1,2])
      expect(@game.cells).to_not include([1,1])
      expect(@game.cells).to_not include([1,0])
      expect(@game.cells).to include([1,-1])
    end
  end
end
