# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# Customers:
logan     = Customer.create!(first_name: 'Logan', last_name: 'Rogan')
# Merchants:
amazon    = Merchant.create!(name: 'Amazon', status: 0)
# Invoices:
invoice1  = Invoice.create!(status: 1, customer_id: logan.id, created_at: 'Fri, 08 Dec 2020 14:42:18 UTC +00:00')
invoice2  = Invoice.create!(status: 1, customer_id: logan.id, created_at: 'Sat, 16 Jan 2021 14:42:18 UTC +00:00')
invoice3  = Invoice.create!(status: 1, customer_id: logan.id, created_at: 'Sun, 17 Jan 2021 14:42:18 UTC +00:00')
# Transactions:
tx1 = invoice1.transactions.create!(result: "success", credit_card_number: 010001001022, credit_card_expiration_date: 20251001)
tx2 = invoice2.transactions.create!(result: "success", credit_card_number: 010001005555, credit_card_expiration_date: 20220101)
tx3 = invoice3.transactions.create!(result: "success", credit_card_number: 010001005551, credit_card_expiration_date: 20220101)
# Items:
backpack  = amazon.items.create!(name: 'Camo Backpack', description: 'Double Zip Backpack', unit_price: 5, status: 0)
radio     = amazon.items.create!(name: 'Retro Radio', description: 'Twist and Turn to your fav jams', unit_price: 10, status: 0)
brush     = amazon.items.create!(name: 'Boar Brush', description: 'Hair Brush', unit_price: 12, status: 0)
# InvoiceItems:
invitm4   = InvoiceItem.create!(status: 2, quantity: 50, unit_price: 5, invoice_id: invoice3.id, item_id: backpack.id)
invitm5   = InvoiceItem.create!(status: 1, quantity: 100, unit_price: 10, invoice_id: invoice3.id, item_id: radio.id)
invitm6   = InvoiceItem.create!(status: 1, quantity: 20, unit_price: 10, invoice_id: invoice3.id, item_id: brush.id)
# Discounts:
discount_1 = Discount.create!(percent_discount: 50, quantity_threshold: 2, merchant_id: amazon.id)

# invoice 3 
# total rev 1450 cents 