class 06.part2:

    constructor part2 (
        i_cfile as char
    ):

        var int64 igrand, itotal, ivalue.
        var char [4] coperand.
        var char cline, cop.
        var int ix, iline, ilines, iend, istart, iwidth, idigit.

        input from value( i_cfile ).

        repeat:

            import unformatted cline.
            iend = maximum( iend, length( cline ) ).

            if index( cline, '*' ) > 0 then
                cop = cline.

            else
                assign
                    ix += 1
                    coperand [ix] = cline
                    .

        end.

        ilines = ix.

        do while iend > 0:

            istart  =   maximum(
                            r-index( cline, '*', iend ),
                            r-index( cline, '+', iend )
                        ).

            if substring( cop, istart, 1 ) = '*' then
                itotal = 1.

            do ix = iend to istart by -1:

                do iline = 1 to ilines:

                    idigit = int( substring( coperand [iline], ix, 1 ) ).
                    if idigit > 0 then
                        assign
                            ivalue *= 10
                            ivalue += idigit
                            .

                end.

                // message iend ivalue.

                case substring( cop, istart, 1 ):

                    when '*' then
                        itotal *= ivalue.

                    when '+' then
                        itotal += ivalue.

                end case.

                ivalue = 0.

            end.

            // message 'total' itotal.

            assign
                igrand  +=  itotal
                itotal  =   0
                iend    =   istart - 2
                .

        end.

        message 'grand total:' igrand. // 8811937976367 in 55 ms

    end constructor.

end class.