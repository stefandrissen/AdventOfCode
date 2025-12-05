class 11.one:

   constructor one ():

      var int ix.
      var char cstones.
      var longchar lcstones.

      session:appl-alert-boxes = true.
      fix-codepage( lcstones ) = 'iso8859-1'.

      input from '11/input.txt'.
      import unformatted cstones.
      input close.
      lcstones = cstones.

      do ix = 1 to 25:

         lcstones = blink( lcstones ).
         // message cstones.

      end.

      message num-entries( lcstones, ' ' ).

   end constructor.

   method longchar blink ( cstones as longchar ):

      var int ix, ilen.
      var char cstone, cnew.

      do ix = num-entries( cstones, ' ' ) to 1 by -1:

         assign
            cstone   =  entry( ix, cstones, ' ' )
            ilen     =  length( cstone )
            .

         if cstone = '0' then
            cnew = '1'.

         else if ilen modulo 2 = 0 then
            assign
               ilen  =  ilen / 2
               cnew  =  substring( cstone, 1, ilen )
                     +  ' '
                     +  string( int64( substring( cstone, 1 + ilen ) ) )
                     .
         else
            cnew = string( 2024 * int64( cstone ) ).

         entry( ix, cstones, ' ' ) = cnew.

      end.

      return cstones.

   end method.

end class.