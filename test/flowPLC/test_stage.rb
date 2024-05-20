require 'minitest/autorun'
require_relative '../../lib/flowPLC/stage'
require_relative 'helper'
class FlowPLC::Stage::Test < Minitest::Test
  def setup
    FlowPLC::Stage.class_exec do
      attr_writer :data
    end

    @stage = FlowPLC::Stage.new
  end
  

  def test_new_flow
    @stage.new_flow

    assert_equal [[]], @stage.data
  end


  def test_push_item
    @stage.data = [[]]

    @stage.push_item(0, 'Input', ['in'])

    assert_equal [[FlowPLC::Item::Input.new('in')]], @stage.data
  end


  def test_insert_item
    @stage.data = [[]]

    @stage.insert_item(0, 0, 'Input', ['in'])
    @stage.insert_item(0, 0, 'Input', ['in2'])

    assert_equal [[FlowPLC::Item::Input.new('in2'), FlowPLC::Item::Input.new('in')]], @stage.data
  end

  
  def test_new_flow_at
    @stage.new_flow_at(0)
    assert_equal [[]], @stage.data
  end


  def test_delete_flow
    @stage.data = [[]]

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

