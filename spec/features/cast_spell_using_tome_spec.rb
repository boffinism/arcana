require_relative '../../lib/arcana.rb'

RSpec.describe 'Cast a spell using a tome:' do
  subject(:demon) { Arcana::Demon.new }

  context 'When a TreeLore tome is defined' do
    before do
      stub_const('Tree', Class.new)
    end

    let(:tree_lore_class) do
      Class.new(Arcana::Tome) do
        type :arboria, -> { Tree.all }
        selector :minimis, -> (t) { t.where(size: :small) }
        action :gorgal, -> (rs, o) { o.update_all(size: rs[:size]) if rs[:size] }
        refinement :grandis, -> (rs) { rs.merge(size: :large) }
      end
    end

    let(:all_trees) { double :all_trees }
    let(:small_trees) { double :small_trees }

    it 'casts a spell according to the tome' do
      demon.assimilate(tree_lore_class)

      expect(Tree).to receive(:all).and_return all_trees
      expect(all_trees).to receive(:where).with(size: :small).and_return(small_trees)
      expect(small_trees).to receive(:update_all).with(size: :large)

      demon.cast('arboria minimis gorgal grandis')
    end
  end
end
