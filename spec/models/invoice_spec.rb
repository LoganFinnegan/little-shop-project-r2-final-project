require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :status }
  end

  describe 'Relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:discounts).through(:merchants) }
  end

  describe 'Enums' do
    it 'enums tests' do
      should define_enum_for(:status).with_values(["in progress", "cancelled", "completed"])
    end
  end

  before(:each) do
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    @customer_6 = create(:customer)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id)
    @invoice_2 = create(:invoice, customer_id: @customer_2.id)
    @invoice_3 = create(:invoice, customer_id: @customer_3.id)
    @invoice_4 = create(:invoice, customer_id: @customer_4.id)
    @invoice_5 = create(:invoice, customer_id: @customer_5.id)
    @invoice_6 = create(:invoice, customer_id: @customer_6.id)
    @invoice_7 = create(:invoice, customer_id: @customer_5.id, status: 0, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_8 = create(:invoice, customer_id: @customer_5.id, status: 0, created_at: "Tues, 20 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_9 = create(:invoice, customer_id: @customer_5.id, status: 0, created_at: "Mon, 19 Feb 2024 00:47:11.096539000 UTC +00:00")

    @trans_1 = create(:transaction, invoice_id: @invoice_1.id)
    @trans_2 = create(:transaction, invoice_id: @invoice_1.id)
    @trans_3 = create(:transaction, invoice_id: @invoice_1.id)
    @trans_4 = create(:transaction, invoice_id: @invoice_1.id)
    @trans_5 = create(:transaction, invoice_id: @invoice_1.id)
    @trans_6 = create(:transaction, invoice_id: @invoice_2.id)
    @trans_7 = create(:transaction, invoice_id: @invoice_2.id)
    @trans_8 = create(:transaction, invoice_id: @invoice_2.id)
    @trans_9 = create(:transaction, invoice_id: @invoice_2.id)
    @trans_10 = create(:transaction, invoice_id: @invoice_3.id)
    @trans_11 = create(:transaction, invoice_id: @invoice_3.id)
    @trans_12 = create(:transaction, invoice_id: @invoice_3.id)
    @trans_13 = create(:transaction, invoice_id: @invoice_4.id)
    @trans_14 = create(:transaction, invoice_id: @invoice_4.id)
    @trans_15 = create(:transaction, invoice_id: @invoice_5.id)
    
    @merchant_1 = create(:merchant, name: "Amazon") 

    @item_1 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_2 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_3 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_4 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_5 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_6 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)

    @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 1300, status: 0)
    @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: 1300, status: 0)
    @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_3.id, quantity: 1, unit_price: 1300, status: 1)
    @invoice_item_4 = create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_4.id, quantity: 1, unit_price: 1300, status: 2)
    @invoice_item_5 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_5.id, quantity: 1, unit_price: 1300, status: 2)
    @invoice_item_6 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_7.id, quantity: 1, unit_price: 1300, status: 0)
    @invoice_item_7 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_8.id, quantity: 1, unit_price: 1300, status: 0)
    @invoice_item_8 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_9.id, quantity: 1, unit_price: 1300, status: 0)
    @invoice_item_9 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_1.id, quantity: 4, unit_price: 5500, status: 2)
  end

  describe 'Class Methods' do
    describe '#invoices_with_unshipped_items' do
      it 'will return all invoices that do not have a status of completed' do
        expect(Invoice.invoices_with_unshipped_items).to eq([@invoice_1, @invoice_2, @invoice_3, @invoice_7, @invoice_8, @invoice_9])
      end
    end

    describe '#oldest_to_newest' do
      it 'will return the invoices with the oldest created at dates first' do

        expect(Invoice.oldest_to_newest[0]).to eq(@invoice_9)
        expect(Invoice.oldest_to_newest[1]).to eq(@invoice_8)
        expect(Invoice.oldest_to_newest[2]).to eq(@invoice_7)
      end
    end

    describe '#invoices_with_unshipped_items_oldest_to_newest' do
      it 'will return the invoices with the oldest created at dates first if they have unshipped items' do
        expect(Invoice.invoices_with_unshipped_items_oldest_to_newest).to eq([@invoice_9, @invoice_8, @invoice_7, @invoice_1, @invoice_2, @invoice_3])
      end
    end

    describe '#total_revenue' do
      it "returns the total revenue of the invoice item" do
        expect(@invoice_6.total_revenue).to eq(0)
        expect(@invoice_1.total_revenue).to eq(23300)
      end
    end
  end

  describe "#Instance Methods" do
    describe "#total_revenue_dollars" do
      it "returns the correct revenue that an invoice will generate" do
        expect(@invoice_1.total_revenue_dollars).to eq(233.00)
        expect(@invoice_2.total_revenue_dollars).to eq(13.00)
      end
    end

    describe '#disc_rev' do
      it 'calculates the revenue after discounts' do
        customer_1 = create(:customer)
      
        invoice_1 = create(:invoice, customer_id: customer_1.id, status: 0, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")
        invoice_2 = create(:invoice, customer_id: customer_1.id, status: 0, created_at: "Tues, 20 Feb 2024 00:47:11.096539000 UTC +00:00")
        invoice_3 = create(:invoice, customer_id: customer_1.id, status: 0, created_at: "Mon, 19 Feb 2024 00:47:11.096539000 UTC +00:00")

        trans_1 = create(:transaction, invoice_id: invoice_1.id)
        trans_2 = create(:transaction, invoice_id: invoice_2.id)
        trans_3 = create(:transaction, invoice_id: invoice_3.id)
        
        merchant_1 = create(:merchant, name: "Amazon") 

        item_1 = create(:item, unit_price: 1, merchant_id: merchant_1.id)
        item_2 = create(:item, unit_price: 1, merchant_id: merchant_1.id)
        item_3 = create(:item, unit_price: 1, merchant_id: merchant_1.id)
        item_4 = create(:item, unit_price: 1, merchant_id: merchant_1.id)
        item_5 = create(:item, unit_price: 1, merchant_id: merchant_1.id)

        invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 1300, status: 0)
        invoice_item_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, quantity: 1, unit_price: 1300, status: 0)
        invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, quantity: 1, unit_price: 1300, status: 1)
        invoice_item_4 = create(:invoice_item, item_id: item_4.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 1300, status: 2)
        invoice_item_5 = create(:invoice_item, item_id: item_5.id, invoice_id: invoice_2.id, quantity: 1, unit_price: 1300, status: 2)
        invoice_item_6 = create(:invoice_item, item_id: item_5.id, invoice_id: invoice_3.id, quantity: 1, unit_price: 1300, status: 0)
        invoice_item_7 = create(:invoice_item, item_id: item_5.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 1300, status: 0)
        invoice_item_8 = create(:invoice_item, item_id: item_5.id, invoice_id: invoice_2.id, quantity: 1, unit_price: 1300, status: 0)
        invoice_item_9 = create(:invoice_item, item_id: item_5.id, invoice_id: invoice_3.id, quantity: 4, unit_price: 1000, status: 2)

        discount_1 = merchant_1.discounts.create!(percent_discount: 50, quantity_threshold: 2)
        
        expect(invoice_3.total_revenue).to eq(6600)
        expect(invoice_3.items).to eq([item_3, item_5, item_5])
        expect(invoice_3.disc_rev).to eq(4600)
        
        expect(invoice_2.total_revenue).to eq(3900)
        expect(invoice_2.disc_rev).to eq(3900)
        
        discount_2 = merchant_1.discounts.create!(percent_discount: 100, quantity_threshold: 2)
        
        expect(invoice_3.total_revenue).to eq(6600)
        expect(invoice_3.disc_rev).to eq(2600)
      end
    end

    describe '#cents_to_dollars' do
      it "converts cents to dollars" do 
        expect(@invoice_1.cents_to_dollars).to eq(233)
        expect(@invoice_2.cents_to_dollars).to eq(13)
      end
    end
  end
end
