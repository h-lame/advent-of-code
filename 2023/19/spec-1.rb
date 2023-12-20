require File.join(__dir__, 'solution-1')

RSpec.describe Solution1 do
  let(:raw_workflows_and_parts) { [
    {
      px:  ['a<2006:qkq', 'm>2090:A', 'rfg'],
      pv:  ['a>1716:R', 'A'],
      lnx: ['m>1548:A', 'A'],
      rfg: ['s<537:gd', 'x>2440:R', 'A'],
      qs:  ['s>3448:A', 'lnx'],
      qkq: ['x<1416:A', 'crn'],
      crn: ['x>2662:A', 'R'],
      in:  ['s<1351:px', 'qqz'],
      qqz: ['s>2770:qs', 'm<1801:hdj', 'R'],
      gd:  ['a>3333:R', 'R'],
      hdj: ['m>838:A', 'pv'],
    },
    [
      {x: 787, m: 2655, a: 1222, s: 2876},
      {x: 1679, m: 44, a: 2067, s: 496},
      {x: 2036, m: 264, a: 79, s: 2244},
      {x: 2461, m: 1339, a: 466, s: 291},
      {x: 2127, m: 1623, a: 2188, s: 1013},
    ]
  ] }
  let(:prepared_workflows) { raw_workflows_and_parts[0].transform_values { |w| Solution1::Workflow.new(rules: w) } }
  let(:prepared_parts) { raw_workflows_and_parts[1].map { |p| Solution1::Part.from_raw(p) } }

  describe described_class::Normalizer do
    it 'converts a file into an two parts: a hash of workflows, keyed on the label then an array of strings split on ","; and an array of parts (hashes keyed on var=number) constructs.' do
      expect(described_class.do_it File.join(__dir__,'example.txt')).to eq raw_workflows_and_parts
    end
  end

  describe described_class::Workflow do
    it 'applies to the supplied part and returns the first condition for which it matches' do
      workflow = described_class.new(rules: ['x>2:x_rule','m>2:m_rule','a>2:a_rule','s>2:s_rule','x<1:x_rule','m<1:m_rule','a<1:a_rule','s<1:s_rule','default_rule'])

      expect(workflow.apply_to_part(Solution1::Part.new(x: 3, m: 3, a: 3, s: 3))).to eq 'x_rule'
      expect(workflow.apply_to_part(Solution1::Part.new(x: 2, m: 3, a: 3, s: 3))).to eq 'm_rule'
      expect(workflow.apply_to_part(Solution1::Part.new(x: 2, m: 2, a: 3, s: 3))).to eq 'a_rule'
      expect(workflow.apply_to_part(Solution1::Part.new(x: 2, m: 2, a: 2, s: 3))).to eq 's_rule'
      expect(workflow.apply_to_part(Solution1::Part.new(x: 2, m: 2, a: 2, s: 2))).to eq 'default_rule'

      expect(workflow.apply_to_part(Solution1::Part.new(x: 0, m: 1, a: 1, s: 1))).to eq 'x_rule'
      expect(workflow.apply_to_part(Solution1::Part.new(x: 1, m: 0, a: 1, s: 1))).to eq 'm_rule'
      expect(workflow.apply_to_part(Solution1::Part.new(x: 1, m: 1, a: 0, s: 1))).to eq 'a_rule'
      expect(workflow.apply_to_part(Solution1::Part.new(x: 1, m: 1, a: 1, s: 0))).to eq 's_rule'
    end
  end

  describe described_class::Engine do
    it 'returns the result of applying the in rule if it is terminal' do
      engine = described_class.new(workflow_map: {
        in: Solution1::Workflow.new(rules: ['A']),
      })

      expect(engine.process_part(Solution1::Part.new(x: 1, m: 3, a: 3, s: 3))).to eq 'A'
      engine = described_class.new(workflow_map: {
        in: Solution1::Workflow.new(rules: ['x>2:A', 'R']),
      })
      expect(engine.process_part(Solution1::Part.new(x: 2, m: 3, a: 3, s: 3))).to eq 'R'
      expect(engine.process_part(Solution1::Part.new(x: 3, m: 3, a: 3, s: 3))).to eq 'A'
    end

    it 'follows the result of applying the first rule and applys the result of that rule if it is terminal' do
      engine = described_class.new(workflow_map: {
        in: Solution1::Workflow.new(rules: ['x>2:bb', 'cc']),
        bb: Solution1::Workflow.new(rules: ['m>2:R', 'A']),
        cc: Solution1::Workflow.new(rules: ['m>2:A', 'R']),
      })
      expect(engine.process_part(Solution1::Part.new(x: 3, m: 3, a: 3, s: 3))).to eq 'R'
      expect(engine.process_part(Solution1::Part.new(x: 3, m: 2, a: 3, s: 3))).to eq 'A'
      expect(engine.process_part(Solution1::Part.new(x: 2, m: 3, a: 3, s: 3))).to eq 'A'
      expect(engine.process_part(Solution1::Part.new(x: 2, m: 2, a: 3, s: 3))).to eq 'R'
    end

    it 'returns all parts whose process_part result is "A"' do
      engine = described_class.new(workflow_map: {
        in: Solution1::Workflow.new(rules: ['x>2:bb', 'cc']),
        bb: Solution1::Workflow.new(rules: ['m>2:R', 'A']),
        cc: Solution1::Workflow.new(rules: ['m>2:A', 'R']),
      })

      parts = [
        Solution1::Part.new(x: 3, m: 3, a: 3, s: 3),
        Solution1::Part.new(x: 3, m: 2, a: 3, s: 3),
        Solution1::Part.new(x: 2, m: 3, a: 3, s: 3),
        Solution1::Part.new(x: 2, m: 2, a: 3, s: 3),
      ]

      expect(engine.accepted_parts(parts)).to eq [parts[1], parts[2]]

      engine = described_class.new(workflow_map: prepared_workflows)
      expect(engine.accepted_parts(prepared_parts).size).to eq 3
    end
  end

  describe described_class::Part do
    it 'is constructed from a raw hash' do
      _workflows, parts = *raw_workflows_and_parts
      part = described_class.from_raw(parts[0])

      expect(part.x).to eq 787
      expect(part.m).to eq 2655
      expect(part.a).to eq 1222
      expect(part.s).to eq 2876
    end

    it 'provides the score by adding the x,m,a,s attribute values' do
      _workflows, parts = *raw_workflows_and_parts

      expect(described_class.from_raw(parts[0]).score).to eq 7540
      expect(described_class.from_raw(parts[2]).score).to eq 4623
      expect(described_class.from_raw(parts[4]).score).to eq 6951
    end
  end

  it 'gives the correct solution for the examples' do
    expect(described_class.new(raw_workflows_and_parts).result).to eq 19114
  end
end
