class 06.two:

   constructor two ():

      var int iyg, itrapped, iy, ix.

      session:appl-alert-boxes = true.

      iyg = readMap( '06/input.txt' ).

      itrapped = walkAlternateMaps( getX( iyg ), iyg ).

      message itrapped. // not 2127

   end constructor.

   define temp-table ttmap undo
      field iy as int
      field cc as char

      index ix iy
      .

   method int readMap ( i_cfile as char ):

      define buffer bumap for ttmap.

      var int iy, iyg.

      input from value( i_cfile ).

      repeat for bumap transaction:

         create bumap.
         assign
            iy = iy + 1

            bumap.iy = iy
            .
         import unformatted bumap.cc.

         if trim( bumap.cc, '#.' ) > '' then
            iyg = iy.

      end.

      input close.

      return iyg.

   end method.

   method int walkAlternateMaps ( i_xg as int, i_yg as int ):

      define buffer bumap for ttmap.

      var int itrapped, ix, iy, iwidth, iheight.
      var datetime dt.

      find last bumap.

      assign
         iwidth   =  length( bumap.cc )
         iheight  =  bumap.iy
         .

      output to 'progress.log' unbuffered.

      // x = 2 y = 92 -> circle

      do ix = 1 to iwidth:

         dt = now. put unformatted string( ix ).

         do iy = 1 to iheight:

            put unformatted ' ' string( iy ).

            if getMap( ix, iy ) = '.' then do transaction:

               createAlternateReality( ix, iy ).

               if walkMapTrapped( i_xg, i_yg ) then
                  itrapped = itrapped + 1.

               undo.

            end.

         end.

         put unformatted ' ' interval( now, dt, 'milliseconds' ) skip.

      end.

      output close.

      return itrapped.

   end method.

   method void createAlternateReality( i_x as int, i_y as int ):

      define buffer bumap for ttmap.

      find bumap where bumap.iy = i_y no-error.
      substring( bumap.cc, i_x, 1 ) = 'O'.

   end method.

   method void dumpMap ():

      output to 'map.txt' append.
      for each ttmap:
         put unformatted ttmap.cc skip.
      end.

      put unformatted skip(1).

      output close.

   end method.

   method logical walkMapTrapped ( i_x as int, i_y as int ):

      var char     cdir =   '^' + '>' + 'v' + '<'.
      var int  [4] idx  = [  0  ,  1  ,  0  , -1  ].
      var int  [4] idy  = [ -1  ,  0  ,  1  ,  0  ].

      var int ix, iy, idir.
      var char cc.

      assign
         ix = i_x
         iy = i_y
         .

      cc = getMap( ix, iy ).

      idir = index( cdir, cc ).

      do on stop undo, retry:

         // if took more than 2 seconds -> assume circling
         if retry then
            return true.

         do stop-after 2:

            do while cc <> ?:

               // dumpMap().

               if not setMap( ix, iy, idir ) then
                  return true.

               cc = getMap( ix + idx [idir], iy + idy [idir] ).
               if cc = '#' or cc = 'O' then do:

                  idir = idir + 1.
                  if idir > 4 then
                     idir = 1.

               end.
               else
                  assign
                     ix = ix + idx [idir]
                     iy = iy + idy [idir]
                     .

            end.

         end.

      end.

      return false.

   end method.

   method char getMap ( i_ix as int, i_iy as int ):

      define buffer bumap for ttmap.

      if i_ix > 0 then
         find bumap where bumap.iy = i_iy no-error.

      if available bumap and i_ix <= length( bumap.cc ) then
         return substring( bumap.cc, i_ix, 1 ).

   end method.

   method logical setMap ( i_ix as int, i_iy as int, i_idir as int ):

      define buffer bumap for ttmap.

      find bumap where bumap.iy = i_iy no-error.
      if available bumap then do:

         if substring( bumap.cc, i_ix, 1 ) = string( i_idir ) then
            return false.

         substring( bumap.cc, i_ix, 1 ) = string( i_idir ).

         return true.

      end.

   end method.

   method int getX ( i_y as int ):

      var int ix.

      define buffer bumap for ttmap.

      find bumap where bumap.iy = i_y.

      do ix = 1 to length( bumap.cc ):

         if       substring( bumap.cc, ix, 1 ) <> '#'
            and   substring( bumap.cc, ix, 1 ) <> '.'
         then
            return ix.

      end.

   end method.

end class.