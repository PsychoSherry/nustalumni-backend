class Api::V1::DataController < Api::V1::V1Controller
	before_filter :verify_user_token!

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

	def news
		render json: DataNews.all.reverse.map { |n| {
				:title   => n.title,
				:image   => n.image,
				:url	 => n.url,
				:date    => n.date.to_formatted_s(:long),
				:content => n.content
			}
		}
	end

	def volunteers
		render json: {
			:you		 => current_user.volunteer,
			:title		 => DataMentor.last.title,
			:content	 => DataMentor.last.content,
			:volunteers  => 
				User.where(:volunteer => true)
				.only([:name, :email, :discipline, :image])
				.map { |n| {
					:name       => n.name,
					:email 	    => n.email,
					:image 		=> n.image,
					:discipline => n.discipline
				}}
		}
	end

	def people
		render json: {
			"type_0" => 
				User.where(:professional_status => 0)
				.only([:name, :email, :discipline, :image])
				.map { |n| {
					:name       => n.name,
					:email 	    => n.email,
					:image 		=> n.image,
					:discipline => n.discipline
				}},

			"type_1" => 
				User.where(:professional_status => 1)
				.only([:name, :email, :discipline, :image])
				.map { |n| {
					:name       => n.name,
					:email 	    => n.email,
					:image 		=> n.image,
					:discipline => n.discipline
				}},

			"type_2" => 
				User.where(:professional_status => 2)
				.only([:name, :email, :discipline, :image])
				.map { |n| {
					:name       => n.name,
					:email 	    => n.email,
					:image 		=> n.image,
					:discipline => n.discipline
				}}
		}
	end
end
