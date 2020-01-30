def find_item_by_name_in_collection(name, collection)

  i = 0
  while collection[i] do 
    return collection[i] if collection[i][:item] == name

    i += 1
  end
  nil
end

def consolidate_cart(cart)

  cart_consolidated = []

  i = 0
  while cart[i] do 
    item_name = find_item_by_name_in_collection(cart[i][:item], cart_consolidated)
    
    if item_name
      item_name[:count] += 1
    else
      item_name = {
        :item => cart[i][:item],
        :price => cart[i][:price],
        :clearance => cart[i][:clearance],
        :count => 1
      }
      cart_consolidated << item_name
    end

  i += 1
  end
  
  cart_consolidated
end

def apply_coupons(cart, coupons)

  i = 0
  while coupons[i] do 
    cart_item = find_item_by_name_in_collection(coupons[i][:item], cart) 
    coupon_item_name = "#{coupons[i][:item]} W/COUPON"
    cart_item_w_coupon = find_item_by_name_in_collection(coupon_item_name, cart)

    if cart_item && cart_item[:count] >= coupons[i][:num]
      if cart_item_w_coupon
        cart_item_w_coupon[:count] += coupons[i][:num]
        cart_item[:count] -= coupons[i][:num]
      else
        new_price = coupons[i][:cost] / coupons[i][:num]

        cart_item_w_coupon = {
          :item => coupon_item_name,
          :price => new_price,
          :count => coupons[i][:num],
          :clearance => cart_item[:clearance]
        }

        cart << cart_item_w_coupon
        cart_item[:count] -= coupons[i][:num]
      end
    end
  i += 1
  end
  cart
end

def apply_clearance(cart)

  i = 0
  while cart[i] do
    if cart[i][:clearance]
      cart[i][:price] = (cart[i][:price] - (cart[i][:price] * 0.20)).round(2)
    end

    i += 1
  end
  cart
end

def checkout(cart, coupons)

  new_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(new_cart, coupons)
  final_cart = apply_clearance(couponed_cart)

  total = 0
  i = 0
  while final_cart[i] do
    total += final_cart[i][:price] * final_cart[i][:count]
    
    i += 1
  end
  
  if total >= 100
    total = total - (total * 0.1)
  end

  total
end
