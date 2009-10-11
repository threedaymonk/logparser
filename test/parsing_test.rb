require File.dirname(__FILE__)+'/test_helper'
require 'logparser'

class GeneralParsingTest < Test::Unit::TestCase
  include LogParser

  def test_should_extract_host
    line = Line.new(Template.new(':host'), '83.148.169.161')
    assert_equal '83.148.169.161', line.host
  end

  def test_should_extract_blank_data
    line = Line.new(Template.new('":host"'), '""')
    assert_nil line.host
  end

  def test_should_extract_domain
    line = Line.new(Template.new(':domain'), 'www.reevoo.com')
    assert_equal 'www.reevoo.com', line.domain
  end

  def test_should_extract_timestamp
    line = Line.new(Template.new('[:timestamp]'), '[02/Nov/2006:13:41:41 +0000]')
    assert_equal DateTime.parse('2006-11-02T13:41:41Z'), line.timestamp
  end

  def test_should_extract_verb
    line = Line.new(Template.new('":verb :path :protocol"'), '"GET /javascripts/effects.js?1161276768 HTTP/1.0"')
    assert_equal :get, line.verb
  end

  def test_should_extract_path
    line = Line.new(Template.new('":verb :path :protocol"'), '"GET /javascripts/effects.js?1161276768 HTTP/1.0"')
    assert_equal '/javascripts/effects.js?1161276768', line.path
  end

  def test_should_extract_protocol
    line = Line.new(Template.new('":verb :path :protocol"'), '"GET /javascripts/effects.js?1161276768 HTTP/1.0"')
    assert_equal 'HTTP/1.0', line.protocol
  end

  def test_should_extract_status
    line = Line.new(Template.new(':status'), '200')
    assert_equal 200, line.status
  end

  def test_should_extract_bytes
    line = Line.new(Template.new(':bytes'), '32871')
    assert_equal 32871, line.bytes
  end

  def test_should_extract_referrer
    line = Line.new(Template.new('":referrer"'), '"http://www.reevoo.com/reviews/mpn/hotpoint/fdw60p"')
    assert_equal 'http://www.reevoo.com/reviews/mpn/hotpoint/fdw60p', line.referrer
  end

  def test_should_extract_user_agent
    line = Line.new(Template.new('":user_agent"'), '"Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)"')
    assert_equal 'Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)', line.user_agent
  end

  def test_should_have_nil_referrer_when_log_contains_hyphen_placeholder
    line = Line.new(Template.new('":referrer"'), '"-"')
    assert_nil line.referrer
  end

  def test_should_extract_time_taken
    line = Line.new(Template.new(':time_taken msec'), '0.004 msec')
    assert_in_delta 0.004, line.time_taken, 0.00001
  end

  def test_should_give_time_taken_as_nil_when_not_given
    line = Line.new(Template.new(''), '')
    assert_nil line.time_taken
  end

  def test_should_extract_all_fields_from_sample_line
    sample =  '83.148.169.161 www.reevoo.com - [02/Nov/2006:13:41:41 +0000] '+
              '"GET /javascripts/effects.js?1161276768 HTTP/1.0" 200 32871 '+
              '"http://www.reevoo.com/reviews/mpn/hotpoint/fdw60p" '+
              '"Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)"'
    line = Line.new(
      Template.new(':host :domain :unknown [:timestamp] ":verb :path :protocol" :status :bytes ":referrer" ":user_agent"'),
      sample
    )
    assert_equal '83.148.169.161', line.host
    assert_equal 'www.reevoo.com', line.domain
    assert_equal DateTime.parse('2006-11-02T13:41:41Z'), line.timestamp
    assert_equal :get, line.verb
    assert_equal '/javascripts/effects.js?1161276768', line.path
    assert_equal '/javascripts/effects.js?1161276768', line.path
    assert_equal 'HTTP/1.0', line.protocol
    assert_equal 200, line.status
    assert_equal 32871, line.bytes
    assert_equal 'http://www.reevoo.com/reviews/mpn/hotpoint/fdw60p', line.referrer
    assert_equal 'Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)', line.user_agent
  end

  def test_should_ignore_trailing_newline
    line = Line.new(Template.new('":referrer"'), %{"foo"\n})
    assert_equal 'foo', line.referrer
  end

end
