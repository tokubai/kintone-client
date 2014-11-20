class Kintone::Error < StandardError
  attr_reader :response

  def initialize(response)
    super(response['message'])
    @response = response
  end
end
