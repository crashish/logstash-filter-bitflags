# Logstash Plugin
This is an extremely basic plugin for translating integer representations of bitfields into hashmaps of boolean values.

- requires 'source' and 'trans' configuration variables
- supports 'target' for destination field name

## Example
 - @trans from config:

 		{ "trans1" =>1, "trans2" =>2, "trans3" =>4, "trans4" =>8, "trans5" =>12, "trans6" => 16, "trans7" =>32, "trans8" =>64, "trans9" =>128 }
 - @source integer: 

 		{ "flag_source": 191 }

 this should translate to

 		event[@target] = {"trans7"=>true, "trans8"=>false, "trans9"=>true, "trans1"=>true, "trans2"=>true, "trans3"=>true, "trans4"=>true, "trans5"=>true, "trans6"=>true}
