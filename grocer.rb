require "pry"

# method 1: consolidate_cart
# COMPLETE
def consolidate_cart(cart:[])
  # variables for later
  new_grocery_hash = {}
  # iterate over each item in the orignial cart
  cart.each do |item|
    # iterate over the k:v pairs in the original cart hash
    item.each do |food,data|
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


# method 2: apply_coupons
def apply_coupons(cart:[], coupons: [])
  # .dup makes a shallow copy of an object
    cart.dup.each do |food, info|
      coupons.dup.each do |coupon|
        # do the following, as long as there are items in the cart that match the coupon
        if food == coupon[:item] && info[:count] >= coupon[:num]
          cart["#{coupon[:item]} W/COUPON"] = coupon
          cart["#{coupon[:item]} W/COUPON"][:price] = coupon[:cost]
          cart["#{coupon[:item]} W/COUPON"][:clearance] = cart["#{coupon[:item]}"][:clearance]
          # does the coupon cover the exact number of items?
          if food == coupon[:item] && info[:count] == coupon[:num]
            #cart["#{coupon[:item]} W/COUPON"][:count] = coupon[:num] / cart["#{coupon[:item]}"][:count]
            cart["#{coupon[:item]} W/COUPON"][:count] = 1
            cart["#{coupon[:item]}"][:count] = cart["#{coupon[:item]}"][:count] - coupon[:num]
          # or does the cart have more items than the coupon covers?
          elsif food == coupon[:item] && info[:count] > coupon[:num]
            cart["#{coupon[:item]} W/COUPON"][:count] = 0
            while cart["#{coupon[:item]}"][:count] > coupon[:num]
              cart["#{coupon[:item]} W/COUPON"][:count] = cart["#{coupon[:item]} W/COUPON"][:count] + 1
              cart["#{coupon[:item]}"][:count] = cart["#{coupon[:item]}"][:count] - coupon[:num]
            end
          end
        end
      end
    end
  cart
end

# method 3: apply_clearance
# take 20% off of clearance items
def apply_clearance(cart: [])
  cart.each do |food, info|
      #binding.pry
      if info[:clearance] == true
        info[:price] = info[:price] - (info[:price] * 0.20)
      end
  end
end

# method 4: checkout
def checkout(cart:[],coupons:[])
  
  #if cart.length >= 1
    con_cart = consolidate_cart(cart:cart)
    cart_with_coupons = apply_coupons(cart:con_cart,coupons:coupons)
    cart_after_clearance = apply_clearance(cart: cart_with_coupons)
    checkout_total = 0
    cart_after_clearance.each do |food, info|
      checkout_total += info[:price] * info[:count]
    end
  #end
  if checkout_total > 100
    checkout_total = checkout_total - (checkout_total * 0.10)
  end
  checkout_total
end

























