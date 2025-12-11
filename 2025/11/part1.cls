class 11.part1:

    define temp-table ttdevices no-undo
        field id as char

        index ix is unique id
        .

    define temp-table ttoutputs no-undo
        field id        as char
        field id_target as char

        index ix is unique id id_target
        .

    constructor part1 (
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

        message 'answer' getPaths( 'you', '' ). // 791 in 36 ms

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

            if bu.id_target = 'out' then
                ipaths += 1.

            if lookup( bu.id_target, i_cpath ) = 0 then
                ipaths += getPaths( bu.id_target, i_cpath + ',' + i_cid ).

        end.

        return ipaths.

    end method.

end class.