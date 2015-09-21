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
  #binding.pry
  new_grocery_hash
  # final_grocery_hash = {}
  # final_grocery_hash[:cart] = new_grocery_hash
  # final_grocery_hash
end

# COMPLETE
def apply_coupons(cart:[], coupons:[])
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
  # code here
  consolidate_cart(cart)


end