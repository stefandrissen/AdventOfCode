class 06.part1:

    constructor part1 (
        i_cfile as char
    ):

        var int64 igrand, itotal.
        var char [4] coperand.
        var char cline, cop.
        var int ix, iline, ilines.

        input from value( i_cfile ).

        repeat:

            import unformatted cline.

            if index( cline, '*' ) > 0 then
                cop = replace( cline, ' ', '' ).

            else do:

                do while index( cline, '  ' ) > 0:
                    cline = replace( cline, '  ', ' ' ).
                end.

                assign
                    ix += 1
                    coperand [ix] = trim( cline )
                    .

            end.

        end.

        ilines = ix.

        do ix = 1 to length( cop ):

            case substring( cop, ix, 1 ):

                when '*' then do:

                    itotal = 1.
                    do iline = 1 to ilines:
                        itotal *= int64( entry( ix, coperand [iline], ' ' ) ).
                    end.

                end.

                when '+' then do:

                    itotal = 0.
                    do iline = 1 to ilines:
                        itotal += int64( entry( ix, coperand [iline], ' ' ) ).
                    end.

                end.

            end case.

            igrand += itotal.

        end.

        message 'grand total:' igrand. // 6171290547579 in 29 ms

    end constructor.

end class.