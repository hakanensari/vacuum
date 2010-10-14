# encoding: utf-8
def amazon
  @amazon ||= YAML::load_file(File.dirname(__FILE__) + "/amazon.yml")
end
