require 'parse_js/constants'
require 'parse_js/visitable'
require 'parse_js/visitors'
require 'parse_js/parser'
require 'parse_js/runtime'
require 'parse_js/syntax_error'

module ParseJS
  class << self
    def parse *args
      ParseJS::Parser.new.parse(*args)
    end
  end
end
