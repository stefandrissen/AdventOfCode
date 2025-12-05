class 16.one:

   var int xe, ye, iheight, iwidth.

   define temp-table ttmap
      field x as int
      field y as int
      field c as char
      field score as int

      index ix1 is unique x y
      index ix2 c
      .

   constructor one ():

      var int xs, ys.

      session:appl-alert-boxes = true.

      output to '16/output.txt' unbuffered.

      readInput( '16/example.txt', output xs, output ys ).

      fillDeadEnds().

      // dumpMap( xs, ys, 1, 0 ).

      walkMaze( 0, xs, ys, 1, '' ).

      define buffer bu for ttmap.

      find bu where bu.c = 'E'.

      dumpMap( xs, ys, 1, bu.score ).

      output close.

   end constructor.

   method void readInput ( cfile as char, output xs as int, output ys as int ):

      define buffer bu for ttmap.

      var int ix, iy, icols.
      var char cmap, cc.

      input from value( cfile ).

      repeat:

         import unformatted cmap.

         assign
            icols = length( cmap )
            iwidth = maximum( icols, iwidth )
            .

         do ix = 1 to icols:

            cc = substring( cmap, ix, 1 ).

            if cc <> '#' then do for bu:

               create bu.
               assign
                  bu.x = ix - 1
                  bu.y = iy
                  bu.c = cc
                  bu.score = ?
                  .
               if cc = 'S' then
                  assign
                     xs = bu.x
                     ys = bu.y
                     .

            end.

         end.

         assign
            cmap  =  ''
            iy    =  iy + 1
            .

      end.

      iheight = iy.

   end method.

   method void walkMaze ( iscore as int, i_x as int, i_y as int, i_idir as int, cpath as character ):

      define buffer bu for ttmap.

      //                 >  v   <   ^
      var int [4] dx = [ 1, 0, -1,  0 ].
      var int [4] dy = [ 0, 1,  0, -1 ].
      var int idir, x, y, itry, ix.
      var int imin = ?.

      do for bu:

         find bu where bu.x = i_x and bu.y = i_y no-error.
         if not available bu or bu.score <= iscore then
            return.

         if bu.c <> 'S' then
            bu.score = iscore.

         if bu.c = 'E' then
            return.

      end.

      dumpMap( i_x, i_y, i_idir, iscore ).

      assign
         x     =  i_x
         y     =  i_y
         idir  =  i_idir
         .

      do while paths( x, y ) = 2:

         _singlepath:
         do ix = 1 to 4:

            if absolute( idir - ix ) <> 2 then do for bu:

               find bu
                  where bu.x = x + dx [ix]
                  and   bu.y = y + dy [ix]
               no-error.
               if available bu then do:

                  if bu.score = ? or bu.score < ( iscore + if ix = idir then 1 else 1001 ) then do:

                     assign
                        bu.score =  0 when bu.score =?
                        bu.score += 1
                        bu.score += 1000 when idir <> ix

                        x = x + dx [ix]
                        y = y + dy [ix]

                        idir = ix
                        iscore = bu.score
                        .

                     if bu.c = 'E' then
                        return.

                     leave _singlepath.

                  end.

               end.

            end.

         end.

      end.

      do ix = 1 to 4:

         if absolute( idir - ix ) <> 2 then do:

            walkMaze(
               iscore + 1 + if ix = idir then 0 else 1000,
               x + dx [ix],
               y + dy [ix],
               idir,
               cpath
            ).

         end.

      end.

   end method.

   method int paths ( x as int, y as int ):

      var int ipaths.

      define buffer bu for ttmap.

      assign
         ipaths = 0
         ipaths += 1 when can-find( bu where bu.x = x + 1 and bu.y = y     )
         ipaths += 1 when can-find( bu where bu.x = x     and bu.y = y + 1 )
         ipaths += 1 when can-find( bu where bu.x = x - 1 and bu.y = y     )
         ipaths += 1 when can-find( bu where bu.x = x     and bu.y = y - 1 )
         .

      return ipaths.

   end method.

   method void fillDeadEnds ():

      define buffer bu for ttmap.

      var logical lupdated = true.

      do while lupdated:

         lupdated = false.

         for each bu where bu.c = '.':

            if paths( bu.x, bu.y ) <= 1 then do:

               delete bu.
               lupdated = true.

            end.

         end.

      end.

   end method.

   method void dumpMap ( xs as int, ys as int, idir as int, iscore as int ):

      define buffer bu for ttmap.

      var char cdir = '>v<^'.

      var int iy.
      var char cmap.

      message iscore skip.

      do iy = 0 to iheight - 1:

         cmap = fill( '#', iwidth ).

         for each bu where bu.y = iy:
            substring( cmap, bu.x + 1, 1 ) = bu.c.
         end.

         if iy = ys then
            substring( cmap, xs + 1, 1 ) = substring( cdir, idir, 1 ).

         put unformatted cmap skip.

      end.

      put unformatted skip(1).

   end method.

end class.