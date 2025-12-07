class 07.part1:

    define temp-table ttbeams no-undo
        field ix as int
        index ix is unique ix
        .

    constructor part1 (
        i_cfile as char
    ):

        var int isplits, ix.
        var char cline.

        def buffer bu for ttbeams.

        input from value( i_cfile ).

        import unformatted cline.
        createBeam( index( cline, 'S' ) ).

        repeat:

            import unformatted cline.

            for each bu:

                if substring( cline, bu.ix, 1 ) = '^' then
                    isplits += splitBeam( bu.ix ).

            end.

            // message cline isplits.

        end.

        message 'splits:' isplits. // 1490 in 21 ms

    end constructor.

    method void createBeam (
        i_ix as int
    ):

        define buffer bu for ttbeams.

        if not can-find( bu where bu.ix = i_ix ) then do:

            create bu.
            bu.ix = i_ix.

        end.

    end method.

    method int splitBeam (
        i_ix as int
    ):

        var int isplit.

        define buffer bu for ttbeams.

        find bu where bu.ix = i_ix no-error.
        if available bu then do:

            isplit = 1.
            createBeam( i_ix - 1 ).
            createBeam( i_ix + 1 ).

            delete bu.

        end.

        return isplit.

    end method.

end class.