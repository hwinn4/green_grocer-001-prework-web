require "pry"

# method 1: consolidate_cart
# complete
def consolidate_cart(cart: [])
  cart_keys = {}

  # make a hash to count the frequency of foods in the cart
  cart.each do |i|
    i.each do |f,deets|
      if cart_keys.include?(f) == false 
        cart_keys[f] = 1
      else
        cart_keys[f] = cart_keys[f] + 1
      end
    end
  end

  # use cart_keys to assign a count to all foods 
  cart_keys.each do |food,count|
    if count > 1
      #binding.pry
      cart.each do |i|
        i.each do |k,v|
          if k == food
            v[:count] = count
          end
        end
      end
    else
      cart.each do |item|
        item.each do |fd,info|
          if info.keys.include?(:count) == false
            info[:count] = 1
          end
        end
      end
    end
  end

  # make a new hash that lists each food item (including its count) only once
  cart_rehashed = {}
  cart.each do |food_item|
    food_item.each do |name,stats|
      if cart_rehashed.include?(stats) == false
        cart_rehashed[name] = stats
      end
    end
  end
  #binding.pry
  cart_rehashed
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
  checkout_total = 0
  if cart.length >= 1
    con_cart = consolidate_cart(cart:cart)
    cart_with_coupons = apply_coupons(cart:con_cart,coupons:[])
    cart_after_clearance = apply_clearance(cart: cart_with_coupons)
    cart_after_clearance.each do |food, info|
      checkout_total = checkout_total + info[:price]
    end
  end
  if checkout_total > 100
    checkout_total = checkout_total - (checkout_total * 0.10)
  end
  checkout_total
end

























