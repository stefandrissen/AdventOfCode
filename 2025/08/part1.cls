class 08.part1:

    define temp-table ttjunctions no-undo
        field pt as int extent 3

        field dedistance as decimal
        field icircuit as int

        index ix dedistance
        .

    define temp-table ttconnections no-undo
        field r1 as rowid
        field r2 as rowid

        field dedistance as decimal
        field icircuit as int

        index ix1 dedistance
        index ix2 r1 r2
        index ix3 icircuit
        .

    define temp-table ttcircuits no-undo
        field id    as int
        field isize as int

        index ix1 is unique id
        index ix2 isize
        .

    var int p_icircuit, p_iconnection.

    constructor part1 (
        i_cfile as char
    ):

        def buffer bujunction for ttjunctions.
        def buffer buconnection for ttconnections.

        var int iconnections, icircuit, ikeep = 1000.

        if i_cfile matches '*example~~.txt' then
            ikeep = 10.

        input from value( i_cfile ).

        repeat:

            create bujunction.
            import delimiter ',' bujunction.pt.

        end.

        if bujunction.pt [1] = 0 and bujunction.pt [2] = 0 and bujunction.pt [3] = 0 then
            delete bujunction.

        message 'imported'.

        for each bujunction:
            getDistances( buffer bujunction ).
        end.

        message 'calculated distances'.

        for each buconnection by buconnection.dedistance:

            if iconnections < ikeep then
                iconnections += 1.
            else
                delete buconnection.

        end.

        message 'keep' ikeep.

        makeCircuits().

        // displayConnections().

        message 'answer' sizeThreeLargestCircuits(). // 2340 in 23038 ms - TOO LOW

    end constructor.

    method private void getDistances (
        buffer bu1junction for ttjunctions
    ):

        define buffer bu2junction for ttjunctions.
        define buffer buconnection for ttconnections.

        for each bu2junction:

            if      rowid( bu2junction ) <> rowid( bu1junction )
                and not can-find(
                        buconnection
                            where   buconnection.r1 =   rowid( bu2junction )
                            and     buconnection.r2 =   rowid( bu1junction )
                    )
            then do for buconnection:

                create buconnection.
                assign
                    buconnection.r1 = rowid( bu1junction )
                    buconnection.r2 = rowid( bu2junction )

                    buconnection.dedistance = getDistance( bu1junction.pt, bu2junction.pt )
                    .

            end.

        end.

    end method.

    method private decimal getDistance(
        p as int extent 3,
        q as int extent 3
    ):

        return
            sqrt(
                  exp( p [1] - q [1], 2 )
                + exp( p [2] - q [2], 2 )
                + exp( p [3] - q [3], 2 )
            ).

    end method.

    method private void makeCircuits ():

        define buffer bu1 for ttconnections.
        define buffer bu2 for ttconnections.
        define buffer bucircuit for ttcircuits.
        define buffer buj for ttjunctions.

        var int icircuit.

        for each bu1 by bu1.dedistance:

            if bu1.icircuit > 0 then
                find bucircuit where bucircuit.id = bu1.icircuit.

            else do:

                create bucircuit.
                assign
                    icircuit += 1
                    bucircuit.id = icircuit
                    bucircuit.isize = 2

                    bu1.icircuit = icircuit
                    .

            end.

            for each bu2
                where   bu2.icircuit = 0
                and     rowid( bu2 ) <> rowid( bu1 )
                and     (
                            bu2.r1  =   bu1.r1
                    or      bu2.r1  =   bu1.r2
                    or      bu2.r2  =   bu1.r1
                    or      bu2.r2  =   bu1.r2
                )
            :

                assign
                    bu2.icircuit = icircuit
                    bucircuit.isize += 1
                    .

            end.

        end.

    end method.

    method private void displayConnections ():

        define buffer bu for ttconnections.
        define buffer bu1 for ttjunctions.
        define buffer bu2 for ttjunctions.

        for each bu,
            bu1 where rowid( bu1 ) = bu.r1,
            bu2 where rowid( bu2 ) = bu.r2

            by bu.dedistance
        :

            message
                bu.icircuit
                substitute(
                    '&1,&2,&3',
                    bu1.pt [1],
                    bu1.pt [2],
                    bu1.pt [3]
                )
                '-'
                substitute(
                    '&1,&2,&3',
                    bu2.pt [1],
                    bu2.pt [2],
                    bu2.pt [3]
                )
                bu.dedistance
                .

        end.

    end method.

    method private int sizeThreeLargestCircuits ():

        define buffer bu for ttcircuits.

        var int icount = 1, ianswer = 1.


        for each bu by bu.isize descending while icount <= 3:

            // message bu.isize.
            assign
                icount  += 1
                ianswer *= bu.isize
                .

        end.

        return ianswer.

    end method.

end class.