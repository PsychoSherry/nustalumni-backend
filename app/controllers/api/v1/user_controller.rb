class Api::V1::UserController < Api::V1::V1Controller
	before_filter :verify_user_token!, :except => [:new, :login, :validsession]

	def new
		if params[:email].present? && params[:password].present? && params[:name].present?
			@user = User.where(:email => params[:email])
			if @user.count == 0
				@user = User.create!(
					:name     => params[:name],
					:email 	  => params[:email],
					:password => params[:password]
				)

				@user.reset_authentication_token!
				sign_in :user, @user

				render json: {
					status: 'successful',
					auth_token: @user.authentication_token
				}
			else
				render_422 'user already exists'
			end

		else
			render_400
		end
	end

	def login
		if params[:email].present? && params[:password].present?
			@user = User.where(:email => params[:email])
			if @user.count == 0
				render_404 'user not found'
			else
				if (resource = User.find_for_authentication(:email => params[:email]))
	    			if resource.valid_password?(params[:password])
	    				resource.reset_authentication_token!
	    				sign_in :user, resource

	    				render json: {
	    					status: 'successful',
	    					auth_token: resource.authentication_token
	    				}
	    			else
	    				render_401 'invalid password'
	    			end
	    		end
			end

		else
			render_400
		end
	end

	def validsession
		if user_signed_in?
			render json: { valid: true }
		else
			render json: { valid: false }
		end
	end

	def show
		if params[:email].present?
			@user = User.where(:email => params[:email])
			if @user.count == 0
				render_404
			else
				render json: @user.first
			end
		else
			render json: current_user
		end
	end

	def update
		@user = User.find(current_user.id)

		if @user.update_attributes(
			:name_first 		 => get_params(@user, :name_first),
			:name_last 	 		 => get_params(@user, :name_last),
			:campus 	 		 => get_params(@user, :campus),
			:discipline  		 => get_params(@user, :discipline),
			:job_company 		 => get_params(@user, :job_company),
			:job_position		 => get_params(@user, :job_position),
			:course 	 		 => get_params(@user, :course),
			:course_year 		 => get_params(@user, :course_year).to_i,
			:graduate			 => get_params(@user, :graduate).to_i,
			:professional_status => get_params(@user, :professional_status).to_i
		)
			render json: {
				status: 'successful'
			}
		else
			render_422 @user.errors.full_messages.first
		end
	end

	def password
		if params[:password_old].present? && params[:password_new].present?
			resource = User.find_for_authentication(:email => current_user.email)
			
			if resource.valid_password? params[:password_old]
				resource.update_attributes :password => params[:password_new]
				resource.reset_authentication_token!
				sign_in :user, resource

				render json: {
					status: 'successful',
					auth_token: resource.authentication_token
				}
			else
				render_401 'invalid password'
			end

		else
			render_400
		end
	end

	def volunteer
		if params[:volunteer].present?
			@user = User.find(current_user.id)
			@user.volunteer = params[:volunteer].to_i

			if @user.save
				render json: {
					status: 'successful'
				}
			else
				render_422 @user.errors.full_messages.first
			end
		else
			render_400
		end
	end

	def is_volunteer
		render json: {
			volunteer: current_user.volunteer 
		}
	end

	def logout
        if user_signed_in?
            current_user.authentication_token=nil
            current_user.save
            sign_out current_user
			render json: {
				status: 'successful'
			}
        else
			render json: {
				status: 'failed',
				error:  'user not signed in'
			}
        end
	end

	def get_params user, parakey
		if params[parakey].blank?
			x = user[parakey]
			if x.is_a? Boolean
				x = (x ? 1 : 0)
			end
			return x
		else
			return params[parakey]
		end
	end
end
