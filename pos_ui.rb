require 'active_record'
require './lib/cashier'
require './lib/customer'
require './lib/product'
require './lib/purchase'
require './lib/status'
require './lib/trunk'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration['development']
ActiveRecord::Base.establish_connection(development_configuration)

def enter_store
  clear

  puts "STORE FRONT"
  puts "1: manager, 2: customer, x: leave store"
  case gets.chomp
  when '1'
    store_manager
  when '2'
    customer_login
  when 'x'
    puts "goodbye"
  else
    puts "invalid choice"
    enter_store
  end
end


# STORE MANAGER
def store_manager
  clear

  puts "STORE MANAGER"
  choice = nil
  until choice == 'x'
    puts "1: add product, 2: add cashier, 3: add status, x: store front"
    case gets.chomp
    when '1'
      add_product
    when '2'
      add_cashier
    when '3'
      add_status
    when 'x'
      enter_store
    else
      puts "invalid choice"
    end
  end
end

def add_product
  puts "\n Enter the name of the product:"
  product_name = gets.chomp
  puts "How many to add?"
  product_quantity = gets.chomp.to_i
  puts "What is the price?"
  product_price = gets.chomp.to_f
  product_quantity.times do
    status = Status.find_by(:name => "In Stock")
    new_product = Product.new(:name => product_name, :price => product_price, :status_id => status.id)
    new_product.save
  end
  puts "#{product_name} saved."
  add_another("add_product")
end

def add_cashier
  puts "\n Enter the name of the cashier:"
  cashier_name = gets.chomp
  new_cashier = Cashier.new(:name => cashier_name)
  new_cashier.save
  puts "\n #{cashier_name} added."
  add_another("add_cashier")
end

def add_status
  puts "\n Enter the different status states, | between each"
  status_states = gets.chomp.split('|')
  status_states.each do |status|
    new_status = Status.new(:name => status)
    new_status.save
  end
  puts "Status states have been added."
end

def add_another(method_name)
  puts "Would you like to add another (y/n)?"
  user_choice = gets.chomp
  if user_choice == 'y'
    method(method_name).call
  else
    store_manager
  end
end

#CUSTOMER MENU

# @current_customer
@cart = []

def customer_login
  puts "Are you a new customer (y/n)"
  case gets.chomp
  when 'y'
    puts "What is your name?"
    customer_name = gets.chomp
    new_customer = Customer.new(:name => customer_name)
    new_customer.save
    @current_customer = Customer.where(name: new_customer.name)
  else
    puts "What is your name?"
    customer_name = gets.chomp
    selected_customer = Customer.where(name: customer_name)
    @current_customer = selected_customer
  end
  customer_menu
end

def customer_menu
  clear
  #@current_customer.pluck(:id)
  choice = nil
  until choice == 'x'
    puts "1: Shop for items, 2: Checkout, x: Exit"
    case gets.chomp
    when '1'
      shopping
    when '2'
      checkout
    when 'x'
      enter_store
    else
      puts "Invalid choice"
    end
  end
end

def shopping
  unique_products = Product.select(:name).distinct
  unique_products.each_with_index do |item, index|
    qty = Product.where(name: item.name, status_id: list_product_by_status("In Stock")).count
    puts "#{index + 1}: #{item.name} (#{qty})"
  end
  puts "Select the items you wish to purchase"
  index_selected = gets.chomp.to_i - 1
  qty = Product.where(name: unique_products[index_selected].name).count
  puts "How many #{unique_products[index_selected].name} do you want to buy? #{qty} available."
  qty_selected = gets.chomp.to_i
  qty_selected.times do
    prod = Product.where(name: unique_products[index_selected].name, status_id: list_product_by_status("In Stock")).pop
    prod.update(customer_id: @current_customer.pluck(:id).first, status_id: list_product_by_status("In Cart"))
  end

  puts "Checkout? (y/n)"
  case gets.chomp
  when 'y'
    checkout
  else
    clear
    shopping
  end
end

def list_product_by_status(status)
  Status.where(name: status).pluck(:id)
end

def checkout
  puts "Please select a cashier for your purchase:"
  Cashier.all.each_with_index do |cashier, index|
    puts "#{index+1}. #{cashier.name}"
  end
  cashier_choice = gets.chomp.to_i
  total_cost=0
  @current_cashier = Cashier.where(id: Cashier.all[cashier_choice-1])
  new_purchase = Purchase.new(:customer_id => @current_customer.pluck(:id).first, :cashier_id => @current_cashier.pluck(:id).first)
  new_purchase.save
  customer_products = Product.where(customer_id: @current_customer.pluck(:id))
  customer_products.each do |prod|
    new_trunk = Trunk.new(:product_id => prod.id,:purchase_id =>new_purchase.id)
    new_trunk.save
    prod.update(status_id: list_product_by_status("Out of Stock"))
    total_cost += prod.price
  end
  puts total_cost
end

def clear
  system('clear')
end



enter_store






