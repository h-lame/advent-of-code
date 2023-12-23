class Solution1
  class Normalizer
    def self.do_it(file_name)
      communication_module_strs = *File.readlines(file_name).map(&:chomp)
      Hash[
        communication_module_strs.map do |communication_module_str|
          /(?<type>[&%])?(?<name>[a-z]+)\s+\-\>\s+(?<connected>.+)/ =~ communication_module_str
          [name.to_sym, [type.nil? ? 'broadcaster' : type, connected.split(/,/).map(&:strip).map(&:to_sym)]]
        end
      ]
    end
  end

  class CommunicationModule
    def self.build(name, type)
      case type
      when 'broadcaster'
        Broadcaster.new(name)
      when '%'
        FlipFlop.new(name)
      when '&'
        Conjunction.new(name)
      else
        Untyped.new(name)
      end
    end

    def initialize(name)
      @name = name
      @downstream = Set.new
      @upstream = Set.new
    end

    def connect_to(downstream_module)
      self.downstream << downstream_module
      downstream_module.upstream_of(self)
    end

    def upstream_of(upstream_module)
      self.upstream << upstream_module
    end

    attr_reader :name, :type, :upstream, :downstream

    def eql?(other)
      case other
      in CommunicationModule
        name.eql?(other.name)
      else
        false
      end
    end
    alias :== :eql?

    def to_graphviz
      %|#{name} [label="#{name}, type: #{type}"]; #{name} -> { #{downstream.map(&:name).join ' '} }|
    end
  end

  class Broadcaster < CommunicationModule
    def type = 'broadcaster'

    def receive(_pulse, from:) = downstream.map { |d| [d, self, :low] }
  end

  class FlipFlop < CommunicationModule
    def initialize(name)
      super
      @state = 'off'
    end

    def receive(pulse, from:)
      return [] if pulse == :high

      if off?
        self.state = 'on'
        downstream.map { |d| [d, self, :high] }
      else
        self.state = 'off'
        downstream.map { |d| [d, self, :low] }
      end
    end

    def type = 'flip-flop'

    def on? = state == 'on'

    def off? = state == 'off'

    private

    attr_accessor :state
  end

  class Conjunction < CommunicationModule
    def initialize(name)
      super
      @memory = {}
    end

    def upstream_of(upstream_module)
      super
      memory[upstream_module.name] = :low
    end

    def type = 'conjunction'

    def receive(pulse, from:)
      # puts "memory: #{memory}"
      memory[from.name] = pulse

      if memory.values.all? { |p| p == :high }
        downstream.map { |d| [d, self, :low] }
      else
        downstream.map { |d| [d, self, :high] }
      end
    end

    attr_reader :memory
  end

  class Untyped < CommunicationModule
    def type = 'untyped'

    def receive(_pulse, from: )
      []
    end
  end

  def initialize(module_configurations)
    @communication_modules = Hash[module_configurations.map { |name, module_configuration| [name, CommunicationModule.build(name, module_configuration[0])] }]
    module_configurations.each do |name, module_configurations|
      module_configurations.last.each do |communication_module_name|
        found = communication_modules[communication_module_name]
        found = CommunicationModule.build(communication_module_name, nil) if found.nil?
        communication_modules[name].connect_to(found)
      end
    end
  end

  def to_graphviz = %|digraph { #{communication_modules.values.map(&:to_graphviz).join("\n")} }|

  attr_reader :communication_modules

  def result
    lows = 0
    highs = 0
    1_000.times do |tick|
      puts "Tick #{tick+1}, l: #{lows}, h: #{highs}"
      pulses = communication_modules[:broadcaster].receive(:low, from: 'button')
      lows += 1 # button low pulse
      tl = 1
      th = 0
      t = 1
      while pulses.any?
        # puts "P: [#{pulses.map { |p| "t: #{p[0].name}, f:#{p[1].name}, p:#{p[2]}"}}]"
        receiver, sender, pulse = *pulses.shift
        if pulse == :low
          tl += 1
          lows += 1
        else
          highs += 1
          th += 1
        end
        t += 1
        pulses += receiver.receive(pulse, from: sender)
      end
      puts "Tick #{tick+1}, total pulses: #{t} (l: #{tl}, h: #{th})"
    end
    lows * highs
  end
end

if __FILE__ == $0
  communication_modules = Solution1.new(Solution1::Normalizer.do_it(ARGV[0]))
  puts communication_modules.to_graphviz
  puts communication_modules.result
end
