class CustomersController < ApplicationController
  def index
  end

  def customer_info
    file_data = params[:customer_file].tempfile

    data = []
    File.open(file_data, 'r').each_line do |line|
      data << JSON.parse(line)
    end

  end
end
