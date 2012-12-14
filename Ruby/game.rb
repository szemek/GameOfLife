require 'set'

class Game
  attr_accessor :board

  def initialize(cells = [])
    @board = Set.new(cells)
  end

  def count_neighbours(cell)
    x, y = cell

    count = 0

    moves = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

    moves.each do |dx,dy|
      count += 1 if @board.include?([x+dx, y+dy])
    end

    count
  end

  def nextgen!
    environment = Set.new

    moves = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]]

    @board.each do |x,y|
      moves.each do |dx,dy|
        environment.add([x+dx, y+dy])
      end
    end

    nextgen_board = Set.new

    environment.each do |cell|
      neighbours = count_neighbours(cell)
      if @board.include?(cell) && [2, 3].include?(neighbours)
        nextgen_board.add(cell)
      elsif !@board.include?(cell) && neighbours == 3
        nextgen_board.add(cell)
      end
    end

    @board = nextgen_board
  end
end

describe Game do
  describe 'empty board' do
    it 'has empty board at start' do
      game = Game.new
      game.board.should be_empty
    end
  end

  describe 'one cell' do
    before do
      @game = Game.new([[0,0]])
    end

    it 'has one cell at start' do
      @game.board.size.should == 1
    end

    it 'has zero cells in next generation' do
      @game.nextgen!
      @game.board.size.should == 0
    end
  end

  describe 'blinker (3 cells in column/row)' do
    before do
      cells = []
      (-1..1).each{|x| cells << [x, 0]}
      @game = Game.new(cells)
    end

    it 'has 3 cells at start' do
      @game.board.size.should == 3
    end

    it 'has 3 cells in next generation' do
      @game.nextgen!
      @game.board.size.should == 3
    end

  end
end
