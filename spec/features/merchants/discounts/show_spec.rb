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

    # 5: Merchant Bulk Discount Edit
    it "can edit a discount" do 
      # When I visit my bulk discount show page
      visit merchant_discount_path(@merch_1, @discount_1)

      within '.discount' do
        # Then I see a link to edit the bulk discount
        expect(page).to have_button("edit discount")
        # When I click this link
        click_button("edit discount")
      end
      # Then I am taken to a new page with a form to edit the discount
      expect(current_path).to eq(edit_merchant_discount_path(@merch_1, @discount_1))
      # And I see that the discounts current attributes are pre-poluated in the form
      expect(page).to have_field("percent_discount")
      expect(page).to have_field("quantity_threshold")
      # When I change any/all of the information and click submit
      fill_in 'percent_discount', with: '12'
      fill_in 'quantity_threshold', with: '10'
      
      click_button("submit")
      # Then I am redirected to the bulk discount's show page
      expect(current_path).to eq(merchant_discount_path(@merch_1, @discount_1))
      # And I see that the discount's attributes have been updated
      within '.discount' do
        save_and_open_page
        expect(page).to have_content(@discount_1.id)
        expect(page).to have_content("Discount: 12")
        expect(page).to have_content("Threshold: 10")
      end
    end
  end
end