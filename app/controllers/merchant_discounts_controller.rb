class MerchantDiscountsController < ApplicationController
  def index
    @merch = Merchant.find(params[:merchant_id])
  end
  
  def show 
    @merch = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def new
    @merch = Merchant.find(params[:merchant_id])
  end

  
  def create
    merch = Merchant.find(params[:merchant_id])
    merch.discounts.create(discount_params)
    redirect_to merchant_discounts_path(merch)
  end

  def edit 
    @merch = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end
  
  def update
    merch = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:id])
    discount.update(discount_params)
    redirect_to merchant_discount_path(merch, discount)
  end
  
  def destroy 
    merch = Merchant.find(params[:merchant_id])
    Discount.find(params[:id]).destroy
    redirect_to merchant_discounts_path(merch)
  end

  private

  def discount_params
    params.permit(:percent_discount, :quantity_threshold)
  end
end