class 04.two:

   var char [] p_crow.

   constructor two ():

      var longchar lcinput.

      session:appl-alert-boxes = true.

      copy-lob from file '04/input.txt' to lcinput.

      populateRows( lcinput ).

      message searchX-MAS().

   end constructor.

   method void populateRows ( i_lcinput as longchar ):

      var int irows, iy.

      irows = num-entries( i_lcinput, '~n' ).
      extent( p_crow ) = irows.

      do iy = 1 to irows:

         p_crow [iy] = entry( iy, i_lcinput, '~n' ).

      end.

   end method.

   method int searchX-MAS(
   ):

      var int ires.
      var int ix, iy.

      do iy = 1 to extent( p_crow ):

         do ix = 1 to length( p_crow [iy] ):

            if getChar( ix, iy ) = 'a' then do:

               if       getChar( ix - 1, iy - 1 ) = 'm'
                  and   getChar( ix + 1, iy + 1 ) = 's'

                  or    getChar( ix - 1, iy - 1 ) = 's'
                  and   getChar( ix + 1, iy + 1 ) = 'm'
               then do:

                  if       getChar( ix + 1, iy - 1 ) = 'm'
                     and   getChar( ix - 1, iy + 1 ) = 's'

                     or    getChar( ix + 1, iy - 1 ) = 's'
                     and   getChar( ix - 1, iy + 1 ) = 'm'

                  then
                     ires = ires + 1.

               end.

            end.

         end.

      end.

      return ires.

   end method.

   method char getChar (
      i_ix as int,
      i_iy as int
   ):

      if       i_iy > 0 and i_iy <= extent( p_crow )
         and   i_ix > 0 and i_ix <= length( p_crow [i_iy] )
      then
         return substring( p_crow [i_iy], i_ix, 1 ).

   end method.

end class.