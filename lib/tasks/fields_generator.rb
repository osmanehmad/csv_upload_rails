require 'csv'
f = open("potentials.csv")
data = f.read()
data.chomp! "\r\n\r\nThe information contained in this report is subject to the license restrictions and all other terms contained in ForeclosureRadar.com's User Agreement.\r\n"
f.close()
p data
File.open('potentials.csv', 'w') {|f| f.write(data) }
csv_data = CSV.open("potentials.csv").read
p csv_data
headers = csv_data.shift.map {|i| i.to_s }
fields = ""
headers.each do |col|
  p "field :"+col.to_s
end
p fields
open('myfile.out', 'a') { |f| f.puts fields}

