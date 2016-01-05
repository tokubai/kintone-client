class Kintone::Error < StandardError
  attr_reader :response

  def initialize(response, path, method_name, params)
    message = [response['message'], response['errors'], path, method_name, params].join(' ')
    super(message)
    @response = response
  end
end
