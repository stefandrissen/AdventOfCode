class 07.part2:

    define temp-table ttbeams no-undo
        field ix as int
        field ilevel as int
        field icount as int64

        index ix1 is unique ix ilevel
        index ix2 ilevel ix
        .

    constructor part2 (
        i_cfile as char
    ):

        var int64 itimelines.
        var int ix, ilevel = 1.
        var char cline.

        def buffer bu for ttbeams.
        def buffer bu2 for ttbeams.

        input from value( i_cfile ).

        import unformatted cline.
        createBeam( ilevel, index( cline, 'S' ), 1 ).

        repeat:

            import unformatted cline.

            if index( cline, '^' ) > 0 then do:

                for each bu where bu.ilevel = ilevel:

                    if substring( cline, bu.ix, 1 ) = '^' then
                        splitBeam( buffer bu ).

                end.

                ilevel += 1.

                // debugBeam( cline ).

            end.

        end.

        for each bu:
            itimelines += bu.icount.
        end.

        message 'timelines:' itimelines. // TOO LOW: 20244456271 in 14 ms

    end constructor.

    method void createBeam (
        i_ilevel    as int,
        i_ix        as int,
        i_ibeams    as int64
    ):

        define buffer bu for ttbeams.

        find bu where bu.ix = i_ix and bu.ilevel <= i_ilevel no-error.
        if available bu then
            bu.ilevel = i_ilevel.

        else do:

            create bu.
            assign
                bu.ilevel   =   i_ilevel
                bu.ix       =   i_ix
                .

        end.

        bu.icount += i_ibeams.

    end method.

    method void splitBeam (
        buffer bu for ttbeams
    ):

        createBeam( bu.ilevel + 1, bu.ix - 1, bu.icount ).
        createBeam( bu.ilevel + 1, bu.ix + 1, bu.icount ).

        delete bu.

    end method.

    method void debugBeam (
        i_cline as char
    ):

        define buffer bu for ttbeams.

        var int itimelines.

        message i_cline.

        for each bu:
            message bu.ilevel bu.ix bu.icount.
            itimelines += bu.icount.
        end.

        message '-----' skip itimelines skip(2).

    end method.

end class.