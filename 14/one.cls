class 14.one:

   var int iwidth, iheight.

   define temp-table ttrobots no-undo
      field id as int
      field x as int
      field y as int
      field vx as int
      field vy as int

      index ix is unique id
      .

   constructor one ():

      session:appl-alert-boxes = true.

      output to 'output.txt'.

      // readInput( '14/example.txt' ). assign iwidth = 11 iheight = 7.
      readInput( '14/input.txt' ). assign iwidth = 101 iheight = 103.

      waitSeconds( 100 ).

      message calcSafetyFactor().

      dumpPositions().

      output close.

   end constructor.

   method void readInput ( cfile as char ):

      define buffer bu for ttrobots.

      var int id.
      var char cloc, cspeed.

      input from value( cfile ).

      repeat:

         import cloc cspeed.

         cloc     =  entry( 2, cloc, '=' ).
         cspeed   =  entry( 2, cspeed, '=' ).

         do for bu:
            create bu.
            assign
               bu.id =  id
               bu.x  =  int( entry( 1, cloc ) )
               bu.y  =  int( entry( 2, cloc ) )
               bu.vx =  int( entry( 1, cspeed ) )
               bu.vy =  int( entry( 2, cspeed ) )

               id += 1
               .
         end.

      end.

      input close.

   end method.

   method void waitSeconds ( iseconds as int ):

      define buffer bu for ttrobots.

      var int ix.

      do ix = 1 to iseconds:

         for each bu:

            assign
               bu.x = ( bu.x + bu.vx ) modulo iwidth
               bu.y = ( bu.y + bu.vy ) modulo iheight
               .

         end.

      end.

   end method.

   method int calcSafetyFactor (
   ):

      define buffer bu for ttrobots.

      var int [4] irobots.
      var int icx, icy.
      var int q.

      icx = truncate( iwidth / 2, 0 ).
      icy = truncate( iheight / 2, 0 ).

      for each bu:

         if bu.x <> icx and bu.y <> icy then
            assign
               q  =  1
               q  += 1  when bu.x > icx
               q  += 2  when bu.y > icy

               irobots[q] += 1
               .

      end.

      return irobots[1] * irobots[2] * irobots[3] * irobots[4].

   end method.

   method void dumpPositions ():

      define buffer bu for ttrobots.

      var char [] cmap.
      var int ix.

      extent( cmap ) = iheight.
      cmap = fill( '.', iwidth ).

      for each bu:
         substring( cmap[ bu.y + 1 ], bu.x + 1, 1 ) = string( int( substring( cmap[ bu.y + 1 ], bu.x + 1, 1 ) ) + 1 ).
      end.

      do ix = 1 to iheight:
         put unformatted cmap[ix] skip.
      end.

   end method.

end class.