require 'rails_helper'

RSpec.describe 'merchant discount index', type: :feature do
  describe 'As a merchant' do
    before(:each) do
      
    end

    # 1: Merchant Bulk Discounts Index
    it '' do
      # When I visit my merchant dashboard
      visit

Then I see a link to view all my discounts
When I click this link
Then I am taken to my bulk discounts index page
Where I see all of my bulk discounts including their
percentage discount and quantity thresholds
And each bulk discount listed includes a link to its show page
    end
  end
end