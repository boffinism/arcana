require_relative '../../lib/warlock'

RSpec.describe Warlock do
  subject(:warlock) { Warlock.new }

  describe '#add_tome' do
    let(:tome_class) { Class.new }

    it 'adds the tome to the available tomes' do
      warlock.add_tome(tome_class)

      expect(warlock.tomes).to eq([tome_class])
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
    let(:refinements) { double :refinements }

    before do
      warlock.add_tome tome

      expect(tome).to receive(:get_category).with(:abra).and_return(:type)
      expect(tome).to receive(:get_category).with(:cadabra).and_return(:selector)
      expect(tome).to receive(:get_category).with(:miasma).and_return(:action)
      expect(tome).to receive(:get_category).with(:phantasma).and_return(:refinement)
    end

    it 'creates an array of categorised words' do
      warlock.cast 'abra cadabra miasma phantasma'

      expect(warlock.words).to eq [{ category: :type, word: :abra, tome: tome },
                                   { category: :selector, word: :cadabra, tome: tome },
                                   { category: :action, word: :miasma, tome: tome },
                                   { category: :refinement, word: :phantasma, tome: tome }]
    end

    it 'creates an array of semantic blocks' do
      warlock.cast 'abra cadabra miasma phantasma'

      expect(warlock.semantic_blocks).to eq [{ block_type: :object,
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
      expect(tome).to receive(:invoke_refinement).with(:phantasma, {})
        .and_return refinements
      expect(tome).to receive(:invoke_action).with(:miasma, refinements, selectored_type)

      warlock.cast 'abra cadabra miasma phantasma'
    end
  end
end
