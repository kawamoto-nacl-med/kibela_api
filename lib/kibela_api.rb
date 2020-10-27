require "json"
require "net/http"

require "kibela_api/custom_emoji"
require "kibela_api/version"

class KibelaApi
  class Error < StandardError; end

  def initialize(team, token, user_agent = "kibela api")
    @team = team
    @token = token
    @user_agent = user_agent
  end

  def wait
    return unless @request_time

    difference_time = Time.now - @request_time
    sleep(0.1 - difference_time) if difference_time < 0.1
  end

  def request_header
    {
      "Authorization" => "Bearer #{@token}",
      "Content-Type" => "application/json",
      "User-Agent" => @user_agent,
    }
  end

  def http
    unless @http
      @http = Net::HTTP.new("#{@team}.kibe.la", Net::HTTP.https_default_port)
      @http.use_ssl = true
    end
    @http
  end

  # @params [Hash] query リクエスト。
  # @return [Hash] レスポンス。
  def request(query)
    wait

    response = http.request_post("/api/v1", JSON.generate(query), request_header)
    @request_time = Time.now
    JSON.parse(response.body, symbolize_names: true)
  end

  # @params [String] query_str
  # @params [String] variables_str
  # @return [Hash]
  def generate_query(query_str, variables_str = nil)
    query = { query: query_str }
    query[:variables] = variables_str if variables_str

    query
  end
end
