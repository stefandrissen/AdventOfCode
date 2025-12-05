define input parameter oList as 01.getInput no-undo.

var handle hq1, hq2, hb1, hb2.
var int idiff.

hb1 = oList:getBuffer().
create query hq1.
hq1:add-buffer( hb1 ).
hq1:query-prepare( 'for each tt by id1' ).
hq1:query-open().

hb2 = oList:getBuffer().
create query hq2.
hq2:add-buffer( hb2 ).

do while hq1:get-next():

	hq2:query-prepare( substitute( 'preselect each tt where id2 = &1', hb1::id1 ) ).
	hq2:query-open().

	idiff = idiff + hb1::id1 * hq2:num-results.

end.

message 'Part Two:' idiff.