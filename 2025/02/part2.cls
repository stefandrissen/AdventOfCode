class 02.part2:

    constructor part2( i_cfile as char ):

        var int64 iinvalid.
        var longchar lcfile.
        var int iparts, ix.
        var char cpart.
        var datetime [2] dt.

        dt [1] = now.

        copy-lob from file( i_cfile ) to lcfile.

        iparts = num-entries( lcfile ).

        do ix = 1 to iparts:

            iinvalid += invalidIds( string( entry( ix, lcfile ) ) ).

        end.

        dt [2] = now.

        message 'invalid:' iinvalid 'in' interval( dt[2], dt[1], 'milliseconds' ) 'ms'.

    end constructor.

    method private int64 invalidIds (
        i_cpart as char
    ):

        var int64 iinvalid, ifirst, ilast, ix.
        var int ilen, irepeats.
        var char cid.
        var decimal derepeats.
        var logical lfound.

        assign
            ifirst  =   int64( entry( 1, i_cpart, '-' ) )
            ilast   =   int64( entry( 2, i_cpart, '-' ) )
            .

        // message ifirst ilast.            

        do ix = ifirst to ilast:

            cid = string( ix ).

            if length( cid ) > 1 then do:
                
                do ilen = 1 to length( cid ) / 2 while not lfound:

                    derepeats = length( cid ) / ilen.
                    if derepeats = truncate( derepeats, 0 ) then do:

                        irepeats = int( derepeats ).                        
                        if fill( substring( cid, 1, ilen ), irepeats ) = cid then do:

                            // message ix.

                            assign 
                                iinvalid    +=  ix
                                lfound      =   true
                                .

                        end.

                    end.

                end.

            end.

            lfound = false.

        end.

        return iinvalid.

    end method.        

end class.    