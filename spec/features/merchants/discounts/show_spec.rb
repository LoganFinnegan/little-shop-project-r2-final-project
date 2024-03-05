require 'rails_helper'

RSpec.describe 'discount show', type: :feature do
  describe 'As a merchant' do
    before(:each) do
      @cust_1 = create(:customer)
      @cust_2 = create(:customer)
      @cust_3 = create(:customer)
      @cust_4 = create(:customer)
      @cust_5 = create(:customer)
      @cust_6 = create(:customer)
      
      @invoice_1 = create(:invoice, customer_id: @cust_1.id)
      @invoice_2 = create(:invoice, customer_id: @cust_2.id)
      @invoice_3 = create(:invoice, customer_id: @cust_3.id)
      @invoice_4 = create(:invoice, customer_id: @cust_4.id)
      @invoice_5 = create(:invoice, customer_id: @cust_6.id, created_at: "Thu, 22 Feb 2024 22:05:45.453230000 UTC +00:00")
      @invoice_6 = create(:invoice, customer_id: @cust_5.id, created_at: "Wed, 21 Feb 2024 22:05:45.453230000 UTC +00:00")
      
      @trans_1 = create(:transaction, invoice_id: @invoice_1.id)
      @trans_2 = create(:transaction, invoice_id: @invoice_2.id)
      @trans_3 = create(:transaction, invoice_id: @invoice_3.id)
      @trans_4 = create(:transaction, invoice_id: @invoice_4.id)
      @trans_5 = create(:transaction, invoice_id: @invoice_5.id)
      @trans_6 = create(:transaction, invoice_id: @invoice_6.id)
      
      @merch_1 = create(:merchant, name: "Amazon") 
  
      @item_1 = create(:item, unit_price: 1, merchant_id: @merch_1.id)
  
      @discount_1 = @merch_1.discounts.create!(percent_discount: 20, quantity_threshold: 10)
      @discount_2 = @merch_1.discounts.create!(percent_discount: 10, quantity_threshold: 5)
      @discount_3 = @merch_1.discounts.create!(percent_discount: 50, quantity_threshold: 2)

  
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, unit_price: 1, quantity: 100, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_2.id, unit_price: 1, quantity: 80, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_3.id, unit_price: 1, quantity: 60, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_4.id, unit_price: 1, quantity: 50, status: 2)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_5.id, unit_price: 1, quantity: 40)
      create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_6.id, unit_price: 1, quantity: 5)
    end

    # 4: Merchant Bulk Discount Show
    it 'displays discount attributes' do
      # When I visit my bulk discount show page
      visit merchant_discount_path(@merch_1, @discount_1)
      # Then I see the bulk discount's quantity threshold and percentage discount
      within '.discount' do
        expect(page).to have_content(@discount_1.id)
        expect(page).to have_content(@discount_1.percent_discount)
        expect(page).to have_content(@discount_1.quantity_threshold)
      end
    end

    # 6: Merchant Invoice Show Page: Total Revenue and Discounted Revenue
    it "it displays pre and post discount revenue" do 
      # When I visit my merchant invoice show page
      visit merchant_invoice_path(@merch_1, @invoice_1)
      # Then I see the total revenue for my merchant from this invoice (not including discounts)
      within '.pre-discount-revenue' do
        expect(page).to have_content("Total Revenue: $1.0")
      end
      # And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation
      within '.post-discount-revenue' do
        expect(page).to have_content("Post Discount Revenue: $0.5")
      end
      # Note: We encourage you to use as much ActiveRecord as you can, but some Ruby is okay. Instead of a single query that sums the revenue of discounted items and the revenue of non-discounted items, we recommend creating a query to find the total discount amount, and then using Ruby to subtract that discount from the total revenue.
      
      # For an extra spicy challenge: try to find the total revenue of discounted and non-discounted items in one query! 
    end

    # 7: Merchant Invoice Show Page: Link to applied discounts
    it "links to discounts" do 
      # When I visit my merchant invoice show page
      visit merchant_invoice_path(@merch_1, @invoice_1)
      # Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)
      within "#item-#{@item_1.id}" do
        expect(page).to have_link("see discount")
        click_link("see discount")
      end

      expect(current_path).to eq(merchant_discount_path(@merch_1, @discount_3))
    end
  end
end