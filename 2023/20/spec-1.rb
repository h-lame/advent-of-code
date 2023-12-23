require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_module_configuration_1) { {
    broadcaster:  ['broadcaster', [:a, :b, :c]],
    a:  ['%', [:b]],
    b:  ['%', [:c]],
    c:  ['%', [:inv]],
    inv:  ['&', [:a]],
  } }

  let(:raw_module_configuration_2) { {
    broadcaster:  ['broadcaster', [:a]],
    a:  ['%', [:inv, :con]],
    inv:  ['&', [:b]],
    b:  ['%', [:con]],
    con:  ['&', [:output]],
  } }

  describe described_class::Normalizer do
    it 'converts a file into a hash keyed on node name, value is the type and array of connected nodes' do
      expect(described_class.do_it File.join(__dir__,'example-1.txt')).to eq raw_module_configuration_1
      expect(described_class.do_it File.join(__dir__,'example-2.txt')).to eq raw_module_configuration_2
    end
  end

  describe described_class::CommunicationModule do
    it 'is equal to another if the names match' do
      alice1 = described_class.build(:alice, '&')
      alice2 = described_class.build(:alice, '%')
      bob = described_class.build(:bob, '&')

      expect(alice1).to eq alice2
      expect(alice2).to eq alice1
      expect(alice1).not_to eq bob
      expect(alice2).not_to eq bob
      expect(bob).not_to eq alice1
      expect(bob).not_to eq alice2
    end

    it 'can be connected_to another' do
      alice = described_class.build(:alice, '&')
      bob = described_class.build(:bob, '&')

      alice.connect_to(bob)

      expect(alice.downstream).to eq Set.new([bob])
      expect(alice.upstream).to eq Set.new([])
      expect(bob.downstream).to eq Set.new([])
      expect(bob.upstream).to eq Set.new([alice])

      alice.connect_to(bob)

      expect(alice.downstream).to eq Set.new([bob])
      expect(alice.upstream).to eq Set.new([])
      expect(bob.downstream).to eq Set.new([])
      expect(bob.upstream).to eq Set.new([alice])
    end
  end

  describe described_class::Untyped do
    it 'does not emit pulses when received' do
      untyped = described_class.new(:alice)

      expect(untyped.receive(:high, from: 'whomever')).to eq []
      expect(untyped.receive(:low, from: 'whomever')).to eq []
    end
  end

  describe described_class::Broadcaster do
    it 'always emits a low pulse to all its downstream modules' do
      broadcaster = described_class.new(:broadcaster)

      expect(broadcaster.receive(:high, from: 'button')).to eq []
      expect(broadcaster.receive(:low, from: 'button')).to eq []

      downstream_1 = described_class.build(:alice, '&')
      downstream_2 = described_class.build(:bob, '&')
      not_downstream = described_class.build(:carol, '&')
      broadcaster.connect_to(downstream_1)
      broadcaster.connect_to(downstream_2)

      expect(broadcaster.receive(:high, from: 'button')).to eq [[downstream_1, broadcaster, :low], [downstream_2, broadcaster, :low]]
      expect(broadcaster.receive(:low, from: 'button')).to eq [[downstream_1, broadcaster, :low], [downstream_2, broadcaster, :low]]
    end
  end

  describe described_class::FlipFlop do
    it 'starts in the off state' do
      f = described_class.new(:a)

      expect(f).to be_off
    end

    it 'when off emits nothing if it receives a high pulse' do
      f = described_class.new(:a)

      expect(f.receive(:high, from: 'whomever')).to eq []

      downstream_1 = described_class.build(:alice, '&')
      downstream_2 = described_class.build(:bob, '&')
      not_downstream = described_class.build(:carol, '&')
      f.connect_to(downstream_1)
      f.connect_to(downstream_2)

      expect(f.receive(:high, from: 'whomever')).to eq []
    end

    it 'when off the state stays the same if it receives a high pulse' do
      f = described_class.new(:a) # is off

      f.receive(:high, from: 'whomever')
      expect(f).to be_off
    end

    it 'when off the state flips to on if it receives a low pulse' do
      f = described_class.new(:a) # is off

      f.receive(:low, from: 'whomever')
      expect(f).to be_on
    end

    it 'when off it emits a high pulse to all downstream if it receives a low pulse' do
      f = described_class.new(:a) # is off
      downstream_1 = described_class.build(:alice, '&')
      downstream_2 = described_class.build(:bob, '&')
      not_downstream = described_class.build(:carol, '&')
      f.connect_to(downstream_1)
      f.connect_to(downstream_2)

      expect(f.receive(:low, from: 'whomever')).to eq [[downstream_1, f, :high], [downstream_2, f, :high]]
    end

    it 'when on the state flips to off if it receives a low pulse' do
      f = described_class.new(:a) # is off
      f.receive(:low, from: 'whomever') # make it on
      f.receive(:low, from: 'whomever') # flip it off again

      expect(f).to be_off
    end

    it 'when on it emits nothing if it receives a low pulse' do
      f = described_class.new(:a) # is off
      f.receive(:low, from: 'whomever') # make it on
      expect(f.receive(:low, from: 'whomever')).to eq []
    end

    it 'when on it emits a low pulse to all downstream if it receives a low pulse' do
      f = described_class.new(:a) # is off
      f.receive(:low, from: 'whomever') # make it on

      downstream_1 = described_class.build(:alice, '&')
      downstream_2 = described_class.build(:bob, '&')
      not_downstream = described_class.build(:carol, '&')
      f.connect_to(downstream_1)
      f.connect_to(downstream_2)

      expect(f.receive(:low, from: 'whomever')).to eq [[downstream_1, f, :low], [downstream_2, f, :low]]
    end
  end

  describe described_class::Conjunction do
    it 'starts with empty memory' do
      c = described_class.new(:a)

      expect(c.memory).to eq({})
    end

    it 'sets memory for upstream modules to low' do
      c = described_class.new(:a)

      upstream_1 = described_class.build(:alice, '&')
      upstream_2 = described_class.build(:bob, '&')
      not_upstream = described_class.build(:carol, '&')
      upstream_1.connect_to(c)
      upstream_2.connect_to(c)

      expect(c.memory).to eq({alice: :low, bob: :low})
    end

    it 'when it receives a high pulse from an upstream it sets the memory for it to high' do
      c = described_class.new(:a) # is off

      upstream_1 = described_class.build(:alice, '&')
      upstream_2 = described_class.build(:bob, '&')
      not_upstream = described_class.build(:carol, '&')
      upstream_1.connect_to(c)
      upstream_2.connect_to(c)

      c.receive(:high, from: upstream_2)
      expect(c.memory).to eq({alice: :low, bob: :high})
    end

    it 'when it receives a low pulse from an upstream it sets the memory for it to low' do
      c = described_class.new(:a) # is off

      upstream_1 = described_class.build(:alice, '&')
      upstream_2 = described_class.build(:bob, '&')
      not_upstream = described_class.build(:carol, '&')
      upstream_1.connect_to(c)
      upstream_2.connect_to(c)

      c.receive(:high, from: upstream_2)
      c.receive(:low, from: upstream_2)
      expect(c.memory).to eq({alice: :low, bob: :low})
    end

    it 'when it receives a high pulse from an upstream it emits a high pulse to all downstream any of the last pulses from upstream were low' do
      c = described_class.new(:a) # is off

      upstream_1 = described_class.build(:alice, '&')
      upstream_2 = described_class.build(:bob, '&')
      not_upstream = described_class.build(:carol, '&')
      upstream_1.connect_to(c)
      upstream_2.connect_to(c)

      downstream_1 = described_class.build(:daphne, '&')
      downstream_2 = described_class.build(:ed, '&')
      not_upstream = described_class.build(:felicty, '&')
      c.connect_to(downstream_1)
      c.connect_to(downstream_2)

      c.receive(:low, from: upstream_1)
      expect(c.receive(:high, from: upstream_2)).to eq([[downstream_1, c, :high], [downstream_2, c, :high]])
    end

    it 'when it receives a high pulse from an upstream it emits a low pulse to all downstream if last pulse from all upstream was high' do
      c = described_class.new(:a) # is off

      upstream_1 = described_class.build(:alice, '&')
      upstream_2 = described_class.build(:bob, '&')
      not_upstream = described_class.build(:carol, '&')
      upstream_1.connect_to(c)
      upstream_2.connect_to(c)

      downstream_1 = described_class.build(:daphne, '&')
      downstream_2 = described_class.build(:ed, '&')
      not_upstream = described_class.build(:felicty, '&')
      c.connect_to(downstream_1)
      c.connect_to(downstream_2)

      c.receive(:high, from: upstream_1)
      expect(c.receive(:high, from: upstream_2)).to eq([[downstream_1, c, :low], [downstream_2, c, :low]])
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_module_configuration_1).result).to eq 32000000
    expect(described_class.new(raw_module_configuration_2).result).to eq 11687500
  end
end
