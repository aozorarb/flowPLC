require 'minitest/autorun'
require_relative '../../lib/flowPLC/stage'
require_relative 'helper'

FlowPLC::Stage.class_exec do
  attr_writer :data
end

class FlowPLC::Stage::Test < Minitest::Test
  def setup
    @stage = FlowPLC::Stage.new
    # many testcasies ammused do '@stage.new_flow' before test
    @stage.data = [[]]
  end
  

  def test_new_flow
    @stage.data.clear
    @stage.new_flow

    assert_equal [[]], @stage.data
  end


  def test_push_item
    @stage.push_item(0, 'Input', ['in'])

    assert_equal [[FlowPLC::Item::Input.new('in')]], @stage.data
  end

  def test_push_item_not_found
    assert_raises(FlowPLC::NotItemError) { @stage.push_item(0, 'NotFound', ['404']) }
  end

  def test_push_item_invalid_index
    assert_equal nil, @stage.push_item(100, 'Input', 'in')
  end

  def test_insert_item
    @stage.insert_item(0, 0, 'Input', ['in'])
    @stage.insert_item(0, 0, 'Input', ['in2'])

    assert_equal [[FlowPLC::Item::Input.new('in2'), FlowPLC::Item::Input.new('in')]], @stage.data
  end

  def test_insert_item_not_found
    assert_raises(FlowPLC::InvalidItemError) { @stage.insert_item(0, 'NotFound', ['404']) }
  end

  def test_insert_item_invalid_index
    assert_equal nil, @stage.insert_item(100, 'Input', 'test')
  end

  
  def test_new_flow_at
    @stage.data.clear
    @stage.new_flow_at(0)

    assert_equal [[]], @stage.data
  end

  def test_new_flow_at_invalid_index
    assert_equal nil, @stage.new_flow_at(100)
  end

  def test_delete_flow
    @stage.delete_flow(0)

    assert_equal [], @stage.data
  end


  def test_item_exec
    @stage.data = [[FlowPLC::Item::Input.new('in')]]

    @stage.item_exec(0, 0, 'on')
    exp_item = FlowPLC::Item::Input.new('in')
    exp_item.on

    assert_equal [[exp_item]], @stage.data
  end
end

