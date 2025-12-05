class 07.two:

   constructor two ():

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

      icombinations = exp( 3, iparts - 1 ).

      do ix = 1 to icombinations:

         coperator = getCombination( ix, iparts - 1 ).

         if ires = calculateCalibration( ires, ioperand, coperator ) then
            return ires.

      end.

      return 0.

   end method.

   method int64 calculateCalibration (
      i_itotal as int64,
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

            when '||' then
               itotal = int64( string( itotal ) + string( ioperand [ix] ) ).

         end case.

         if itotal > i_itotal then
            return 0.

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

         case iremain modulo 3:
            when 0 then cc [ix] = '+'.
            when 1 then cc [ix] = '*'.
            when 2 then cc [ix] = '||'.
         end case.

         iremain = truncate( iremain / 3, 0 ).

      end.

      return cc.

   end method.

end class.