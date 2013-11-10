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
end
