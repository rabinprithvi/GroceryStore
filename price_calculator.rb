class PriceCalculator
  require_relative 'price_list'
  attr_accessor :items

  def initialize
    puts 'Please enter all the items purchased separated by a comma'
    input = gets.chomp
    @items = get_items_and_quantiy input
    calculate_total
  end

  private

  def get_items_and_quantiy input
    input = input.delete(' ').split(',').map{|e| e.downcase}
    array = Array.new
    input.each do |item|
      hash = Hash.new
      hash[item] = input.count(item)
      array << hash
    end
    return array.uniq
  end

  def calculate_total
    prices =  PriceList::PRICE
    total_price = 0
    savings = 0
    puts "Item\t\tQuantity\tPrice"
    puts "=============================================="
    @items.each do |item|
     item_name = item.keys[0]
     item_qty = item.values[0]

     if prices.has_key?(item_name)
       item_cost = calculate_cost(item_name,item_qty,prices[item_name])
       total_price = total_price + item_cost
       savings = savings + calculate_savings(item_qty,item_cost,prices[item_name])
       puts "#{item_name.capitalize}\t\t#{item_qty}\t\t$#{item_cost} "
     end
   end
   puts "\n\nTotal price: $#{total_price}"
   puts "You saved $#{savings} today."
  end

  def calculate_cost(item_name,item_qty,item_cost)
    offer_qty = item_cost.keys.map(&:to_i).max
    item_purchased_qty = item_qty
    offer_cost = 0
    standard_price = item_cost["1"]
    while item_purchased_qty >= offer_qty
      cost = item_cost[offer_qty.to_s]
      offer_cost = offer_cost +  cost
      item_purchased_qty =   item_purchased_qty -  offer_qty
    end
    normal_cost = item_purchased_qty * standard_price
    offer_cost + normal_cost
  end
end

def calculate_savings(item_qty,offer_cost,item_cost)
  standard_price = item_cost["1"]
  standard_cost = item_qty * standard_price
  (standard_cost - offer_cost).round(2)
end

pc = PriceCalculator.new
