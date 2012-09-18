class LocationController < ApplicationController

  def all
    # this controller responds to API route and returns JSON
    @data = Location.all
    respond_to do |format|
      format.json { render json: @data }
    end
  end

  def show
    # get all data to show in a table
    @data = Location.show
    @thead = @data.first.collect{ |column_name| column_name.first }
  end

  def upload
    # why importing csv within upload method and not in controller class?
    # it saves memory on the server, if csv is imported in the controller class-
    # everytime any controller method is called an import will be called
    # but, as below, if csv is imported inside upload method, everytime theres a controller call-
    # for "this specific" methods, csv will be imported / required
    require 'csv'
    if params[:file].blank?
      flash[:notice]
    else
      Location.collection.drop
      text = params[:file].read
      csv_data = CSV.parse text
      headers = csv_data.shift.map {|i| i.to_s }
      string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
      data = string_data.map {|row| Hash[*headers.zip(row).flatten] }
      data.each do |doc|
        location = Location.new(doc)
        location.save
      end
    end
  end

  protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
        username == "m@vd2.com" && password == "in2liberty"
    end
  end

end
