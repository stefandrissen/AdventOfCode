class 03.two:

   constructor two ():

      var longchar lcinput.

      session:appl-alert-boxes = true.

      // lcinput = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))".
      copy-lob from file '03/input.txt' to lcinput.

      message mull( lcinput ).

   end constructor.

   method int mull ( i_lc as longchar ):

      var int ires, ix.
      var char cc, cpart.

      cc = removeDont( i_lc ).

      ix = ?.

      do while ix > 0 or ix = ?:

         if ix > 0 then do:

            cpart = substring( cc, ix + 4 ).
            cpart = entry( 1, cpart, ')' ).

            if num-entries( cpart ) = 2 then
               ires = ires + getInt( entry( 1, cpart ) ) * getInt( entry( 2, cpart ) ).

            ix = ix + 4.

         end.
         else
            ix = 1.

         ix = index( cc, 'mul(', ix ).

      end.

      return ires.

   end method.

   method int getInt( i_c as char ):

      if trim( i_c, '0123456789' ) = '' then
         return int( i_c ).

      return 0.

   end method.

   method char removeDont ( i_lc as longchar ):

      var char cc.
      var logical ldo.
      var int ix, ixn.

      ldo = true.
      ix = ?.

      do while ix > 0 or ix = ?:

         if ix = ? then
            ix = 1.

         if ldo then do:

            ixn = index( i_lc, "don't()", ix ).
            if ixn > 0 then
               cc = cc + substring( i_lc, ix, ixn - ix ).
            else
               cc = cc + substring( i_lc, ix ).

            ix = ixn.
            ldo = false.

         end.
         else do:

            ix = index( i_lc, 'do()', ix ).
            if ix > 0 then
               assign
                  ix    =  ix + 4
                  ldo   =  true
                  .

         end.

      end.

      return cc.

   end method.

end class.