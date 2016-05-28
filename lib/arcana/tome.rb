module Arcana
  module Tome
    def type(word, lambda, description = nil)
      assign(:type, word, lambda, description)
    end

    def invoke_type(word)
      invoke word
    end

    def selector(word, lambda, description = nil)
      assign(:selector, word, lambda, description)
    end

    def invoke_selector(word, object)
      invoke word, object
    end

    def action(word, lambda, description = nil)
      assign(:action, word, lambda, description)
    end

    def invoke_action(word, refinements, *objects)
      invoke word, refinements, *objects
    end

    def refinement(word, lambda, description = nil)
      assign(:refinement, word, lambda, description)
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
      definition = get_definition_of(word)
      definition.category if definition
    end

    private

    def assign(category, word, lambda, description)
      initialize_all
      @definitions << Definition.new(category: category,
                                     word: word,
                                     lambda: lambda,
                                     description: description)
    end

    def get_all_that_are(category)
      initialize_all
      @definitions.select { |d| d.category == category }
    end

    def invoke(word, *args)
      initialize_all
      definition = get_definition_of(word)
      definition.lambda.call(*args)
    end

    def get_definition_of(word)
      @definitions.select { |d| d.word == word }.first
    end

    def initialize_all
      @definitions ||= []
    end
  end
end
