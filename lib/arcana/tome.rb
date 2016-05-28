module Arcana
  module Tome
    def type(word, lambda)
      assign(:type, word, lambda)
    end

    def invoke_type(word)
      invoke word
    end

    def selector(word, lambda)
      assign(:selector, word, lambda)
    end

    def invoke_selector(word, object)
      invoke word, object
    end

    def action(word, lambda)
      assign(:action, word, lambda)
    end

    def invoke_action(word, refinements, *objects)
      invoke word, refinements, *objects
    end

    def refinement(word, lambda)
      assign(:refinement, word, lambda)
    end

    def invoke_refinement(word, existing_refinements)
      invoke word, existing_refinements
    end

    def types
      get_all_that_are :type
    end

    def selectors
      get_all_that_are :selector
    end

    def actions
      get_all_that_are :action
    end

    def refinements
      get_all_that_are :refinement
    end

    def get_category_of(word)
      selected = find_word_details(word)
      selected[:category] if selected
    end

    private

    def assign(category, word, lambda)
      initialize_all
      @word_details << { category: category,
                         word: word,
                         lambda: lambda }
    end

    def get_all_that_are(category)
      initialize_all
      @word_details.select { |w| w[:category] == category }
    end

    def invoke(word, *args)
      initialize_all
      selected = find_word_details(word)
      selected[:lambda].call(*args)
    end

    def find_word_details(word)
      @word_details.select { |w| w[:word] == word }.first
    end

    def initialize_all
      @word_details ||= []
    end
  end
end
