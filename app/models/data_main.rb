class DataMain
  include Mongoid::Document

  field :title, 	:type => String
  field :content,	:type => String
  field :full_url,	:type => String
  field :images,	:type => Array 
end