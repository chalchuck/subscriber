module CurrencyHelper
  def to_ksh(amount)
    if amount.to_i < 0
      number_to_currency(amount.abs, precision: 2, format: "Ksh -%n")
    elsif amount.to_i >= 0
      number_to_currency(amount, precision: 2, unit: "Ksh ")
    end
  end
end
