# save and load yaml data file

module FlowPLC::DataFile
  require 'yaml/store'

  def self.save(stage_data, filename, overwrite: false)
    raise 'The file name has already used' if File.exist?(filename) && !overwrite
    store = YAML::Store.new(filename)
    store.transaction do
      store['stage'] = stage_data
    end 
  end


  def self.load(filename)
    raise 'The file is not found' unless File.exist?(filename)
    store = YAML::Store.new(filename)
    res = ''
    store.transaction do
      res = store['stage']
   end
    if res == ''
      return nil
    else
      res
    end
  end
end
