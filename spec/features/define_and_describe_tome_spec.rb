require_relative '../../lib/arcana.rb'

RSpec.describe 'Define and describe a Tome:' do
  context 'When a FlameLore tome is defined' do
    let(:flame_lore_class) do
      Class.new do
        extend Arcana::Tome

        type :silvin, nil, 'Wooden things'
        type :pyrin, nil, 'Flames'
        selector :quensch, nil, 'Not on fire'
        action :ignia, nil, 'Set aflame'
        action :extingue, nil, 'Extinguish flames'
      end
    end

    it 'provides a definition of the spells' do
      output = flame_lore_class.types.map(&:to_s) +
               flame_lore_class.selectors.map(&:to_s) +
               flame_lore_class.actions.map(&:to_s) +
               flame_lore_class.refinements.map(&:to_s)

      expected_output = ['silvin (type): Wooden things',
                         'pyrin (type): Flames',
                         'quensch (selector): Not on fire',
                         'ignia (action): Set aflame',
                         'extingue (action): Extinguish flames']

      expect(output).to eq expected_output
    end
  end
end
