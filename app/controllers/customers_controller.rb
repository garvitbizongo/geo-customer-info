class CustomersController < ApplicationController
  attr_reader :errors

  module Constants
    RAD_PER_DEG = Math::PI / 180
    RM = 6371 # Earth radius in kilometers
  end

  def index
    #Form to upload the file with customers details.
  end

  def customer_info
    if params[:customer_file].blank?
      redirect_to customers_url, flash: { error: "Please upload a txt file of customers." }
      return
    end

    data = get_data_from_file(params[:customer_file])

    if @errors.present?
      redirect_to customers_url, flash: { error: @errors }
      return
    end

    users_in_range = get_users_within_the_range(data)
    @sorted_list_of_users = sort_array_of_hashes(users_in_range, "user_id")
  end

  private

  def get_users_within_the_range(data)
    final_data = []
    data.each do |row|
      distance = get_distance(row["latitude"].to_f, row["longitude"].to_f)

      if distance <= 100.0
        row["distance"] = distance
        final_data << row
      end
    end

    final_data
  end

  def get_distance(lat1, long1)
    ho_coordinates = coordinates
    ho_lat = ho_coordinates[:latitude]
    ho_long = ho_coordinates[:longitude]

    lat1_rad, ho_lat_rad = lat1 * Constants::RAD_PER_DEG, ho_lat * Constants::RAD_PER_DEG
    long1_rad, ho_long_rad = long1 * Constants::RAD_PER_DEG, ho_long * Constants::RAD_PER_DEG

    a = Math.sin((ho_lat_rad - lat1_rad) / 2) ** 2 + Math.cos(lat1_rad) * Math.cos(ho_lat_rad) * Math.sin((ho_long_rad - long1_rad) / 2) ** 2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1 - a))

    (Constants::RM * c)
  end

  def get_data_from_file(file)
    file_data = file.tempfile
    file_format = File.extname(file_data)

    if !file_format.starts_with?(".txt")
      @errors = "The file that you are uploading is of different format. We accept only txt format file"
      return
    end

    data = []
    File.open(file_data, 'r').each_line do |line|
      data << JSON.parse(line)
    end

    if data.blank?
      @errors = "The file that you have uploaded is blank."
      return
    else
      data
    end
  end

  def sort_array_of_hashes(hash, sorting_key)
    sorted_data = hash.sort_by{ |h| h[sorting_key] }

    sorted_data
  end

  def coordinates
    {
      latitude: 53.339428,
      longitude: -6.257664
    }
  end
end
