require "pry"
# COMPLETE

def consolidate_cart(cart:[])
  # variables for later
  new_grocery_hash = {}
  # iterate over each item in the orignial cart
  cart.each do |item|
    # iterate over the k:v pairs in the original cart hash
    item.each do |food,data|
      # binding.pry
      # add the old items to the new hash
      if new_grocery_hash.member?(food) != true
        new_grocery_hash[food] = data
        # include a count of the new item
        data.store(:count, 1)
      else
        # incremement the count of an existing item
        new_grocery_hash[food][:count] = new_grocery_hash[food][:count] + 1
      end
    end
  end
  new_grocery_hash
end

# COMPLETE
def apply_coupons(cart:[], coupons:[])
  #binding.pry
  #### ADD EACH COUPON TO CART ####
  coupons.each do |i|
   # has the coupon already been applied to the cart?
    if cart.include?("#{i[:item]} W/COUPON") == false  
       # if the coupon applies to an item in the cart...
      if cart.has_key?(i[:item]) 
        # change the keys of the coupon to match the keys of the cart items
        i[:price] = i.delete :cost
        i[:count] = i.delete :num
        i[:clearance] = cart["#{i[:item]}"][:clearance]
        # add the couponed item to the cart
        cart["#{i[:item]} W/COUPON"] = i
        #### APPLY THE COUPON ####
        # create variables to assist with applying the coupon 
        cart_count = cart["#{i[:item]}"][:count].to_i
        num_coupon_covers = cart["#{i[:item]} W/COUPON"][:count].to_i
        cart["#{i[:item]} W/COUPON"][:count] = 0
        # are there a greater or equal num of covered items in the cart? if so...
        while cart_count >= num_coupon_covers && num_coupon_covers > 0 do
          # subtract the items covered from the total items in the cart
          cart["#{i[:item]}"][:count] = cart["#{i[:item]}"][:count].to_i - num_coupon_covers
          # set the couponed item to the "bundle" count
          cart["#{i[:item]} W/COUPON"][:count] = cart["#{i[:item]} W/COUPON"][:count].to_i + 1
          # update the values of our comparison variables for next loop
          cart_count = cart["#{i[:item]}"][:count].to_i
        end
      end
    end
  end
  cart
end



# COMPLETE
def apply_clearance(cart:[])
  # code here
  cart.each do |food, info|
    #binding.pry
    if info[:clearance] == true
      info[:price] = info[:price] - (info[:price] * 0.20) 
    end
  end
end



def checkout(cart: [], coupons: [])
  # initial total is 0
  total = 0
  # consolidate the cart
  con_cart = consolidate_cart(cart: cart)
  con_cart.each do |item, info|
    # adjust the price of items with a count greater than 1
    if info[:count] > 1
      info[:price] = info[:price].to_f * info[:count].to_f
    end 
    # total the current prices of each item, before coupons and discounts
    total = total + info[:price]
  end

  # apply coupons to the consolidated cart
  total_after_coupons = apply_coupons(cart: con_cart, coupons: coupons)
  total = 0
  total_after_coupons.each do |item, info|
    # add the prices of each item, after coupons have been applied
    if info[:count].to_i > 0 
      #binding.pry
      total = total + info[:price]
    end
  end
  # adjust price for clearance items
  total_after_clearance = apply_clearance(cart: total_after_coupons)
  total = 0
  # total up the prices, after clearance
  total_after_clearance.each do |item, info|
    if info[:count].to_i > 0 
      total = total + info[:price]
    end
  end

  # apply final discount for carts over $100
  if total > 100
    extra_discount = total * 0.10
    total = total - extra_discount
  end
  # return the final total 
  total
end
































