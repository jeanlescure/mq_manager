class TestClass
	def initialize
		@foo = 'bar'
    sc = SecondClass.new
    sc.test
	end
  
  class SecondClass
    def test
      puts @foo
    end
  end
end

TestClass.new
