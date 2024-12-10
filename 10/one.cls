class 10.one:

   constructor one ():

      session:appl-alert-boxes = true.

      createMap( '10/input.txt' ).
      message findTrailheads().
//      dumpMap().

   end constructor.

   define temp-table ttmap undo
      field ix as int serialize-name 'x'
      field iy as int serialize-name 'y'
      field iz as int serialize-name 'z'

      index ix1 is unique ix iy
      index ix2 iz
      .

   method void createMap( i_cfile as char ):

      define buffer bu for ttmap.

      var char cc.
      var int iy, ilen, ix.

      input from value( i_cfile ).
      repeat:

         import unformatted cc.
         ilen = length( cc ).
         do ix = 1 to ilen:

            if substring( cc, ix, 1 ) <> '.' then do for bu:

               create bu.
               assign
                  bu.iy = iy
                  bu.ix = ix - 1
                  bu.iz = int( substring( cc, ix, 1 ) )
                  .

            end.

         end.

         iy = iy + 1.

      end.
      input close.

   end method.

   method int findTrailheads ():

      var int itotal.

      define buffer bu for ttmap.

      for each bu where bu.iz = 0:

         do transaction:

            itotal = itotal + findHigher( bu.ix, bu.iy, 0 ).

            undo.

         end.

      end.

      return itotal.

   end method.

   method int findHigher ( ix as int, iy as int, iz as int ):

      var int ipath.

      define buffer bu for ttmap.

      if iz > 0 then do:

         find bu where bu.ix = ix and bu.iy = iy and bu.iz = iz no-error.
         if not available bu then
            return 0.

         if bu.iz = 9 then do:
            bu.iz = -1.
            return 1.
         end.

      end.

      ipath = ipath + findHigher( ix + 1, iy     , iz + 1 ).
      ipath = ipath + findHigher( ix    , iy + 1 , iz + 1 ).
      ipath = ipath + findHigher( ix - 1, iy     , iz + 1 ).
      ipath = ipath + findHigher( ix    , iy - 1 , iz + 1 ).

      return ipath.

   end method.

   method void dumpMap ():

      temp-table ttmap:write-json( 'file', 'map.json', true ).

   end method.

end class.