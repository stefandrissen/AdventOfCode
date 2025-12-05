class 01.part1:

    constructor part1( i_cfile as char ):

        var char cline.
        var int idial = 50.
        var int izero = 0.

        input from value( i_cfile ).

        repeat:

            import unformatted cline.

            case substring( cline, 1, 1):

                when 'L' then do:
                    assign
                        idial -= int( substring( cline, 2 ) )
                        idial = idial modulo 100
                        .
                    if idial < 0 then
                        idial += 100.
                end.

                when 'R' then 
                    assign
                        idial += int( substring( cline, 2 ) )
                        idial = idial modulo 100
                        .

                otherwise
                    undo, throw new Progress.Lang.AppError( 'Invalid line: ' + cline, 400 ).

            end case.

            if idial = 0 then 
                izero += 1.

            display cline idial izero.

        end.

        message izero.

        finally:
            input close.
        end finally.

    end constructor.

end class.    