require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_bricks) { [
    [[1,0,1], [1,2,1]],
    [[0,0,2], [2,0,2]],
    [[0,2,3], [2,2,3]],
    [[0,0,4], [0,2,4]],
    [[2,0,5], [2,2,5]],
    [[0,1,6], [2,1,6]],
    [[1,1,8], [1,1,9]],
  ] }

  describe described_class::Normalizer do
    it 'converts a file into an array of pairs of xyz triples, one per line' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_bricks
    end
  end

  describe described_class::Brick do
    it 'is vertical if the z on top and tail are different' do
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,2))).to be_vertical
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(2,2,2))).to be_vertical
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,1))).not_to be_vertical
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,2,1))).not_to be_vertical
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(2,1,1))).not_to be_vertical
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(2,2,1))).not_to be_vertical
    end

    it 'is horizontal if the z on top and tail are the same' do
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,2))).not_to be_horizontal
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(2,2,2))).not_to be_horizontal
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,1))).to be_horizontal
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,2,1))).to be_horizontal
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(2,1,1))).to be_horizontal
      expect(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(2,2,1))).to be_horizontal
    end

    it 'is above another brick if our z min is above their z max' do
      a = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,5))
      b = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,2))
      c = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,4))
      d = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,5))
      e = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,6))
      f = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,5), tail: Solution1::XYZ.new(1,1,6))
      g = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,6), tail: Solution1::XYZ.new(1,1,6))
      h = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,6), tail: Solution1::XYZ.new(1,1,7))

      expect(b).not_to be_above(a)
      expect(c).not_to be_above(a)
      expect(d).not_to be_above(a)
      expect(e).not_to be_above(a)
      expect(f).not_to be_above(a)
      expect(g).to be_above(a)
      expect(h).to be_above(a)
    end

    it 'is above another brick if our z min is above their z max' do
      a = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,5))
      b = described_class.new(id: 'B', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,2))
      c = described_class.new(id: 'C', top: Solution1::XYZ.new(1,1,2), tail: Solution1::XYZ.new(1,1,2))
      d = described_class.new(id: 'D', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,4))
      e = described_class.new(id: 'E', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,5))
      f = described_class.new(id: 'F', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,6))
      g = described_class.new(id: 'G', top: Solution1::XYZ.new(1,1,5), tail: Solution1::XYZ.new(1,1,6))
      h = described_class.new(id: 'H', top: Solution1::XYZ.new(1,1,6), tail: Solution1::XYZ.new(1,1,6))
      i = described_class.new(id: 'I', top: Solution1::XYZ.new(1,1,6), tail: Solution1::XYZ.new(1,1,7))

      expect(b).not_to be_above(a)
      expect(c).not_to be_above(a)
      expect(d).not_to be_above(a)
      expect(e).not_to be_above(a)
      expect(f).not_to be_above(a)
      expect(g).not_to be_above(a)
      expect(h).to be_above(a)
      expect(i).to be_above(a)
    end

    it 'is below another brick if our z min is above their z max' do
      a = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,5))
      b = described_class.new(id: 'B', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,2))
      c = described_class.new(id: 'C', top: Solution1::XYZ.new(1,1,2), tail: Solution1::XYZ.new(1,1,2))
      d = described_class.new(id: 'D', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,4))
      e = described_class.new(id: 'E', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,5))
      f = described_class.new(id: 'F', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,6))
      g = described_class.new(id: 'G', top: Solution1::XYZ.new(1,1,5), tail: Solution1::XYZ.new(1,1,6))
      h = described_class.new(id: 'H', top: Solution1::XYZ.new(1,1,6), tail: Solution1::XYZ.new(1,1,6))
      i = described_class.new(id: 'I', top: Solution1::XYZ.new(1,1,6), tail: Solution1::XYZ.new(1,1,7))

      expect(b).to be_below(a)
      expect(c).to be_below(a)
      expect(d).not_to be_below(a)
      expect(e).not_to be_below(a)
      expect(f).not_to be_below(a)
      expect(g).not_to be_below(a)
      expect(h).not_to be_below(a)
      expect(i).not_to be_below(a)
    end

    it 'returns self if asked to fall when on the ground level' do
      a = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,1))

      expect(a.fall([])).to eq(a)
    end

    it 'supports another brick, if it is below and there is x & y crossover' do
      a = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,7), tail: Solution1::XYZ.new(1,1,8))
      b = described_class.new(id: 'B', top: Solution1::XYZ.new(1,1,9), tail: Solution1::XYZ.new(1,1,10))
      c = described_class.new(id: 'C', top: Solution1::XYZ.new(0,0,2), tail: Solution1::XYZ.new(0,0,3))
      d = described_class.new(id: 'D', top: Solution1::XYZ.new(1,0,2), tail: Solution1::XYZ.new(1,0,3))
      e = described_class.new(id: 'E', top: Solution1::XYZ.new(0,1,2), tail: Solution1::XYZ.new(0,1,3))
      f = described_class.new(id: 'F', top: Solution1::XYZ.new(1,1,2), tail: Solution1::XYZ.new(1,1,3))
      g = described_class.new(id: 'G', top: Solution1::XYZ.new(0,1,2), tail: Solution1::XYZ.new(2,1,3))
      h = described_class.new(id: 'H', top: Solution1::XYZ.new(1,0,2), tail: Solution1::XYZ.new(1,2,3))

      expect(b).not_to be_supporter_of(a)
      expect(c).not_to be_supporter_of(a)
      expect(d).not_to be_supporter_of(a)
      expect(e).not_to be_supporter_of(a)
      expect(f).to be_supporter_of(a)
      expect(g).to be_supporter_of(a)
      expect(h).to be_supporter_of(a)
    end

    it 'returns a new brick on the ground level if asked to fall when not on the ground level, and no suporting bricks' do
      a = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,2), tail: Solution1::XYZ.new(1,1,2))
      b = described_class.new(id: 'B', top: Solution1::XYZ.new(1,1,2), tail: Solution1::XYZ.new(1,1,3))
      c = described_class.new(id: 'C', top: Solution1::XYZ.new(0,0,1), tail: Solution1::XYZ.new(0,0,1))
      d = described_class.new(id: 'D', top: Solution1::XYZ.new(2,0,1), tail: Solution1::XYZ.new(2,0,1))
      e = described_class.new(id: 'E', top: Solution1::XYZ.new(0,2,1), tail: Solution1::XYZ.new(0,2,1))
      f = described_class.new(id: 'F', top: Solution1::XYZ.new(2,2,1), tail: Solution1::XYZ.new(2,2,1))

      expect(a.fall([])).to eq(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,1)))
      expect(b.fall([])).to eq(described_class.new(id: 'B', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,2)))
      expect(a.fall([c, d, e, f])).to eq(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,1), tail: Solution1::XYZ.new(1,1,1)))
    end

    it 'returns self if asked to fall, and there are suporting bricks but no gaps' do
      a = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,6), tail: Solution1::XYZ.new(1,1,6))
      b = described_class.new(id: 'B', top: Solution1::XYZ.new(1,1,6), tail: Solution1::XYZ.new(1,1,7))
      c = described_class.new(id: 'C', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,5))

      expect(a.fall([c])).to eq(a)
      expect(b.fall([c])).to eq(b)
    end

    it 'returns a new brick balanced on the tallest supporting brick if asked to fall, and there are suporting bricks' do
      a = described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,6), tail: Solution1::XYZ.new(1,1,6))
      b = described_class.new(id: 'B', top: Solution1::XYZ.new(1,1,6), tail: Solution1::XYZ.new(1,1,7))
      c = described_class.new(id: 'C', top: Solution1::XYZ.new(1,1,2), tail: Solution1::XYZ.new(1,1,3))

      expect(a.fall([c])).to eq(described_class.new(id: 'A', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,4)))
      expect(b.fall([c])).to eq(described_class.new(id: 'B', top: Solution1::XYZ.new(1,1,4), tail: Solution1::XYZ.new(1,1,5)))
    end
  end

  describe described_class::Jenga do
    it 'can render the x axis view before settling' do
      jenga = described_class.new(raw_bricks)
      expect(jenga.render(:x)).to eq(
        <<~JENGA.chomp
          [..][06][..]
          [..][06][..]
          [..][..][..]
          [05][05][05]
          [..][..][04]
          [03][..][..]
          [02][02][02]
          [01][01][01]
          [..][00][..]
          ------------
        JENGA
      )
    end

    it 'can render the y axis view before settling' do
      jenga = described_class.new(raw_bricks)
      expect(jenga.render(:y)).to eq(
        <<~JENGA.chomp
          [..][06][..]
          [..][06][..]
          [..][..][..]
          [..][05][..]
          [04][04][04]
          [03][03][03]
          [..][..][02]
          [01][..][..]
          [00][00][00]
          ------------
        JENGA
      )
    end

    it 'can settle the initial bricks to their stable state' do
      jenga = described_class.new(raw_bricks)
      jenga.settle!

      expect(jenga.render(:x)).to eq(
        <<~JENGA.chomp
          [..][06][..]
          [..][06][..]
          [05][05][05]
          [03][..][04]
          [??][??][??]
          [..][00][..]
          ------------
        JENGA
      )
      expect(jenga.render(:y)).to eq(
        <<~JENGA.chomp
          [..][06][..]
          [..][06][..]
          [..][05][..]
          [??][??][??]
          [01][..][02]
          [00][00][00]
          ------------
        JENGA
      )
    end
  end

  it 'knows if ranges overlap correctly' do
    expect(described_class.range_overlap?((1..2), (3..4))).to be_falsey
    expect(described_class.range_overlap?((1..2), (2..4))).to be_truthy
    expect(described_class.range_overlap?((1..2), (1..4))).to be_truthy
    expect(described_class.range_overlap?((1..2), (0..4))).to be_truthy
    expect(described_class.range_overlap?((3..4), (3..4))).to be_truthy
    expect(described_class.range_overlap?((3..5), (3..4))).to be_truthy
    expect(described_class.range_overlap?((3..5), (1..2))).to be_falsey
    expect(described_class.range_overlap?((3..5), (4..5))).to be_truthy
    expect(described_class.range_overlap?((3..5), (4..4))).to be_truthy
    expect(described_class.range_overlap?((3..3), (2..4))).to be_truthy
    expect(described_class.range_overlap?((2..2), (2..4))).to be_truthy
    expect(described_class.range_overlap?((4..4), (2..4))).to be_truthy
    expect(described_class.range_overlap?((2..4), (3..3))).to be_truthy
    expect(described_class.range_overlap?((2..4), (2..2))).to be_truthy
    expect(described_class.range_overlap?((2..4), (4..4))).to be_truthy
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_bricks).result).to eq 5
  end
end
