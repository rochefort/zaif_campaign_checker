module Zaif
  class AmountFactory
    class << self
      def for(amount_str)
        amount, currency_type = split_amount_and_type(amount_str)

        case currency_type
        when "JPYZ" then JpyzAmount.new(amount)
        when "XEM"  then NemAmount.new(amount)
        when "ZAIF" then ZaifAmount.new(amount)
        else OtherAmount.new(amount)
        end
      end

      private
        def split_amount_and_type(amount_str)
          m = amount_str.match(/(\d+(\.\d+)?)(\w+)/).to_a
          amount = m[1].include?(".") ? m[1].to_f : m[1].to_i
          currency_type = m[3]
          [amount, currency_type]
        end
    end
  end

  class Amount
    MIN_AMOUNT = 0
    attr_accessor :amount, :currency_type
    def initialize(amount)
      @amount = amount
    end

    def valuable?
      min_amount = self.class::MIN_AMOUNT
      @amount >= min_amount
    end
  end

  class ZaifAmount < Amount
    MIN_AMOUNT = 1
  end

  class NemAmount < Amount
    MIN_AMOUNT = 0.01
  end

  class JpyzAmount < Amount
    MIN_AMOUNT = 1
  end

  class OtherAmount < Amount; end
end
