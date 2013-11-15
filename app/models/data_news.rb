class DataNews
  include Mongoid::Document

  field :date,		:type => Date
  field :title, 	:type => String
  field :content,	:type => String
  field :image,		:type => String, :default => "http://www.nust.edu.pk/News/PublishingImages/m8.jpg"
end


## HTML Cleaner Regex
# 
