module SeoAble
	attr_reader :h1_text,:meta_title_text,:meta_description_text

	def self.included(base)
  		base.send(:attr_accessible, :h1, :meta_title, :meta_description)
	end
	
  def h1_text
		(defined?(h1) and h1) ? h1 : name
  end

	def meta_title_text
		(defined?(meta_title) and meta_title) ?  meta_title : name
	end

	def meta_description_text
		(defined?(meta_description) and meta_description) ?  meta_description : nil
	end


end