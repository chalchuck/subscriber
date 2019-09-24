module NavigationHelper

  def activate_business
    (current_page?([@current_business]) ? "active" : "")
  end

  def activate_plan
    (current_page?([@current_business, :plans]) ? "active" : "")
  end

  def activate_coupon
    (current_page?([@current_business, :coupons]) ? "active" : "")
  end

  def activate_customer
    (current_page?([@current_business, :customers]) ? "active" : "")
  end

  def activate_subscription
    (current_page?([@current_business, :subscriptions]) ? "active" : "")
  end

  def activate_invoice
    (current_page?([@current_business, :invoices]) ? "active" : "")
  end

  def activate_transaction
    (current_page?([:transactions, @current_business]) ? "active" : "")
  end

end
