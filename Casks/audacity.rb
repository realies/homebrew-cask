require 'net/http'
require 'json'
require 'uri'

cask 'audacity' do
  version '2.3.3'
  sha256 '43db4d502086257ca377326f9621a343149faac6d3334424b20a3b5caceadda8'

  def fosshub_signed
    fosshub_response = nil
    uri = URI('https://api.fosshub.com/download/')
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      request.body = { 'fileName' => 'audacity-macos-2.3.3.dmg', 'projectId' => '5b7eee97e8058c20a7bbfcf4', 'projectUri' => 'Audacity.html', 'releaseId' => '5dd7e00e1d5d8e08348e2444', 'source' => 'CF' }.to_json
      response = http.request request # Net::HTTPResponse object
      fosshub_response = JSON.parse(response.body)
    end
    fosshub_response['data']['url']
  end
  url fosshub_signed
  name 'Audacity'
  homepage 'http://audacityteam.org/'

  app 'Audacity.app'

  zap delete: '~/Library/Application Support/audacity'
end
