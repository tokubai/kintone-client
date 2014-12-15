class Kintone::Error < StandardError
  attr_reader :response

  def initialize(response, path, method_name, params)
    message = [response['message'], path, method_name, params].join(' ')
    super(message)
    @response = response
  end
end
