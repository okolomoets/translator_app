class ErrorHandler < StandardError
  attr_reader :code

  def initialize(msg, code)
    super(msg)
    @code = code 
  end
end
