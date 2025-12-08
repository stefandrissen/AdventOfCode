&scoped year    2025
&scoped day     08
&scoped part    1
&scoped example false

var {&day}.part{&part} o.
var datetime dt = now.

message 'day {&day}.{&part}'.

o = new {&day}.part{&part}( '{&year}/{&day}/' + &if {&example} &then 'example.txt' &else 'input.txt' &endif ).

message 'duration:' interval( now, dt, 'milliseconds' ) 'ms'.