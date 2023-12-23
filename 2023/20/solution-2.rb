class Solution2
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
        if found.nil?
          puts "Building #{communication_module_name} from 0"
          found = CommunicationModule.build(communication_module_name, nil)
          communication_modules[found.name] = found
        end
        communication_modules[name].connect_to(found)
      end
    end
  end

  def to_graphviz = %|digraph { #{communication_modules.values.map(&:to_graphviz).join("\n")} }|

  attr_reader :communication_modules

  def result(for_node, detect_pulse)
    for_node = for_node.to_sym
    detect_pulse = detect_pulse.to_sym
    ticks = 0
    rx = communication_modules[for_node]

    # rx receive low
    # ll emits low
    # ll receive high from kv + vm + kl + vb

    raise "No #{for_node}!" if rx.nil?
    detected_pulses = []
    loop do
      rx_pulses = rx_detected_pulses = 0
      ticks += 1
      pulses = communication_modules[:broadcaster].receive(:low, from: 'button')
      while pulses.any?
        receiver, sender, pulse = *pulses.shift
        if receiver.name == for_node
          rx_pulses += 1
          if pulse == detect_pulse
            rx_detected_pulses += 1
            detected_pulses << [ticks, sender.name]
          end
        end
        pulses += receiver.receive(pulse, from: sender)
      end
      puts "Tick #{ticks} - #{for_node} #{rx_detected_pulses}/#{rx_pulses} (#{detected_pulses}) vs (#{rx.upstream.map(&:name)}) "

      break if detected_pulses.map(&:last).sort == rx.upstream.map(&:name).sort
    end
    detected_pulses.map(&:first).reduce(:lcm)
    # ticks
    # detected_pulses.last.first
    # ticks
  end
end

if __FILE__ == $0
  communication_modules = Solution2.new(Solution2::Normalizer.do_it(ARGV[0]))
  puts communication_modules.to_graphviz
  puts communication_modules.result(ARGV[1] || 'rx', ARGV[2] || 'low')
end
