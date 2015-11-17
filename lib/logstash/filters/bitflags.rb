# encoding: utf-8
# ed miles @ zscaler
# november 2015
# 
# This logstash filter plugin is designed to translate an integer representing a bitfield enumeration
# into a hashmap of boolean values representing the bitfield flags.
# 
# example:
# - @enum from config: { "enum1" =>1, "enum2" =>2, "enum3" =>4, "enum4" =>8, "enum5" =>12, "enum6" => 16, "enum7" =>32, "enum8" =>64, "enum9" =>128 }
# - @source integer: { "flag_source": 191 }
# this should translate to
# - event[@target] = {"enum7"=>true, "enum8"=>false, "enum9"=>true, "enum1"=>true, "enum2"=>true, "enum3"=>true, "enum4"=>true, "enum5"=>true, "enum6"=>true}

require "logstash/filters/base"
require "logstash/namespace"


class LogStash::Filters::Bitflags < LogStash::Filters::Base


  config_name "bitflags"

  config :enums, :validate => :hash, :required => true
  config :source, :validate => :string, :required => true
  config :target, :validate => :string, :default => 'flags_map'

  public
  def flags_to_hashmap( flags, input_enums)

    flagmap = {}

    for curr_flag in input_enums.keys
      flagmap[curr_flag] = input_enums[curr_flag] & Integer(flags) == input_enums[curr_flag]
    end
    flagmap
  end
  
  public
  def get_flags( event )
    flags = event[@source]
    flags = flags.first if flags.is_a? Array
    flags
  end

  public
  def apply_flags(flags, event)
    event[@target] = {}
    flags.each do |key, value|
      event[@target][key.to_s] = value
    end
  end
  
  public
  def register

    
  end 

  public
  def filter(event)
    flags =  nil

    flags = get_flags(event)
    return if flags.nil?
    myenum = flags_to_hashmap(flags, @enums)
    apply_flags(myenum, event)
    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter

end # class LogStash::Filters::Bitflags
