class Location
  # want to import CSV in test environment? see /lib/tasks/etl.rb
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  # dynamic fields is set to true in mongoid.yml
  # that enables this application to upload any csv file-
  # regardless of a fixed format

  store_in collection: "location", database: "pns_test"

  def self.show
    # Question, why is above method a class method and not an instance method?
    # it's a good coding practice to use instance methods for operations on individual records in database
    # and the established practice for methods which operate on the complete logical model entities is to use class methods
    # a class method looks like this => def self.foo()
    # an instance method looks like this => def self()
    # calling a class method looks liks this => Model.foo()
    # calling an instance method looks liks this => Model.new.foo()
    locations = Location.collection.find().to_a
    #  locations.each do |row|
        # row.delete("_id")
        # why not deleting _id coming from mongo?
        # that _id goes into the DOM when table is generted
        # so that every drop down in DOM could have a unique id
        # that way every single row can be referenced from DOM to the back end with AJAX
        #end
      # sort the hash before returning to controller
    return locations.collect{ |r| Hash[r.sort]}
  end

  def self.all
    locations = Location.collection.find().to_a
      #locations.each do |row|
        # row.delete("_id")
        # why not deleting _id here?
        # this method of the model is used by the controller action which should be able to send json for mobile applications
        # _id has to be sent for uniqueness because _id here in the back end should be -
        #  same _id in mobile app database if a periodic sync is required
      #end
      # formatting json response
    return {:api=>{:locations=>locations.collect{ |r| Hash[r.sort]}}}
  end

end
