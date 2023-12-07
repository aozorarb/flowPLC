require 'singleton'
module Item
  # manage item states
  class ItemManager
    include Singleton

    def initialize
      @items = {}
    end

    def state(id)
      return nil unless @items.key? id
      @items[id]
    end

    def change(id, state: false)
      @items[id] = state
    end

    def remove(id)
      @items.delete(@id)
    end

    # for debug, test
    def list
      @items.each do |item|
        puts item
      end
    end
  end

  # item class interface
  class BasicItem

    # show_state is to indicate self.state with hilight
    attr_reader :show_state

    def initialize(*args)
      @item_manager = ItemManager.instance
      @show_state = true
      _initialize(args)
    end

    def _initialize(args)
      # for children custom initialize
    end

    def show_state_disable() @show_state = false end

    # most item classes have similar represent
    # ex: (X01), |Y01|
    # "#{begin_c}#{id}#{format_str}#{end_c}"
    def represent_templete(begin_c, id, format_str, end_c)
      "#{begin_c}#{id}#{format(format_str, @id)}#{end_c}"
    end

    def act(state)
      raise 'not implement'
    end

    def represent
      raise 'not implement'
    end
    private :show_state_disable, :_initialize
  end

  class Start < BasicItem
    def _initialize(args)
      show_state_disable
    end

    def act(state)
      true
    end

    def represent
      '|'
    end
  end

  class End < BasicItem
    def _initialize(args)
      show_state_disable
    end

    def act(state)
      false
    end

    def represent
      '|'
    end
  end

  class Wire < BasicItem
    def act(state)
      state
    end

    def represent
      '-'
    end
  end

  # general output
  class Output < BasicItem

    def _initialize(args)
      @id = args[0]
    end

    def act(state)
      @item_manager.state(@id) && state
    end

    def represent
      represent_templete('|', 'O', "%02X", '|')
    end
  end
end

module Item::Input
end
