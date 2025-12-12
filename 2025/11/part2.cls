class 11.part2:

    define temp-table ttdevices no-undo
        field id as char

        index ix is unique id
        .

    define temp-table ttoutputs no-undo
        field id        as char
        field id_target as char
        field to_exit   as logical initial ?

        index ix is unique id id_target
        .

    constructor part2 (
        i_cfile as char
    ):

        var char cline.
        var int ix.

        def buffer budevice for ttdevices.
        def buffer buoutput for ttoutputs.

        input from value( i_cfile ).

        repeat:
            import unformatted cline.
            if cline > '' then do for budevice:

                create budevice.
                budevice.id = entry( 1, cline, ':' )
                .

                do ix = 2 to num-entries( cline, ' ' ):

                    do for buoutput:

                        create buoutput.
                        assign
                            buoutput.id         =   budevice.id
                            buoutput.id_target  =   entry( ix, cline, ' ' )
                            .
                    end.

                end.

            end.

        end.

        message 'answer' getPaths( 'svr', '' ). // took forever :D

    end constructor.

    method private int getPaths (
        i_cid   as char,
        i_cpath as char
    ):

        var int ipaths.

        define buffer bu for ttoutputs.

        for each bu
            where bu.id = i_cid
        :

            if bu.to_exit then
                ipaths += 1.

            else if bu.id_target = 'out'
                and lookup( 'dac', i_cpath ) > 0
                and lookup( 'fft', i_cpath ) > 0
            then do:
                ipaths += 1.
                markExit( i_cpath ).
            end.

            else if lookup( bu.id_target, i_cpath ) = 0 then
                ipaths += getPaths( bu.id_target, i_cpath + ',' + i_cid ).

        end.

        return ipaths.

    end method.

    method private void markExit (
        i_cpath as char
    ):

        var int ix, iparts.
        def buffer bu for ttoutputs.

        iparts = num-entries( i_cpath ).

        do ix = 1 to iparts:

            find bu where bu.id = entry( ix, i_cpath ).
            bu.to_exit = true.

        end.

    end method.

end class.