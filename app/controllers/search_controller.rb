def new
  @search = Search.new
end

def create
  @search = Search.new(params[:search])

  # TODO: use the @search object to perform a search.  Adding
  #   # a `results` method on the search object might be a good starting point.
end
#  = simple_form_for(@search) do |f|
#    = f.error_notification
#    .form-inputs
#      = f.input :character_name
#      = f.input :realm
#    .form-actions
#      = f.button :submit
