require_relative '../../lib/arcana/tome'

RSpec.describe Arcana::Tome do
  let(:lambda) { double :lambda }

  subject do
    Class.new do
      extend Arcana::Tome
    end
  end

  describe '.type' do
    it 'stores a symbol against a lambda' do
      subject.type :identifier, lambda
      expect(subject.definitions.first.word).to eq :identifier
      expect(subject.definitions.first.lambda).to eq lambda
    end
  end

  describe '.selector' do
    it 'stores a symbol against a lambda' do
      subject.selector :identifier, lambda
      expect(subject.definitions.first.word).to eq :identifier
      expect(subject.definitions.first.lambda).to eq lambda
    end
  end

  describe '.action' do
    it 'stores a symbol against a lambda' do
      subject.action :identifier, lambda
      expect(subject.definitions.first.word).to eq :identifier
      expect(subject.definitions.first.lambda).to eq lambda
    end
  end

  describe '.refinement' do
    it 'stores a symbol against a lambda' do
      subject.refinement :identifier, lambda
      expect(subject.definitions.first.word).to eq :identifier
      expect(subject.definitions.first.lambda).to eq lambda
    end
  end

  describe '.invoke_type' do
    it 'calls the matching lambda and returns the result' do
      expect(lambda).to receive(:call).and_return(:result)

      subject.type :identifier, lambda
      expect(subject.invoke_type(:identifier)).to eq :result
    end
  end

  describe '.invoke_selector' do
    it 'calls the matching lambda and returns the result' do
      expect(lambda).to receive(:call).with(:type).and_return(:result)

      subject.selector :identifier, lambda
      expect(subject.invoke_selector(:identifier, :type)).to eq :result
    end
  end

  describe '.invoke_refinement' do
    it 'calls the matching lambda and returns the result' do
      expect(lambda).to receive(:call).with(:refinement).and_return(:result)

      subject.refinement :identifier, lambda
      expect(subject.invoke_refinement(:identifier, :refinement)).to eq :result
    end
  end

  describe '.invoke_action' do
    it 'calls the matching lambda and returns the result' do
      expect(lambda).to receive(:call).with(:refinements, :object).and_return(:result)

      subject.action :identifier, lambda
      expect(subject.invoke_action(:identifier, :refinements, :object)).to eq :result
    end
  end

  describe '.get_category_of' do
    it 'returns the category of the given word if found' do
      subject.type :foo, lambda
      subject.selector :bar, lambda
      expect(subject.get_category_of(:bar)).to eq :selector
    end

    it 'returns nil if word not found found' do
      subject.type :foo, lambda
      subject.selector :bar, lambda
      expect(subject.get_category_of(:czar)).to eq nil
    end
  end
end
