class Invoice < ApplicationRecord
  validates :status, presence: true
  
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: ["in progress", "cancelled", "completed"]
  
  # class method for checking status of invoice
  def self.invoices_with_unshipped_items
    Invoice.select("invoices.*").joins(:invoice_items).where("invoice_items.status != 2")
  end

  def self.oldest_to_newest
    Invoice.order("invoices.created_at")
  end

  def self.invoices_with_unshipped_items_oldest_to_newest
    Invoice.invoices_with_unshipped_items.oldest_to_newest
  end

  def total_revenue_dollars
    invoice_items.sum("quantity * unit_price")/100.00
  end
  
  def total_revenue
    self.invoice_items.sum("unit_price * quantity")
  end

  def disc_rev
    total = 0
    invoice_items.each do |ii|  
      discount = ii.item.merchant.discounts
        .where("quantity_threshold <= ?", ii.quantity)
        .order(percent_discount: :desc)
        .first
        
      if discount && discount.percent_discount < 100
        total += calc_ii_total(ii) * calc_discount(discount)
      elsif discount && discount.percent_discount >= 100
        total += 0
      else
        total += calc_ii_total(ii)
      end
    end
    total
  end

  def calc_ii_total(invoice_item)
    invoice_item.unit_price * invoice_item.quantity
  end

  def calc_discount(discount)
    discount.percent_discount/100
  end

  def cents_to_dollars
    disc_rev/100
  end
end

