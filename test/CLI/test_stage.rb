require_relative '../../lib/flowPLC/stage.rb'
require 'minitest/autorun'

module FlowPLC; end

class FlowPLC::Stage::Test < Minitest::Test
  def setup
    @stage = FlowPLC::Stage.new
  end

  def test_new_flow
    @stage.new_flow(0)
    assert_equal @stage.data, [[]]
  end
end
