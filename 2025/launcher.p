&scoped day 05
&scoped part 1
&scoped example false

var {&day}.part{&part} o.
var datetime dt = now.

message 'day {&day}.{&part}'.

o = new {&day}.part{&part}( &if {&example} &then '{&day}/example.txt' &else '{&day}/input.txt' &endif ).

message 'duration:' interval( now, dt, 'milliseconds' ) 'ms'.