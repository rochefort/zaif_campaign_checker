require_relative "crawler"
require_relative "models/campaign"
require_relative "models/amount"
require_relative "presenters/campaign_presenter"

module Zaif
  class CampaignChecker
    MIN_ID = 737
    ID_FILE = File.join(File.dirname(__FILE__), "../../tmp/id.txt")
    BASE_URL = "https://zaif.jp/social/tw/campaign/"

    def initialize(id = nil)
      @id = id || load_id || MIN_ID
      @agent = Crawler.new

      @debug = !ENV["DEBUG"].nil?
    end

    def run
      loop do
        @url = "#{BASE_URL}#{@id}"
        page = @agent.crawl(@url)
        abort_not_found unless page
        campgaign = extract_campaign(page)
        render(campgaign)
        @id += 1
      end
    end

    private
      def load_id
        File.open(ID_FILE, "rb") { |f| Marshal.load(f) }
      rescue => e
        nil
      end

      def save_id
        File.open(ID_FILE, "wb") { |f| Marshal.dump(@id, f) }
      end

      def debug_puts(msg)
        puts msg if @debug
      end

      def abort_not_found
        debug_puts "#{@url} is 404"
        save_id
        exit
      end

      def extract_campaign(page)
        trs = page.search(".cp-table tr")
        return nil unless trs

        prof_rows = page.search(".prof_text .row")
        Campaign.new(
          title:        page.title,
          user_name:    prof_rows[0].search(".text-info")[1].text.strip,
          twitter_name: prof_rows[1].search(".text-info")[1].text.strip,
          term:         trs[0].search("td")[1].text().strip,
          headcount:    trs[1].search("td")[1].text().strip.to_i,
          amount_str:   trs[2].search("td")[1].text().strip,
          entry_count:  page.search(".well p")[0].text().to_i,
          rest_day:     page.search(".well p")[1].text().to_i,
          url:          @url
        )
      end

      def render(campaign)
        if campaign.enable_count <= 0
          debug_puts "#{@url} is over."
          return
        end
        unless campaign.amount.valuable?
          debug_puts "#{@url} #{campaign.amount_str} is not valuable."
          return
        end

        puts CampaignPresenter.new(campaign).render
      end
  end
end

if $0 == __FILE__
  z = Zaif::CampaignChecker.new
  z.run
end
