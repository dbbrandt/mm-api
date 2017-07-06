# app/controllers/concerns/csv_loader.rb
module CsvLoader

  attr_accessor :csv_filename
  attr_accessor :json_data

  # Load a csv file into an array of hashes with the hearder row used for keys
  def load(file = @csv_filename)
    keys = nil
    @json_data = []
    CSV.foreach(file) do |row|
      keys = row unless keys
      @json_data << Hash[keys.zip(row)]  unless keys == row
    end
    @json_data
  end

end