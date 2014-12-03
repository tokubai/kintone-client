require 'base64'
require 'json'

require 'faraday'
require 'faraday_middleware'

module Kintone; end
require 'kintone/client/client'
require 'kintone/client/error'
require 'kintone/client/middleware/form'
require 'kintone/client/middleware/record'
require 'kintone/client/version'
