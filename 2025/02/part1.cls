class 02.part1:

    constructor part1( i_cfile as char ):

        var int64 iinvalid.
        var longchar lcfile.
        var int iparts, ix.
        var char cpart.        

        copy-lob from file( i_cfile ) to lcfile.

        iparts = num-entries( lcfile ).

        do ix = 1 to iparts:

            iinvalid += invalidIds( string( entry( ix, lcfile ) ) ).

        end.

        message 'invalid:' iinvalid.

    end constructor.

    method private int64 invalidIds (
        i_cpart as char
    ):

        var int64 iinvalid, ifirst, ilast, ix.
        var int ilen.
        var char cid.

        assign
            ifirst  =   int64( entry( 1, i_cpart, '-' ) )
            ilast   =   int64( entry( 2, i_cpart, '-' ) )
            .

        // message ifirst ilast.            

        do ix = ifirst to ilast:

            assign 
                cid     =   string( ix )
                ilen    =   length( cid )
                .
            if ilen modulo 2 = 0 then do:

                // message substring( cid, 1, int( ilen / 2 ) )  substring( cid, 1 + int( ilen / 2 ) ).

                if substring( cid, 1, int( ilen / 2 ) ) = substring( cid, 1 + int( ilen / 2 ) ) then 
                    iinvalid += ix.

            end.                    

        end.

        return iinvalid.

    end method.        

end class.    