require 'rubygems'
require 'aws/s3'

class OffsiteBackup < FullBackup
	attr_accessor :file
	
	include Backup
	include AWS::S3
	
	def new(schema, file)
		if s3_settings['use_s3'] == 'yes'
			AWS::S3::Base.establish_connection!( :access_key_id => s3_settings['access_key_id'], :secret_access_key => s3_settings['secret_access_key'] )
			super(schema)
			@file = file
		else
			exit
		end
	end
	
	def create_month_bucket
		bucket = s3_settings['bucket_prefix'] + Time.now.strftime("%b_%Y")
		Bucket.create(bucket)
	end
	
	def list_buckets
		@buckets = Service.buckets
	end
	
end