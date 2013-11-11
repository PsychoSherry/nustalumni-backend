class Api::V1::DataController < Api::V1::V1Controller
	def home
		if DataMain.count == 0
			render_404 "content not found"
		else
			@data = DataMain.last
			render json: {
				:title   => @data.title,
				:images  => @data.images,
				:content => @data.content			
			}
		end
	end

	def faq
		render json: DataFaq.all.to_json(:except => [:_id])
	end
end
