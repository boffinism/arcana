require_relative '../../lib/arcana/demon'

RSpec.describe Arcana::Demon do
  subject(:demon) { Arcana::Demon.new }

  describe '#assimilate' do
    let(:tome_class) { Class.new }

    it 'adds the tome to the available tomes' do
      demon.assimilate(tome_class)

      expect(demon.tomes).to eq([tome_class])
    end
  end

  describe '#cast' do
    let(:tome) do
      double :tome,
             get_category: :type,
             invoke_type: nil,
             invoke_selector: nil,
             invoke_refinement: nil,
             invoke_action: nil
    end

    let(:invoked_type) { double :invoked_type }
    let(:selectored_type) { double :selectored_type }
    let(:refinements) { { some: :refinement } }

    before do
      demon.assimilate tome

      expect(tome).to receive(:get_category).with(:abra).and_return(:type)
      expect(tome).to receive(:get_category).with(:cadabra).and_return(:selector)
      expect(tome).to receive(:get_category).with(:miasma).and_return(:action)
      expect(tome).to receive(:get_category).with(:phantasma).and_return(:refinement)
    end

    it 'creates an array of categorised words' do
      demon.cast 'abra cadabra miasma phantasma'

      expect(demon.words).to eq [{ category: :type, word: :abra, tome: tome },
                                 { category: :selector, word: :cadabra, tome: tome },
                                 { category: :action, word: :miasma, tome: tome },
                                 { category: :refinement, word: :phantasma, tome: tome }]
    end

    it 'creates an array of semantic blocks' do
      demon.cast 'abra cadabra miasma phantasma'

      expect(demon.semantic_blocks).to eq [{ block_type: :object,
                                             type: { word: :abra, tome: tome },
                                             selectors: [{ word: :cadabra, tome: tome }] },
                                           { block_type: :verb,
                                             action: { word: :miasma, tome: tome },
                                             refinements: [{ word: :phantasma, tome: tome }] }]
    end

    it 'asks the tome to invoke each word appropriately' do
      expect(tome).to receive(:invoke_type).with(:abra)
        .and_return invoked_type
      expect(tome).to receive(:invoke_selector).with(:cadabra, invoked_type)
        .and_return selectored_type
      expect(tome).to receive(:invoke_refinement) do |word_name, base_refinement|
        expect(word_name).to eq :phantasma
        expect(base_refinement).to eq({})
        base_refinement.merge! refinements
      end
      expect(tome).to receive(:invoke_action).with(:miasma, refinements, selectored_type)

      demon.cast 'abra cadabra miasma phantasma'
    end
  end
end
