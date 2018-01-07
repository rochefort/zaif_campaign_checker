require "mechanize"

module Zaif
  class Crawler
    def initialize
      @agent = Mechanize.new
      @agent.user_agent_alias = "Windows Mozilla"
      @agent.request_headers = {
        "accept-language": "ja, ja-JP, en",
        "accept-encoding": "utf-8, us-ascii"
      }
    end

    def crawl(url)
      page = @agent.get(url)
      return nil unless page&.code == "200"
      page
    rescue Mechanize::ResponseCodeError => e
      return nil
    ensure
      sleep 1
    end
  end
end
