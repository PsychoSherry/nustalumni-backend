class AdminController < ApplicationController

	def news_index
	end

	def news_add
		@status = "Failed"
		if params[:title].present? && params[:content].present? && params[:date].present?
			if params[:image].blank?
				@image = "http://www.nust.edu.pk/News/PublishingImages/m8.jpg"
			else
				@image = params[:image]
			end

			DataNews.create(
				:title   => params[:title],
				:content => params[:content],
				:date    => Date.parse(params[:date]),
				:image   => @image
			)

			@status = "Success"
		else
			@errors = "Params not present"
		end
	end
end
