class 06.one:

   var int p_iwalked.

   constructor one ():

      var int iy.

      session:appl-alert-boxes = true.

      iy = readMap( '06/input.txt' ).

      walkMap( getX( iy ), iy ).

      message p_iwalked.

   end constructor.

   define temp-table ttmap no-undo
      field iy as int
      field cc as char

      index ix iy
      .

   method int readMap ( i_cfile as char ):

      define buffer bumap for ttmap.

      var int iy, iyg.

      input from value( i_cfile ).

      repeat for bumap:

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

   method void walkMap ( i_x as int, i_y as int ):

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

      do while cc <> ?:

         setMap( ix, iy ).

         cc = getMap( ix + idx [idir], iy + idy [idir] ).
         if cc = '#' then do:

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

   end method.

   method char getMap ( i_ix as int, i_iy as int ):

      define buffer bumap for ttmap.

      if i_ix > 0 then
         find bumap where bumap.iy = i_iy no-error.

      if available bumap and i_ix <= length( bumap.cc ) then
         return substring( bumap.cc, i_ix, 1 ).

   end method.


   method void setMap ( i_ix as int, i_iy as int ):

      define buffer bumap for ttmap.

      find bumap where bumap.iy = i_iy no-error.
      if       available bumap
         and   substring( bumap.cc, i_ix, 1 ) <> 'X'
      then
         assign
            substring( bumap.cc, i_ix, 1 ) = 'X'
            p_iwalked = p_iwalked + 1
            .

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