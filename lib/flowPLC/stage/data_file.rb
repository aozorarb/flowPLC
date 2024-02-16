# save and load yaml data file
class FlowPLC::Stage::DataFile
  def initialize
    require 'yaml/store'
  end


  def file_name_usable?(file_name, exist_file_ok: false)
    if File.directory?(file_name)
      false
    elsif !exist_file_ok && File.exist?(file_name)
      false
    else
      true
    end
  end


  def save(file_name, stage_data, overwrite: false)
    is_file_name_usable = (overwrite ? file_name_usable?(file_name, exist_file_ok: true)
                                     : file_name_usable?(file_name))
    raise 'file name cannot be use' unless is_file_name_usable
    @store = YAML::Store.new(file_name)
    @store.transaction do
      @store['stage'] = stage_data
    end 
  end


  def load(file_name)
    raise 'file name cannot be use' unless file_name_usable?(file_name, exist_file_ok: true)
    raise 'file is not exist' unless File.exist?(file_name)
    @store = YAML::Store.new(file_name)
    res = ''
    @store.transaction do
      res = @store['stage']
    end
    if res == ''
      return nil
    else
      res
    end
  end

  private :file_name_usable?
end
