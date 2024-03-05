require 'rails_helper'

RSpec.describe 'Admin Index Show', type: :feature do
  describe 'As an Admin' do
    before(:each) do
      @customer_1 = create(:customer)

      @invoice_1 = create(:invoice, customer_id: @customer_1.id, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")

      @trans_1 = create(:transaction, invoice_id: @invoice_1.id)
      @trans_2 = create(:transaction, invoice_id: @invoice_1.id)
      @trans_3 = create(:transaction, invoice_id: @invoice_1.id)
      @trans_4 = create(:transaction, invoice_id: @invoice_1.id)
      @trans_5 = create(:transaction, invoice_id: @invoice_1.id)
      
      @merchant_1 = create(:merchant, name: "Amazon", status: 0) 
      @merchant_4 = create(:merchant, name: "Microsoft", status: 0) 

      @item_1 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
      @item_8 = create(:item, unit_price: 1, merchant_id: @merchant_4.id)

      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 1300, status: 0)
      @invoice_item_9 = create(:invoice_item, item_id: @item_8.id, invoice_id: @invoice_1.id, quantity: 4, unit_price: 5500, status: 2)
    end

    # User story 33. Admin Invoice Show Page
    it 'displays all information about that invoice, including the customer first and last name' do
      # As an admin, when I visit an admin invoice show page (/admin/invoices/:invoice_id)
      visit admin_invoice_path(@invoice_1.id)
      # Then I see information related to that invoice including:
      # Invoice id
      expect(page).to have_content("Invoice ##{@invoice_1.id}")
      # Invoice status
      expect(page).to have_content("Status: In Progress")
      # Invoice created_at date in the format "Monday, July 18, 2019"
      expect(page).to have_content("Created on: Wednesday, February 21, 2024")
      # Customer first and last name
      expect(page).to have_content("Customer: #{@customer_1.first_name} #{@customer_1.last_name}")
    end

    # User Story 34. Admin Invoice Show Page: Invoice Item Information
    it "displays all of the items on the invoice, with name, quantity and price, and Invoice item status" do
      # As an admin, When I visit an admin invoice show page (/admin/invoices/:invoice_id)
      visit admin_invoice_path(@invoice_1.id)
      # Then I see all of the items on the invoice including:
      expect(page).to have_content("Items on this invoice")
      within "#invoice_item-#{@invoice_item_1.id}" do
        # Item name
        expect(page).to have_content(@item_1.name)
        # The quantity of the item ordered
        expect(page).to have_content(@invoice_item_1.quantity)
        # The price the Item sold for
        expect(page).to have_content(@invoice_item_1.unit_price_to_dollars)
        # The Invoice Item status
        expect(page).to have_content(@invoice_item_1.status)
      end

      within "#invoice_item-#{@invoice_item_9.id}" do
        # Item name
        expect(page).to have_content(@item_8.name)
        # The quantity of the item ordered
        expect(page).to have_content(@invoice_item_9.quantity)
        # The price the Item sold for
        expect(page).to have_content(@invoice_item_9.unit_price_to_dollars)
        # The Invoice Item status
        expect(page).to have_content(@invoice_item_9.status)
      end
    end

    # User Story 35. Admin Invoice Show Page: Total Revenue
    it "displays the total revenue that will be generated from this invoice" do
      # As an admin, When I visit an admin invoice show page (/admin/invoices/:invoice_id)
      visit admin_invoice_path(@invoice_1)
      # Then I see the total revenue that will be generated from this invoice.
      within "#invoice_revenue" do
        expect(page).to have_content("Total Revenue: $233.00")
      end
    end

    #User Story 36. Admin Invoice Show Page: Update Invoice Status
    it "displays a select field for" do
      # As an admin, When I visit an admin invoice show page (/admin/invoices/:invoice_id)
      visit admin_invoice_path(@invoice_1)
      within "#invoice_status" do
        # I see the invoice status is a select field
        expect(page).to have_select("status")
        # And I see that the invoice's current status is selected
        expect(page).to have_content("In Progress")
        # When I click this select field,
        expect(page).to have_select("status", with_options: ["In Progress", "Cancelled", "Completed"])
        # Then I can select a new status for the Invoice,
        select("Cancelled", from: "status")
        # And next to the select field I see a button to "Update Invoice Status"
        # When I click this button
        click_button("Update Invoice")
        # I am taken back to the admin invoice show page
        expect(current_path).to eq(admin_invoice_path(@invoice_1))
        # And I see that my Invoice's status has now been updated
        expect(page).to have_content("Cancelled")
      end
    end

    #8 Admin Invoice Show Page: Total Revenue and Discounted Revenue
    it "can display total rev with and without discounts" do 

      cust_1 = create(:customer)
      cust_2 = create(:customer)
      cust_3 = create(:customer)
      cust_4 = create(:customer)
      cust_5 = create(:customer)
      cust_6 = create(:customer)
      
      invoice_1 = create(:invoice, customer_id: cust_1.id)
      invoice_2 = create(:invoice, customer_id: cust_2.id)
      invoice_3 = create(:invoice, customer_id: cust_3.id)
      invoice_4 = create(:invoice, customer_id: cust_4.id)
      invoice_5 = create(:invoice, customer_id: cust_6.id, created_at: "Thu, 22 Feb 2024 22:05:45.453230000 UTC +00:00")
      invoice_6 = create(:invoice, customer_id: cust_5.id, created_at: "Wed, 21 Feb 2024 22:05:45.453230000 UTC +00:00")
      
      trans_1 = create(:transaction, invoice_id: invoice_1.id)
      trans_2 = create(:transaction, invoice_id: invoice_2.id)
      trans_3 = create(:transaction, invoice_id: invoice_3.id)
      trans_4 = create(:transaction, invoice_id: invoice_4.id)
      trans_5 = create(:transaction, invoice_id: invoice_5.id)
      trans_6 = create(:transaction, invoice_id: invoice_6.id)
      
      merch_1 = create(:merchant, name: "Amazon") 
  
      item_1 = create(:item, unit_price: 1, merchant_id: merch_1.id)
  
      discount_1 = merch_1.discounts.create!(percent_discount: 20, quantity_threshold: 10)
      discount_2 = merch_1.discounts.create!(percent_discount: 10, quantity_threshold: 5)
      discount_3 = merch_1.discounts.create!(percent_discount: 50, quantity_threshold: 2)

  
      create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, unit_price: 1, quantity: 100, status: 2)
      create(:invoice_item, item_id: item_1.id, invoice_id: invoice_2.id, unit_price: 1, quantity: 80, status: 2)
      create(:invoice_item, item_id: item_1.id, invoice_id: invoice_3.id, unit_price: 1, quantity: 60, status: 2)
      create(:invoice_item, item_id: item_1.id, invoice_id: invoice_4.id, unit_price: 1, quantity: 50, status: 2)
      create(:invoice_item, item_id: item_1.id, invoice_id: invoice_5.id, unit_price: 1, quantity: 40)
      create(:invoice_item, item_id: item_1.id, invoice_id: invoice_6.id, unit_price: 1, quantity: 5)

      # When I visit an admin invoice show page
      visit admin_invoice_path(invoice_1)
      # Then I see the total revenue from this invoice (not including discounts)
      expect(page).to have_content("Total Revenue: $1.00")
      # And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation
      expect(page).to have_content("Post Disocunt Revenue: $0.50")
    end
  end
end