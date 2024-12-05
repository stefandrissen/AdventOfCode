class 04.one:

   var char [] p_crow.

   constructor one ():

      var longchar lcinput.

      session:appl-alert-boxes = true.

      copy-lob from file '04/input.txt' to lcinput.

      populateRows( lcinput ).

      // output to 'c:/temp/debug.log'.

      message searchWord( 'xmas' ).

      // output close.

   end constructor.

   method void populateRows ( i_lcinput as longchar ):

      var int irows, iy.

      irows = num-entries( i_lcinput, '~n' ).
      extent( p_crow ) = irows.

      do iy = 1 to irows:

         p_crow [iy] = entry( iy, i_lcinput, '~n' ).

      end.

   end method.

   method int searchWord(
      i_csearch   as char
   ):

      var int ires.
      var int ix, iy.

      do iy = 1 to extent( p_crow ):

         do ix = 1 to length( p_crow [iy] ):

            ires = ires + searchWord( ix, 0, iy, 0, i_csearch ).

         end.

      end.

      return ires.

   end method.

   method int searchWord(
      i_ix        as int,
      i_iacross   as int,
      i_iy        as int,
      i_idown     as int,
      i_csearch   as char
   ):

      var int ires.
      var int irows, ilines, iline, ilen, ix, iy.
      var char cremaining.

      put unformatted i_ix ~t i_iacross ~t i_iy ~t i_idown ~t i_csearch skip.

      if i_csearch = '' then
         return 1.

      assign
         ix = i_ix + i_iacross
         iy = i_iy + i_idown
         .

      if       iy > 0   and   iy <= extent( p_crow )
         and   ix > 0   and   ix <= length( p_crow [iy] )
         and   substring( p_crow [iy], ix, 1 ) = substring( i_csearch, 1, 1 )
      then do:

         cremaining = substring( i_csearch, 2 ).

         if i_iacross = 0 and i_idown = 0 then do:

            ires = ires + searchWord( ix,  1, iy,  0, cremaining ).
            ires = ires + searchWord( ix,  1, iy,  1, cremaining ).
            ires = ires + searchWord( ix,  0, iy,  1, cremaining ).
            ires = ires + searchWord( ix, -1, iy,  1, cremaining ).
            ires = ires + searchWord( ix, -1, iy,  0, cremaining ).
            ires = ires + searchWord( ix, -1, iy, -1, cremaining ).
            ires = ires + searchWord( ix,  0, iy, -1, cremaining ).
            ires = ires + searchWord( ix,  1, iy, -1, cremaining ).

         end.
         else
            ires = ires + searchWord( ix, i_iacross, iy, i_idown, cremaining ).

      end.

      return ires.

   end method.

end class.