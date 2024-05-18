require 'minitest/autorun'
require_relative '../../lib/flowPLC/stage'

class FlowPLC::Item::BasicItem
  def ==(other)
    # judge by inner item. No object_id
    vars = self.instance_variables
    vars.all? {|v| self.instance_variable_get(v) == other.instance_variable_get(v) }
  end
end



class FlowPLC::Stage::Test < Minitest::Test
  def setup
    FlowPLC::Stage.class_exec do
      attr_writer :data, :flow_state
    end

    @stage = FlowPLC::Stage.new
  end
  

  def test_new_flow
    @stage.new_flow

    assert_equal [[]], @stage.data
    assert_equal [[]], @stage.flow_state
  end


  def test_push_item
    @stage.data = [[]]
    @stage.flow_state = [[]]

    @stage.push_item(0, 'Input', ['in'])

    assert_equal [[FlowPLC::Item::Input.new('in')]], @stage.data
    assert_equal [[false]], @stage.flow_state
  end


  def test_insert_item
    @stage.data = [[]]
    @stage.flow_state = [[]]

    @stage.insert_item(0, 0, 'Input', ['in'])
    @stage.insert_item(0, 0, 'Input', ['in2'])

    assert_equal [[FlowPLC::Item::Input.new('in2'), FlowPLC::Item::Input.new('in')]], @stage.data
    assert_equal [[false, false]], @stage.flow_state
  end

  
  def test_new_flow_at
    @stage.new_flow_at(0)
    assert_equal [[]], @stage.data
    assert_equal [[]], @stage.flow_state
  end


  def test_delete_flow
    @stage.data = [[]]
    @stage.flow_state = [[]]

    @stage.delete_flow(0)

    assert_equal [], @stage.data
    assert_equal [], @stage.flow_state
  end


  def test_delete_item
    @stage.data = [[FlowPLC::Item::Input.new('in')]]
    @stage.flow_state = [[false]]
    @stage.delete_item('in')

    assert_equal [[]], @stage.data
    assert_equal [[]], @stage.flow_state
  end


  def test_item_exec
    @stage.data = [[FlowPLC::Item::Input.new('in')]]
    @stage.flow_state = [[false]]

    @stage.item_exec('in', 'on')
    assert_equal [[FlowPLC::Item::Input.new('in')]], @stage.data
    assert_equal [[true]], @stage.flow_state
  end
end

