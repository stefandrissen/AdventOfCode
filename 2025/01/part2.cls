class 01.part2:

    constructor part2( i_cfile as char ):

        var char cline, cmove.
        var int idial = 50, inew, imove, izero.

        input from value( i_cfile ).

        repeat:

            import unformatted cline.

            assign 
                cmove = replace( cline, 'L', '-' )
                cmove = replace( cmove, 'R', '' )

                imove = int( cmove )
                .

            do while imove > 0:

                assign 
                    idial += 1
                    imove -= 1
                    .
                if idial = 100 then 
                    idial = 0.

                if idial = 0 then 
                    izero += 1.

            end.

            do while imove < 0:

                if idial = 0 then 
                    idial = 100.

                assign 
                    idial -= 1
                    imove += 1
                    .
                if idial = 0 then 
                    izero += 1.

            end.

            display cline idial izero.

        end.

        message 'Zero passed:' izero.

        finally:
            input close.
        end finally.

    end constructor.

end class.    