
module Item
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
    def initialize
      @item_manager = ItemManager.new
    end
  end

  class Start
    def act
      true
    end

    def represent
      '|'
    end
  end

  class End
    def act
      false
    end

    def represent
      '|'
    end
  end
  # general output
  class Output < BasicItem
    public
    def state
      @state = @item_manager.state(@id)
    end

    def act
      @state
    end
  end
end

module Item::Input
end
