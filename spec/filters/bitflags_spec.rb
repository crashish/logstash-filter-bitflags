# encoding: utf-8
require 'spec_helper'
require "logstash/filters/bitflags"

describe LogStash::Filters::Bitflags do
  describe "example trans" do
    let(:config) do <<-CONFIG
      filter {
        bitflags {
          source => "flags"
          trans => {   "trans1" =>1
                      "trans2" =>2
                      "trans3" =>4
                      "trans4" =>8
                      "trans5" =>12
                      "trans6" =>16
                      "trans7" =>32
                      "trans8" =>64
                      "trans9" =>128 }
          target => "flags_map"
        }
      }
    CONFIG
    end
    sample("flags" => 191) do
      insist { subject["flags_trans"]["trans1"] } == true
      insist { subject["flags_trans"]["trans2"] } == true
      insist { subject["flags_trans"]["trans3"] } == true
      insist { subject["flags_trans"]["trans4"] } == true
      insist { subject["flags_trans"]["trans5"] } == true
      insist { subject["flags_trans"]["trans6"] } == true
      insist { subject["flags_trans"]["trans7"] } == true
      insist { subject["flags_trans"]["trans8"] } == false
      insist { subject["flags_trans"]["trans9"] } == true

    end
  end
end
