module Zaif
  class CampaignPresenter
    def initialize(campaign)
      @campaign = campaign
    end

    def render
      <<-"EOS"
#{@campaign.amount_str}
#{@campaign.title} from #{@campaign.user_name}(#{@campaign.twitter_name})
あと #{@campaign.enable_count} 人可能
#{@campaign.term}
#{@campaign.url}

      EOS
    end
  end
end
