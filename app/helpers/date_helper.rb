module DateHelper

  # def format_date(date)
  #   date.to_time.in_time_zone.strftime("%d-%B-%Y")
  # end

  def long_date(date)
    date.to_time.in_time_zone.strftime("%d %B, %Y %H:%M:%S %p")
  end

  def normal_date(date)
    date.to_time.in_time_zone.strftime("%d %B, %Y %H:%M:%S")
  end

  def format_date(date)
    date.to_time.in_time_zone.strftime("%d %B, %Y")
  end

  def invoice_date(date)
    date.to_time.in_time_zone.strftime("%d %b, %Y")
  end

  def medium_date(date)
  	date.to_time.in_time_zone.strftime("%d-%b-%Y %H:%M")
  end

  def display_hour(date)
  	date.to_time.in_time_zone.strftime("%H:%M")
  end

  def graph_date(date)
    #code
  end

  def display_day(date)
  	date.to_time.in_time_zone.strftime("%A, %B %d %Y")
  end

  def display_month(date)
  	date.to_time.in_time_zone.strftime("%B")
  end
end
