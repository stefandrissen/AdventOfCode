class 03.part1:

    constructor part1 (
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

    method private int getMaxJoltage (
        i_cbank as char
    ):

        var int ijoltage, ix, iy, ilen.
        var char ctens.

        ilen = length( i_cbank ).

        do ix = 1 to ilen - 1:

            ctens = substring( i_cbank, ix, 1 ).

            do iy = ix + 1 to ilen:

                ijoltage = maximum( ijoltage, int( ctens + substring( i_cbank, iy, 1 ) ) ).

            end.

        end.

        return ijoltage.

    end method.

end class.