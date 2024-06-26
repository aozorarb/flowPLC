require 'minitest/autorun'
require_relative '../../lib/flowPLC/item'
require_relative 'helper'

class FlowPLC::Item::Timer
  attr_accessor :time, :progress, :running
end

class FlowPLC::Item::Test < Minitest::Test
  include FlowPLC::Item

  def test_input
    item = Input.new('test')
    exp_item = Input.new('test')
    exp_item.name = :test
    exp_item.state = false

    assert_equal exp_item, item

    item.on
    exp_item.state = true

    assert_equal exp_item, item

    item.off
    exp_item.state = false

    assert_equal exp_item, item
  end


  def test_output
    item = Output.new('test')
    exp_item = Output.new('test')
    exp_item.name = :test
    exp_item.state = false

    assert_equal exp_item, item

    item.enable
    exp_item.state = true

    assert_equal exp_item, item

    item.disable
    exp_item.state = false

    assert_equal exp_item, item
  end


  def test_timer
    item = Timer.new('test', 10)
    exp_item = Timer.new('test', 10)
    exp_item.name = :test
    exp_item.state = false
    exp_item.time = 10
    
    assert_equal exp_item, item

    exp_item.running = true
    item.start
    assert_equal exp_item, item

    exp_item.running = false
    item.stop
    assert_equal exp_item, item

    item.start
    item.run
    exp_item.running = true
    exp_item.progress = 1

    assert_equal exp_item,  item

    9.times { item.run }
    
    exp_item.running = false
    exp_item.state = true
    exp_item.progress = 10
    assert_equal exp_item, item


  end
end
