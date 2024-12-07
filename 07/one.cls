class 07.one:

   constructor one ():

      var int iy.

      session:appl-alert-boxes = true.

      message readCalibration( '07/input.txt' ).

   end constructor.

   method int64 readCalibration ( i_cfile as char ):

      var int64 itotal.
      var char ccal.

      input from value( i_cfile ).

      repeat:

         import unformatted ccal.

         itotal = itotal + getCalibration( ccal ).

      end.

      input close.

      return itotal.

   end method.

   method int64 getCalibration( i_ccal as char ):

      var int64 ires, itotal.
      var int ix, iparts, icombinations.
      var int [] ioperand.
      var char [] coperator.
      var char cc.

      assign
         ires = int64( entry( 1, i_ccal, ':' ) )

         cc = replace( trim( entry( 2, i_ccal, ':' ) ), ' ', ',' )
         iparts = num-entries( cc )
         .

      extent( ioperand ) = iparts.
      extent( coperator ) = iparts - 1.

      do ix = 1 to iparts:
         ioperand [ix] = int( entry( ix, cc ) ).
      end.

      // binary + = 0 * = 1

      icombinations = exp( 2, iparts - 1 ).

      do ix = 1 to icombinations:

         coperator = getCombination( ix, iparts - 1 ).

         if ires = calculateCalibration( ioperand, coperator ) then
            return ires.

      end.

      return 0.

   end method.

   method int64 calculateCalibration (
      ioperand as int extent,
      coperator as char extent
   ):

      var int64 itotal.
      var int ix, iparts.

      assign
         iparts = extent( ioperand )
         itotal = ioperand [1]
         .

      do ix = 2 to iparts:

         case coperator [ix - 1]:

            when '+' then
               itotal = itotal + ioperand [ix].

            when '*' then
               itotal = itotal * ioperand [ix].

         end case.

      end.

      return itotal.

   end method.

   method char extent getCombination (
      i_icombination as int,
      i_iparts       as int
   ):

      var char [] cc.
      var int ix, iremain.

      extent( cc ) = i_iparts.

      iremain = i_icombination.

      do ix = 1 to i_iparts:

         cc [ix] = ( if iremain modulo 2 = 0 then '+' else '*' ).
         iremain = truncate( iremain / 2, 0 ).

      end.

      return cc.

   end method.

end class.