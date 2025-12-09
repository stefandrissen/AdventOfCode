class 09.part1:

    define temp-table tttiles no-undo
        field x as int64
        field y as int64

        index ix is unique x y
        .

    constructor part1 (
        i_cfile as char
    ):

        def buffer butile for tttiles.

        input from value( i_cfile ).

        repeat:
            create butile.
            import delimiter ',' butile.x butile.y.
        end.
        delete butile.

        message 'area' getLargestArea(). // 4781235324 in 270 ms

    end constructor.

    method private int64 getLargestArea (
    ):

        var int64 iarea.

        define buffer bu1 for tttiles.
        define buffer bu2 for tttiles.

        for each bu1, each bu2:

            iarea = maximum(
                        iarea,
                        ( 1 + absolute( bu1.x - bu2.x ) )
                        * ( 1 + absolute( bu1.y - bu2.y ) )
                    ).

        end.

        return iarea.

    end method.

end class.