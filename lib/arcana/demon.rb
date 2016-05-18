module Arcana
  class Demon
    attr_reader :tomes
    attr_reader :words
    attr_reader :semantic_blocks

    def initialize
      @tomes = []
    end

    def assimilate(tome)
      @tomes << tome
    end

    def cast(spell)
      @words = create_word_array spell
      @semantic_blocks = create_block_array @words
      invoke_all @semantic_blocks
    end

    private

    def create_word_array(spell)
      [].tap do |words|
        spell.split.map(&:to_sym).each do |word|
          words << get_word_data(word)
        end
      end
    end

    def get_word_data(word)
      tomes.each do |tome|
        if (category = tome.get_category(word))
          return { category: category, word: word, tome: tome }
        end
      end
    end

    def create_block_array(words)
      [].tap do |blocks|
        words.each do |word|
          word_data = { word: word[:word], tome: word[:tome] }
          action_word word[:category],
                      word_data,
                      blocks
        end
      end
    end

    def action_word(category, word_data, block_list)
      case category
      when :type
        block_list << create_object_block(word_data)
      when :action
        block_list << create_verb_block(word_data)
      when :selector
        block_list.last[:selectors] << word_data
      when :refinement
        block_list.last[:refinements] << word_data
      end
    end

    def create_object_block(word_data)
      { block_type: :object,
        type: word_data,
        selectors: [] }
    end

    def create_verb_block(word_data)
      { block_type: :verb,
        action: word_data,
        refinements: [] }
    end

    def invoke_all(semantic_blocks)
      last_verb = -1

      semantic_blocks.each_with_index do |block, index|
        next if block[:block_type] == :object

        invoked_objects = semantic_blocks[(last_verb + 1)...index].map do |o_block|
          invoke_object_block o_block
        end

        invoke_verb_block block, invoked_objects
      end
    end

    def invoke_object_block(block)
      type_word = block[:type]
      invoked = type_word[:tome].invoke_type(type_word[:word])

      block[:selectors].each do |selector_word|
        invoked = selector_word[:tome].invoke_selector(selector_word[:word], invoked)
      end

      invoked
    end

    def invoke_verb_block(block, invoked_objects)
      action_word = block[:action]

      refinements = {}

      block[:refinements].each do |refinement_word|
        refinements = refinement_word[:tome].invoke_refinement(refinement_word[:word], refinements)
      end

      action_word[:tome].invoke_action(action_word[:word], refinements, *invoked_objects)
    end
  end
end
