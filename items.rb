
module Item
  # manage item states
  class ItemManager
    private
    @@items = {}

    public
    def state(id)
      return nil unless @@items.key? id
      @@items[id]
    end

    def change(id, state: false)
      @@items[id] = state
    end

    def remove(id)
      @@items.delete(@id)
    end

    # for debug, test
    def list
      @@items.each do |item|
        puts item
      end
    end
  end

  class BasicItem

    attr_reader :show_state
    def initialize
      @item_manager = ItemManager.new
      @show_state = true
      _initialize
    end

    def _initialize
      # for children initialize
    end
    def show_state_disable
      @show_state = false
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
    def _initialize
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
    def _initialize
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
    public

    def initialize(id)
      @id = id
    end

    def act(state)
      @item_manager.state(@id)
    end

    def represent
      raise 'not implement'
    end
  end
end

module Item::Input
end
