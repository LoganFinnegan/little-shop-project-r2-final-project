require 'rails_helper'

RSpec.describe Item, type: :model do
  before(:each) do 
    @cust_1 = create(:customer)
     
    @merch_2 = create(:merchant) 

    @test_item_1 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "1", status: 1)
    @test_item_2 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "2")
    @test_item_3 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "3")
    @test_item_4 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "4")
    @test_item_5 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "5")
    @test_item_6 = create(:item, unit_price: 10, merchant_id: @merch_2.id, name: "6")

    @test_invoice_1 = create(:invoice, customer_id: @cust_1.id)
    @test_invoice_2 = create(:invoice, customer_id: @cust_1.id)
    @test_invoice_3 = create(:invoice, customer_id: @cust_1.id)
    @test_invoice_4 = create(:invoice, customer_id: @cust_1.id)
    @test_invoice_5 = create(:invoice, customer_id: @cust_1.id)
    @test_invoice_6 = create(:invoice, customer_id: @cust_1.id)

    @test_trans_1 = create(:transaction, invoice_id: @test_invoice_1.id)
    @test_trans_2 = create(:transaction, invoice_id: @test_invoice_2.id)
    @test_trans_3 = create(:transaction, invoice_id: @test_invoice_3.id)
    @test_trans_4 = create(:transaction, invoice_id: @test_invoice_4.id)
    @test_trans_5 = create(:transaction, invoice_id: @test_invoice_5.id)
    @test_trans_6 = create(:transaction, invoice_id: @test_invoice_6.id)

    @ii_1 = create(:invoice_item, item_id: @test_item_1.id, invoice_id: @test_invoice_1.id, unit_price: 1, quantity: 400)
    create(:invoice_item, item_id: @test_item_2.id, invoice_id: @test_invoice_2.id, unit_price: 1, quantity: 300)
    create(:invoice_item, item_id: @test_item_3.id, invoice_id: @test_invoice_3.id, unit_price: 1, quantity: 200)
    create(:invoice_item, item_id: @test_item_4.id, invoice_id: @test_invoice_4.id, unit_price: 1, quantity: 100)
    create(:invoice_item, item_id: @test_item_5.id, invoice_id: @test_invoice_5.id, unit_price: 1, quantity: 1)
    create(:invoice_item, item_id: @test_item_6.id, invoice_id: @test_invoice_6.id, unit_price: 1, quantity: 500)

    @discount_3 = @merch_2.discounts.create!(percent_discount: 50, quantity_threshold: 2)
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'Relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:discounts).through(:merchant) }
  end

  describe 'Enums' do
    it 'enums tests' do
      should define_enum_for(:status).with_values(["disabled", "enabled"])
    end
  end

  describe "class methods" do 
    it ".top_five_items" do 
      expect(Item.top_five_items).to eq([@test_item_6, @test_item_1, @test_item_2, @test_item_3, @test_item_4])
    end

    it ".enabled_items" do 
      expect(Item.enabled_items).to eq([@test_item_1])
    end

    it ".disabled_items" do 
      expect(Item.disabled_items).to eq([@test_item_2, @test_item_3, @test_item_4, @test_item_5, @test_item_6])
    end
  end

  describe '#instance method' do
    it '#date_with_most_sales' do
      expect(@test_item_1.date_with_most_sales.strftime('%A, %B, %d, %Y')).to eq(@test_invoice_1.created_at.strftime('%A, %B, %d, %Y'))
    end

    it '#current_invoice_item' do
      expect(@test_item_1.current_invoice_item(@test_item_1, @test_invoice_1)).to eq(@ii_1)
    end

    it "#has_discount_and_meets_threshold(item, invoice)" do 
      expect(@test_item_1.has_discount_and_meets_threshold(@test_item_1, @test_invoice_1)).to eq(true)
      expect(@test_item_5.has_discount_and_meets_threshold(@test_item_5, @test_invoice_5)).to eq(false)
    end
  end
end
