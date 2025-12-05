class 02.getInput:

	define temp-table tt
		field id1 as int
		field id2 as int

		index ix1 id1
		index ix2 id2
		.

	constructor getInput ( i_cfile as char ):

		def var lcc as longchar no-undo.
		def var ix as int no-undo.

		copy-lob from file i_cfile to lcc.

		do while index( lcc, '  ' ) > 0:
			lcc = replace( lcc, '  ', ' ' ).
		end.
		lcc = replace( lcc, ' ', ',' ).
		lcc = replace( lcc, '~n', ',' ).
		lcc = trim( lcc, ',' ).

		do ix = 1 to num-entries( lcc ) by 2:

		// message ix string( entry( ix, lcc ) ) string( entry( ix + 1, lcc ) ).

		create tt.
		assign
			tt.id1 = integer( entry( ix    , lcc ) )
			tt.id2 = integer( entry( ix + 1, lcc ) )
			.

		end.

	end constructor.

	method handle getBuffer():

		def var hb as handle no-undo.

		create buffer hb for table 'tt'.
		return hb.

	end method.

end class.