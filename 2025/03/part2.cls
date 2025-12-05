class 03.part2:

    constructor part2 (
        i_cfile as char
    ):

        var int64 ijoltage.
        var char cbank.

        input from value( i_cfile ).

        repeat:
            import unformatted cbank.
            ijoltage += getMaxJoltage( cbank ).
        end.

        message 'max joltage:' ijoltage.

    end constructor.

    method private int64 getMaxJoltage (
        i_cbank as char
    ):

        var char cjoltage.
        var int iremaining, ix, istart = 1, imax, ilen.

        ilen = length( i_cbank ).

        do iremaining = 11 to 0 by -1:

            do ix = istart to ilen - iremaining while imax < 9:

                imax    =   maximum(
                                imax,
                                int( substring( i_cbank, ix, 1 ) )
                            ).

            end.

            assign
                cjoltage    =   cjoltage + string( imax )
                istart      =   index( i_cbank, string( imax ), istart ) + 1
                imax        =   1
                .

        end.

        return int64( cjoltage ).

    end method.

end class.