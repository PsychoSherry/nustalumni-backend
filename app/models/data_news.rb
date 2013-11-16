class DataNews
  include Mongoid::Document

  field :date,			:type => Date
  field :title, 		:type => String
  field :content,		:type => String
  field :url,			:type => String, :default => "http://www.nust.edu.pk/News"
  field :image,			:type => String, :default => "http://www.nust.edu.pk/News/PublishingImages/m8.jpg"

  validates :date,		:presence => true
  validates :url,		:presence => true
  validates :title,		:presence => true
  validates :content,	:presence => true
end

## HTML Cleaner Regex
# =>  ([a-zA-Z0-9-]*)=\"[^\"][a-zA-z0-9#%:;\s.\'\,_-]*\"