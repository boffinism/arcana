require_relative '../../lib/warlock/tome'

RSpec.describe Tome do
  let(:lambda) { double :lambda }

  before do
    Tome.reset
  end

  describe '.type & .types' do
    it 'stores a symbol against a lambda' do
      Tome.type :identifier, lambda
      expect(Tome.types).to eq(identifier: lambda)
    end
  end

  describe '.selector & .selectors' do
    it 'stores a symbol against a lambda' do
      Tome.selector :identifier, lambda
      expect(Tome.selectors).to eq(identifier: lambda)
    end
  end

  describe '.action & .actions' do
    it 'stores a symbol against a lambda' do
      Tome.action :identifier, lambda
      expect(Tome.actions).to eq(identifier: lambda)
    end
  end

  describe '.refinement & .refinements' do
    it 'stores a symbol against a lambda' do
      Tome.refinement :identifier, lambda
      expect(Tome.refinements).to eq(identifier: lambda)
    end
  end

  describe '.invoke_type' do
    it 'calls the matching lambda and returns the result' do
      expect(lambda).to receive(:call).and_return(:result)

      Tome.type :identifier, lambda
      expect(Tome.invoke_type(:identifier)).to eq :result
    end
  end

  describe '.invoke_selector' do
    it 'calls the matching lambda and returns the result' do
      expect(lambda).to receive(:call).with(:type).and_return(:result)

      Tome.selector :identifier, lambda
      expect(Tome.invoke_selector(:identifier, :type)).to eq :result
    end
  end

  describe '.invoke_refinement' do
    it 'calls the matching lambda and returns the result' do
      expect(lambda).to receive(:call).with(:refinement).and_return(:result)

      Tome.refinement :identifier, lambda
      expect(Tome.invoke_refinement(:identifier, :refinement)).to eq :result
    end
  end

  describe '.invoke_action' do
    it 'calls the matching lambda and returns the result' do
      expect(lambda).to receive(:call).with(:refinements, :object).and_return(:result)

      Tome.action :identifier, lambda
      expect(Tome.invoke_action(:identifier, :refinements, :object)).to eq :result
    end
  end

  describe '.get_category' do
    it 'returns the category of the given word if found' do
      Tome.type :foo, lambda
      Tome.selector :bar, lambda
      expect(Tome.get_category(:bar)).to eq :selector
    end

    it 'returns nil if word not found found' do
      Tome.type :foo, lambda
      Tome.selector :bar, lambda
      expect(Tome.get_category(:czar)).to eq nil
    end
  end
end
