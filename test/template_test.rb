$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'test/unit'
require 'logparser/template'

class TemplateTest < Test::Unit::TestCase
  def test_should_extract_fields_from_pattern
    template = LogParser::Template.new(":a :b :c")
    assert_equal [:a, :b, :c], template.fields
  end

  def test_should_escape_regexp_properly
    template = LogParser::Template.new("[:a]")
    assert_equal(/\A\[(.*?)\]\Z/, template.regexp)
  end

  def test_should_extract_data_according_to_pattern
    template = LogParser::Template.new(":foo :bar [:baz]")
    assert_equal({:foo => 'Foo', :bar => 'Bar', :baz => 'Baz'}, template.apply('Foo Bar [Baz]'))
  end
end
