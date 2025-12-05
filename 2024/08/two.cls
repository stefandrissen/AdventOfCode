class 08.two:

   define temp-table tt no-undo
      field cc as char case-sensitive
      field ix as int
      field iy as int

      index ix cc ix iy
      .

   var int iwidth, iheight.

   constructor two ():

      session:appl-alert-boxes = true.

      getAntennas( '08/input.txt' ). // 1232 is too low

      message calculateAntiNodes().

      plotAntiNodes().

   end constructor.

   method void getAntennas( i_cfile as char ):

      define buffer bu for tt.

      var int iy, ix, ilen.
      var char cline, cc.


      input from value( i_cfile ).

      repeat:

         import unformatted cline.
         iy = iy + 1.
         ilen = length( cline ).
         iwidth = max( iwidth, ilen ).
         do ix = 1 to ilen:

            cc = substring( cline, ix, 1 ).
            if cc <> '.' and cc <> '#' then do for bu:
               create bu.
               assign
                  bu.cc = cc
                  bu.ix = ix
                  bu.iy = iy
                  .
            end.

         end.

      end.

      input close.

      iheight = iy.

   end method.

   method int calculateAntinodes ():

      var int itotal.

      define buffer bu1 for tt.
      define buffer bu2 for tt.

      var int ix, iy, idx, idy.

      for each bu1,
         each bu2
            where bu2.cc = bu1.cc
            and   rowid( bu2 ) <> rowid( bu1 )
      :

         assign
            idx = bu2.ix - bu1.ix
            idy = bu2.iy - bu1.iy

            ix = bu2.ix
            iy = bu2.iy
            .

         do while ix >= 1 and ix <= iwidth
            and   iy >= 1 and iy <= iheight
         :

            assign
               ix = ix + idx
               iy = iy + idy
               .

            itotal = itotal + checkAntinode( bu1.cc, ix, iy ).

         end.

         // reverse traverse to pick up the towers themselves

         assign
            ix = ix - idx
            iy = iy - idy
            .

         do while ix >= 1 and ix <= iwidth
            and   iy >= 1 and iy <= iheight
         :

            assign
               ix = ix - idx
               iy = iy - idy
               .

            itotal = itotal + checkAntinode( bu1.cc, ix, iy ).

         end.

      end.

      return itotal.

   end method.

   define temp-table ttan no-undo
      field ix as int
      field iy as int

      index ix ix iy
      .

   method int checkAntinode( cc as char, ix as int, iy as int ):

      define buffer bu for ttan.

      if       ix >= 1 and ix <= iwidth
         and   iy >= 1 and iy <= iheight
         and   not can-find( bu where bu.ix = ix and bu.iy = iy )
      then do:

         create bu.
         assign
            bu.ix = ix
            bu.iy = iy
            .
         return 1.

      end.

      return 0.

   end method.

   method void dumpNodes ():
      temp-table ttan:write-json( 'file', 'nodes', true ).
   end method.

   method void plotAntiNodes ():

      define buffer bu for tt.
      define buffer buan for ttan.

      var char cc.
      var int iy.

      output to 'nodes.txt'.

      do iy = 1 to iheight:

         cc = fill( '.', iwidth ).

         for each bu where bu.iy = iy:
            substring( cc, bu.ix, 1 ) = bu.cc.
         end.

         for each buan where buan.iy = iy:
            substring( cc, buan.ix, 1 ) = '#'.
         end.

         put unformatted cc skip.

      end.

      output close.

   end method.

end class.