block-level on error undo, throw.

class 03.one:

   constructor one ():

      var longchar lcinput.

      session:appl-alert-boxes = true.

      // lcinput = 'xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))'.
      copy-lob from file '03/input.txt' to lcinput.

      message mull( lcinput ).

      catch e as Progress.Lang.Error:
         message e:getMessage(1).
      end catch.

   end constructor.

   method int mull ( i_c as longchar ):

      var int ires, ix.
      var char cpart.

      ix = ?.

      do while ix > 0 or ix = ?:

         if ix > 0 then do:

            cpart = substring( i_c, ix + 4 ).
            cpart = entry( 1, cpart, ')' ).

            if num-entries( cpart ) = 2 then
               ires = ires + getInt( entry( 1, cpart ) ) * getInt( entry( 2, cpart ) ).

            ix = ix + 4.

         end.
         else
            ix = 1.

         ix = index( i_c, 'mul(', ix ).

      end.

      return ires.

   end method.

   method int getInt( i_c as char ):

      if trim( i_c, '0123456789' ) = '' then
         return int( i_c ).

      return 0.

   end method.

end class.