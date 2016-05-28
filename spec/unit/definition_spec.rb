require_relative '../../lib/arcana/definition'

RSpec.describe Arcana::Definition do
  subject do
    Arcana::Definition.new(word: 'word',
                           category: 'category',
                           lambda: 'lambda',
                           description: 'description')
  end

  describe '#word' do
    it 'returns the word passed in' do
      expect(subject.word).to eq 'word'
    end
  end

  describe '#category' do
    it 'returns the category passed in' do
      expect(subject.category).to eq 'category'
    end
  end

  describe '#lambda' do
    it 'returns the lambda passed in' do
      expect(subject.lambda).to eq 'lambda'
    end
  end

  describe '#description' do
    it 'returns the description passed in' do
      expect(subject.description).to eq 'description'
    end
  end

  describe '#to_s' do
    it 'returns something basic when there is no description' do
      definition = Arcana::Definition.new(word: 'word',
                                          category: 'category',
                                          lambda: 'lambda')
      expect(definition.to_s).to eq 'word (category)'
    end

    it 'returns something full-fat when there is a description' do
      expect(subject.to_s).to eq 'word (category): description'
    end
  end
end
