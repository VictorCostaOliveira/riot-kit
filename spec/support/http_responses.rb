# frozen_string_literal: true

module HttpResponses
  module_function

  def ok(body)
    RiotKit::Http::Response.new(status: 200, result: body, error: nil)
  end

  def error(status, body = { message: 'err' })
    RiotKit::Http::Response.new(status: status, result: nil, error: body)
  end
end
