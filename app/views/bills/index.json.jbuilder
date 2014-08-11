json.array!(@bills) do |bill|
  json.extract! bill, :id, :name, :description, :unit_price, :quantity, :total_price
  json.url bill_url(bill, format: :json)
end
