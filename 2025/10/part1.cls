class 10.part1:

    constructor part1 (
        i_cfile as char
    ):

        var char cline.
        var int ipresses.

        input from value( i_cfile ).

        repeat:
            import unformatted cline.
            message cline.
            if cline > '' then
                ipresses += getMinimumPresses( cline ).

        end.

        message 'answer' ipresses. // ? in ? ms

    end constructor.

    define temp-table ttwiring no-undo
        field id        as int
        field cwiring   as char

        index ix is unique id
        .

    method private integer getMinimumPresses (
        i_cline as char
    ):

        var int ipresses.
        var char cneeded.
        var int iparts, ix.

        def buffer bu for ttwiring.

        cneeded = trim( entry( 1, i_cline, ' ' ), '[]' ).

        iparts = num-entries( i_cline, ' ' ).

        do ix = 1 to iparts - 2:

            do for bu:
                create bu.
                assign
                    bu.id   = exp( 2, ix - 1 )
                    bu.cwiring = trim( entry( ix + 1, i_cline, ' ' ), '()' )
                    .

                // message bu.id bu.cwiring.
            end.

        end.

        iparts -= 2.

        do ix = 1 to 1:

            ipresses = hasSolution( cneeded, iparts, ix ).
            if ipresses > 0 then do:
                message ipresses.
                return ipresses.
            end.

        end.

        message 'oops'.
        return -1.

        finally:
            empty temp-table ttwiring.
        end finally.

    end method.

    method private int hasSolution(
        i_cneeded       as char,
        i_iparts        as int,
        i_imax_pushes   as int
    ):

        var int ix, icombinations, ipushed.
        var char cstate.

        cstate = replace( i_cneeded, '#', '.' ).

        icombinations = exp( 2, i_iparts ) - 1.

        do ix = 0 to icombinations:

            if applyCombination( ix, cstate ) = i_cneeded then do:
                ipushed =   minimum(
                                if ipushed > 0 then ipushed else 1000,
                                getButtonsPushed( ix )
                            ).
                message ix getButtonsPushed( ix ).

            end.

        end.

        return ipushed.

    end method.

    method private char applyCombination (
        i_ivalue as int,
        i_cstate as char
    ):

        def buffer bu for ttwiring.

        var char cstate.
        var int ival, id.

        assign
            ival    =   i_ivalue
            cstate  =   i_cstate
            id      =   1
            .

        do while ival > 0:

            if ival modulo 2 = 1 then do:

                find bu where bu.id = id.
                cstate = applyWiring( cstate, bu.cwiring ).
                ival -= 1.

            end.

            id *= 2.
            ival /= 2.

        end.

        return cstate.

    end method.

    method private int getButtonsPushed (
        i_ivalue as int
    ):

        var int ibits.

        do while i_ivalue > 0:

            if i_ivalue modulo 2 = 1 then
                assign
                    ibits += 1
                    i_ivalue -= 1
                    .

            i_ivalue /= 2.

        end.

        return ibits.

    end method.

    method private char applyWiring (
        i_cstate    as char,
        i_cwiring   as char
    ):

        var char cstate, cc.
        var int ix, ipos.

        cstate = i_cstate.

        do ix = 1 to num-entries( i_cwiring ):

            ipos = int( entry( ix, i_cwiring ) ) + 1.
            substring( cstate, ipos ) = string( substring( cstate, ipos ) = '#', './#' ).

        end.

        // message i_cstate i_cwiring cstate.

        return cstate.

    end method.

end class.