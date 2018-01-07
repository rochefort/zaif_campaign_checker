module Zaif
  class Campaign
    attr_accessor :title, :user_name, :twitter_name, :term, :headcount,
      :amount_str, :entry_count, :rest_day, :url

    attr_accessor :enable_count
    attr_accessor :amount

    def initialize(hash)
      hash.each do |k, v|
        send("#{k}=", v)
      end

      @enable_count = headcount - entry_count
      @amount = AmountFactory.for(amount_str)
    end
  end
end
