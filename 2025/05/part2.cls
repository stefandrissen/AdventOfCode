&scoped debug

class 05.part2:

    define temp-table ttfresh no-undo
        field ifirst as int64
        field ilast  as int64

        index ix ifirst
        .

    constructor part2 (
        i_cfile as char
    ):

        var char cline.
        var int64 ifresh = ?.
        var int64 id, ix, ifirst, ilast.
        var logical lupdated = true.

        define buffer bu for ttfresh.
        define buffer bu2 for ttfresh.

        input from value( i_cfile ).

        repeat while ifresh = ?:

            import unformatted cline.

            if num-entries( cline, '-' ) = 2 then do:

                create bu.
                assign
                    bu.ifirst   =   int64( entry( 1, cline, '-' ) )
                    bu.ilast    =   int64( entry( 2, cline, '-' ) )
                    .

            end.
            else
                ifresh = 0.

        end.

        do while lupdated:

            lupdated = false.

            for each bu,
            first bu2
                where   bu2.ifirst >= bu.ifirst
                and     bu2.ifirst <= bu.ilast
                and     rowid( bu2 ) <> rowid( bu )
            :

                bu.ilast = maximum( bu.ilast, bu2.ilast ).
                delete bu2.
                lupdated = true.

            end.

        end.

        for each bu:

            ifresh += bu.ilast - bu.ifirst + 1.

        end.

        message 'fresh:' ifresh. // 342433357244012 in 3 ms

    end constructor.

end class.