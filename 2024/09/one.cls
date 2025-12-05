class 09.one:

   define stream strdebug.

   constructor one ():

      session:appl-alert-boxes = true.

      message checkSum( freeSpace( createMap( '09/input.txt' ) ) ).

   end constructor.

   method longchar createMap( i_cfile as char ):

      var longchar cmap.
      var char cc.
      var int ilen, ix, id.

      fix-codepage( cmap ) = 'iso8859-1'. // single byte codepage to prevent dreadful utf-8 performance

      input from value( i_cfile ).
      import unformatted cc.
      input close.

      ilen = length( cc ).
      do ix = 1 to ilen by 2:

         assign
            cmap  =  cmap
                     // thank you simple example, input contains 10000 blocks
                  +  fill( string( id, '9999' ), int( substring( cc, ix, 1 ) ) )
                  +  fill( '.', 4 * int( substring( cc, ix + 1, 1 ) ) )

            id = id + 1
            .

      end.

      return cmap.

   end method.

   method longchar freeSpace( cmap as longchar ):

      var int ifrom, ito, ix, iy.
      var char cc.

      assign
         ifrom =  length( cmap )
         ito   =  1
         .

      do while index( cmap, '....' ) > 0:

         _sector:
         do ix = ifrom - 3 to 1 by -4:

            cc = substring( cmap, ix, 4 ).
            if cc <> '.' then do:

               do iy = ito to ix by 4:

                  if substring( cmap, iy, 4 ) = '....' then do:
                     substring( cmap, iy, 4 ) = cc.
                     substring( cmap, ix, 4 ) = ''.
                     ito = iy.
                     next _sector.
                  end.

               end.

            end.

         end.

      end.

      return cmap.

   end method.

   method int64 checkSum ( cmap as longchar ):

      var int64 isum.
      var int ilen, ix.

      ilen = length( cmap ).
      do ix = 1 to ilen by 4:

         isum = isum + ( ix - 1 ) / 4 * int( substring( cmap, ix, 4 ) ).

      end.

      return isum.

   end method.

end class.