class 12.one:

   var int iheight, iwidth.
   var char [] cplot.

   constructor one ():

      session:appl-alert-boxes = true.

      readPlots( '12/input.txt' ).
      message calcCost().

   end constructor.

   method void readPlots ( cfile as char ):

      var int ix.
      var char cc.

      input from value( cfile ).
      repeat:
         import unformatted cc.
         assign
            iheight  =  iheight + 1
            iwidth   =  maximum( iwidth, length( cc ) )
            .
      end.
      input close.

      extent( cplot ) = iheight.

      input from value( cfile ).

      repeat:
         ix = ix + 1.
         import unformatted cplot [ix].
      end.
      input close.

   end method.

   method int calcCost ():

      var int icost.
      var int ifences, iarea, ix, iy.
      var char ccrop.

      do iy = 1 to iheight:

         do ix = 1 to iwidth:

            ccrop = substring( cplot [iy], ix, 1 ).
            if compare( ccrop, '=', upper( ccrop ), 'case-sensitive' ) then do:
               assign
                  iarea    =  0
                  ifences  =  calcFences( ccrop, ix, iy, input-output iarea )
                  icost    =  icost + ifences * iarea
                  .
               // dumpPlots( ccrop, iarea, ifences ).
            end.

         end.

      end.

      return icost.

   end method.

   method int calcFences ( i_ccrop as char, ix as int, iy as int, input-output iarea as int ):

      var int ifences.
      var char ccrop.

      if ix < 1 or ix > iwidth or iy < 1 or iy > iheight then
         return 1.

      ccrop = substring( cplot [iy], ix, 1 ).
      if compare( ccrop, '=', i_ccrop, 'case-sensitive' ) then do:

         substring( cplot [iy], ix, 1 ) = lc( ccrop ).
         iarea = iarea + 1.

         ifences = ifences + calcFences( i_ccrop, ix + 1, iy    , input-output iarea ).
         ifences = ifences + calcFences( i_ccrop, ix    , iy + 1, input-output iarea ).
         ifences = ifences + calcFences( i_ccrop, ix - 1, iy    , input-output iarea ).
         ifences = ifences + calcFences( i_ccrop, ix    , iy - 1, input-output iarea ).

      end.
      else if ccrop <> i_ccrop then
         ifences = 1.

      return ifences.

   end method.

   method void dumpPlots ( ccrop as char, iarea as int, ifences as int ):

      var int iy.

      output to '12/plots.log' append.

      do iy = 1 to iheight:
         put unformatted cplot [iy] skip.
      end.

      put unformatted ccrop ' ' iarea ' ' ifences skip(1).

      output close.

   end method.

end class.