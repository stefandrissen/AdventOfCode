class 05.part1:

    define temp-table ttfresh no-undo
        field ifirst as int64
        field ilast  as int64

        index ix ifirst ilast
        .

    constructor part1 (
        i_cfile as char
    ):

        var char cline.
        var int ifresh = ?.
        var int64 id.

        define buffer bu for ttfresh.

        input from value( i_cfile ).

        repeat while ifresh = ?:

            import unformatted cline.

            if num-entries( cline, '-' ) = 2 then do for bu:

                create bu.
                assign
                    bu.ifirst   =   int64( entry( 1, cline, '-' ) )
                    bu.ilast    =   int64( entry( 2, cline, '-' ) )
                    .

            end.
            else
                ifresh = 0.

        end.

        repeat:

            import id.
            if can-find(
                    first bu
                        where bu.ifirst <= id
                        and   bu.ilast  >= id
                )
            then
                ifresh += 1.

        end.

        message 'fresh:' ifresh. // 607 in 27 ms

    end constructor.

end class.