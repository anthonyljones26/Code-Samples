module VcrBase
  def safe_name(name)
    name.gsub(/\W/, '_')
  end
end
