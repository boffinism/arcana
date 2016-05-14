class Tome
  class << self
    def type(word, lambda)
      initialize_types
      @types[word] = lambda
    end

    def types
      initialize_types
      @types
    end

    def invoke_type(word)
      initialize_types
      @types[word].call
    end

    def selector(word, lambda)
      initialize_selectors
      @selectors[word] = lambda
    end

    def selectors
      initialize_selectors
      @selectors
    end

    def invoke_selector(word, type)
      initialize_selectors
      @selectors[word].call type
    end

    def action(word, lambda)
      initialize_actions
      @actions[word] = lambda
    end

    def actions
      initialize_actions
      @actions
    end

    def invoke_action(word, refinements, *objects)
      initialize_actions
      @actions[word].call refinements, *objects
    end

    def refinement(word, lambda)
      initialize_refinements
      @refinements[word] = lambda
    end

    def refinements
      initialize_refinements
      @refinements
    end

    def invoke_refinement(word, existing_refinements)
      initialize_refinements
      @refinements[word].call existing_refinements
    end

    def get_category(word)
      initialize_all

      [[:type, @types],
       [:selector, @selectors],
       [:action, @actions],
       [:refinement, @refinements]].each do |name_list_pair|
        return name_list_pair[0] if name_list_pair[1][word]
      end

      nil
    end

    def reset
      @types = nil
      @selectors = nil
      @actions = nil
      @refinements = nil
    end

    private

    def initialize_all
      initialize_types
      initialize_selectors
      initialize_refinements
      initialize_actions
    end

    def initialize_types
      @types ||= {}
    end

    def initialize_selectors
      @selectors ||= {}
    end

    def initialize_actions
      @actions ||= {}
    end

    def initialize_refinements
      @refinements ||= {}
    end
  end
end
