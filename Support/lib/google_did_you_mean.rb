require File.dirname(__FILE__) + '/google'
module Google
  class DidYouMean
    attr_accessor :tool_tip
    attr_accessor :found
    attr_accessor :result
    
    def initialize()
      @found = false
      @tool_tip = ""
      @result = ""
    end
    
    def found?
      @found
    end
    
    def reset
      @found = false
      @tool_tip = ""      
      @result = ""
    end

    def check(words)
      reset
      @result = words.split(/_/).inject("") do |res, word|
        didyoumean = word
        result = Google.search(word)
        if result =~ %r'Did you mean <i>(.+)</i>'
          @found = true
          didyoumean = $~[1]
          @tool_tip << "#{word} changed to #{didyoumean}.\n"
        else          
          @tool_tip << "No 'Did you mean' found for #{word}.\n"
        end
        "#{res}#{'_' unless res == ""}#{didyoumean}"
      end
      @tool_tip.strip!
      @result
    end

  end
end
