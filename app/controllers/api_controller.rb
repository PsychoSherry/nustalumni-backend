class ApiController < ApplicationController
	respond_to :json#, :xml

	def null
		respond_with nil
	end
end
