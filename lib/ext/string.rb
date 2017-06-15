class String
  def to_alphanum
  	while self[/\d/]
	  	self.sub! self[/\d+/], ('a'..'z').to_a[self[/\d+/].to_i]
	  end
	  self
  end
end