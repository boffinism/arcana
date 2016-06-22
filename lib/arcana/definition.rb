module Arcana
  class Definition
    attr_accessor :word, :category, :lambda, :description

    def initialize(word = nil, category = nil, lambda = nil, description = nil)
      @word = word
      @category = category
      @lambda = lambda
      @description = description
    end

    def to_s
      basic = "#{@word} (#{@category})"
      (@description && "#{basic}: #{@description}") || basic
    end
  end
end
