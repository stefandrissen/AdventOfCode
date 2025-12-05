var datetime [4] dt.
var int ix.

var 01.getInput o.

dt[1] = now.

o = new 01.getInput( 'list.txt' ). dt[2] = now.

run one.p (o). dt[3] = now.
run two.p (o). dt[4] = now.


do ix = 2 to extent(dt):
	message interval( dt[ix], dt[ix - 1], 'milliseconds' ).
end.