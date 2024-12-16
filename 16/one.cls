class 16.one:

   var char [] cmap.
   var int xe, ye.

   constructor one ():

      var int xs, ys, iscore.

      session:appl-alert-boxes = true.

      output to '16/output.txt'.

      readInput( '16/input.txt', output xs, output ys ).
      iscore = walkMaze( 0, xs, ys, 1, '' ).

      dumpMap( xs, ys, 1, iscore ).

      output close.

   end constructor.

   method char readInput ( cfile as char, output xs as int, output ys as int ):

      var int ix, iy, irows.
      var longchar lcmap.

      copy-lob from file cfile to lcmap.

      irows = num-entries( lcmap, '~n' ).

      extent( cmap ) = irows.

      do iy = 1 to irows:

         cmap [iy] = trim( entry( iy, lcmap, '~n' ) ).

         ix = index( cmap [iy], 'E' ).
         if ix > 0 then
            assign
               xe = ix
               ye = iy
               ix = 0
               .
         ix = index( cmap [iy], 'S' ).
         if ix > 0 then
            assign
               xs = ix
               ys = iy
               ix = 0
               .

      end.

   end method.

   method int walkMaze ( iscore as int, i_x as int, i_y as int, i_idir as int, cpath as character ):

      //                 >  v   <   ^
      var int [4] dx = [ 1, 0, -1,  0 ].
      var int [4] dy = [ 0, 1,  0, -1 ].
      var int idir, x, y, itry.
      var int imin = ?.

      if substring( cmap [i_y], i_x, 1 ) = 'S' and iscore > 0 then
         return ?.

      if index( cpath, substitute( '(&1,&2)', i_x, i_y ) ) > 0 then
         return ?.

      cpath = cpath + substitute( '(&1,&2)', i_x, i_y ).

      case substring( cmap [i_y], i_x, 1 ):

         when '#' then
            return ?.

         when '.' or when 'S' then do:

            // dumpMap( i_x, i_y, i_idir, iscore ).

            do idir = 1 to 4:

               itry  =  walkMaze(
                           iscore + 1 + ( if i_idir = idir then 0 else if absolute( i_idir - idir ) = 2 then 2000 else 1000 ),
                           i_x + dx [idir],
                           i_y + dy [idir],
                           idir,
                           cpath
                        ).

               if itry <> ? then do:

                  if imin = ? then
                     imin = itry.
                  else
                     imin = minimum( imin, itry ).

               end.

            end.

            if imin > 0 then
               iscore = imin.
            else
               iscore = ?.

         end.

      end case.

      return iscore.

   end method.


   method void dumpMap ( xs as int, ys as int, idir as int, iscore as int ):

      var char cdir = '>v<^'.

      var int iy.
      var char cc.

      message iscore skip.

      do iy = 1 to extent( cmap ):
         cc = cmap [iy].
         if iy = ys then
            substring( cc, xs, 1 ) = substring( cdir, idir, 1 ).
         put unformatted cc skip.
      end.
      put unformatted skip(1).

   end method.

end class.