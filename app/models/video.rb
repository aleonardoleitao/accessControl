class Video < ActiveRecord::Base
	attr_accessible :path, :status, :token, :time, :range
end
