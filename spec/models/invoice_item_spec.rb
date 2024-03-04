require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "Relationships" do
    it {should belong_to :item}
    it {should belong_to :invoice}
  end

  describe "Validations" do
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :unit_price}
    it {should validate_presence_of :status}
  end

  describe 'Enums' do
    it 'enums tests' do
      should define_enum_for(:status).with_values(["pending", "packaged", "shipped"])
    end
  end

  before do
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")
    @invoice_2 = create(:invoice, customer_id: @customer_2.id, created_at: "Wed, 21 Feb 2024 00:47:11.096539000 UTC +00:00")

    @merchant_1 = create(:merchant, name: "Amazon", status: 0)

    @item_1 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)
    @item_2 = create(:item, unit_price: 1, merchant_id: @merchant_1.id)

    @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 1300, status: 0)
    @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 3, unit_price: 2534, status: 0)

    @discount_3 = @merchant_1.discounts.create!(percent_discount: 50, quantity_threshold: 2)
  end

  describe "Instance Methods" do
    describe "#unit_price_to_dollars" do
      it "returns the unit price converted to dollars" do
        expect(@invoice_item_1.unit_price_to_dollars).to eq(13.00)
        expect(@invoice_item_2.unit_price_to_dollars).to eq(25.34)
      end
    end

    describe 'eligible_discount' do
      it 'returns the best discount this invoice_item is eligible for' do
        expect(@invoice_item_2.eligible_discount).to eq(@discount_3)
        expect(@invoice_item_1.eligible_discount).to eq(nil)
      end
    end
  end
end
