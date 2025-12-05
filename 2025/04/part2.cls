class 04.part2:

    define temp-table tt no-undo
        field x as int
        field y as int

        field c as char init '@'

        index ix is unique x y
        .

    constructor part2 (
        i_cfile as char
    ):

        var longchar lcfile.
        var char cline.
        var int ix, iy, iwidth, imovable.

        define buffer bu for tt.

        input from value( i_cfile ).

        repeat:

            import unformatted cline.

            assign
                iy += 1
                iwidth = length( cline )
                .

            do ix = 1 to iwidth:

                if substring( cline, ix, 1 ) = '@' then do for bu:
                    create bu.
                    assign
                        bu.x = ix
                        bu.y = iy
                        .
                end.

            end.

        end.

        message 'removed:' getMoveable( iwidth, iy ).

        displayMap( iwidth, iy ).

    end constructor.

    method private int getMoveable (
        i_iwidth    as int,
        i_iheight   as int
    ):

        var int imoveable, ix, iy.
        var logical lremoved = ?.

        define buffer bu for tt.

        repeat while lremoved <> false:

            lremoved = false.

            for each bu:

                if getAdjacent( bu.x, bu.y ) < 4 then do:
                    assign
                        imoveable += 1
                        lremoved = true
                        .
                    delete bu.
                end.

            end.

        end.

        return imoveable.

    end method.

    method private int getAdjacent (
        i_ix    as int,
        i_iy    as int
    ):

        var int iadjacent, ip.

        var int [] ihorizontal = [
            -1,  0,  1,
            -1,      1,
            -1,  0,  1
        ].
        var int [] ivertical   = [
            -1, -1, -1,
             0,      0,
             1,  1,  1
        ].

        define buffer bu for tt.

        do ip = 1 to 8 while iadjacent < 4:

            if can-find(
                    bu
                        where   bu.x = i_ix + ihorizontal [ip]
                        and     bu.y = i_iy + ivertical [ip]
                )
            then
                iadjacent += 1.

        end.

        return iadjacent.

    end method.

    method private void displayMap (
        i_iwidth    as int,
        i_iheight   as int
    ):

        var int iy, ix.
        var char crow.

        define buffer bu for tt.

        do iy = 1 to i_iheight:

            do ix = 1 to i_iwidth:

                find bu where bu.x = ix and bu.y = iy no-error.
                crow += if available bu then bu.c else '.'.

            end.

            message crow.
            crow = ''.

        end.

    end method.

end class.