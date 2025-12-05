class 12.two:

   var int iheight, iwidth.
   var char [] cplot.

   constructor two ():

      session:appl-alert-boxes = true.

      readPlots( '12/example.txt' ).
      message calcCost(). // 854870 = too low

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

   define temp-table ttdone no-undo
      field ix as int
      field iy as int

      index idx is unique ix iy
      .

   method int calcCost ():

      var int icost.
      var int ifences, iarea, ix, iy.
      var char ccrop.

      define buffer bu for ttdone.

      do iy = 1 to iheight:

         do ix = 1 to iwidth:

            ccrop = substring( cplot [iy], ix, 1 ).
            if ccrop <> '#' and ccrop <> '.' then do:

               iarea    =  getArea( ccrop, ix, iy ).
               dumpPlots().

               ifences = getCorners( ix, iy ).
               icost = icost + ifences * iarea.

               output to '12/plots.log' append.
               put unformatted ccrop ' ' iarea ' ' ifences skip(1).
               output close.

               for each bu:
                  substring( cplot [bu.iy], bu.ix, 1 ) = '.'.
                  delete bu.
               end.

            end.

         end.

      end.

      return icost.

   end method.

   method int getArea ( i_ccrop as char, ix as int, iy as int ):

      var int iarea.
      var char ccrop, cc.

      cc = i_ccrop.

      if ix < 1 or ix > iwidth or iy < 1 or iy > iheight then
         return 0.

      ccrop = substring( cplot [iy], ix, 1 ).
      if ccrop = i_ccrop then do:

         substring( cplot [iy], ix, 1 ) = '#'.

         iarea = iarea + 1.

         iarea = iarea + getArea( i_ccrop, ix + 1, iy     ).
         iarea = iarea + getArea( i_ccrop, ix    , iy + 1 ).
         iarea = iarea + getArea( i_ccrop, ix - 1, iy     ).
         iarea = iarea + getArea( i_ccrop, ix    , iy - 1 ).

      end.

      return iarea.

   end method.


   method int getCorners ( ix as int, iy as int ):

      var int ifences.
      var char ccrop, cc.

      define buffer bu for ttdone.

      if ix < 1 or ix > iwidth or iy < 1 or iy > iheight then
         return 0.

      ccrop = substring( cplot [iy], ix, 1 ).
      if ccrop = '#' and not can-find( bu where bu.ix = ix and bu.iy = iy )then do:

         do for bu:
            create bu.
            assign bu.ix = ix bu.iy = iy.
         end.

         ifences = ifences + cornerTopLeft( ix, iy ).
         ifences = ifences + cornerTopRight( ix, iy ).
         ifences = ifences + cornerBottomRight( ix, iy ).
         ifences = ifences + cornerBottomLeft( ix, iy ).

         ifences = ifences + getCorners( ix + 1, iy     ).
         ifences = ifences + getCorners( ix    , iy + 1 ).
         ifences = ifences + getCorners( ix - 1, iy     ).
         ifences = ifences + getCorners( ix    , iy - 1 ).

      end.

      return ifences.

   end method.

   method int cornerTopLeft( ix as int, iy as int ):

      var int icorners.

      if getCrop( ix - 1, iy - 1 ) = '#' then
         return 0.

      // outer
      if       getCrop( ix - 1, iy     ) <> '#'
         and   getCrop( ix    , iy - 1 ) <> '#'
      then
         icorners += 1.

      // inner
      if       getCrop( ix - 1, iy     ) = '#'
         and   getCrop( ix    , iy - 1 ) = '#'
      then
         icorners += 1.

      return icorners.

   end method.

   method int cornerTopRight( ix as int, iy as int ):

      var int icorners.

      if getCrop( ix + 1, iy - 1 ) = '#' then
         return 0.

      if       getCrop( ix    , iy - 1 ) <> '#'
         and   getCrop( ix + 1, iy     ) <> '#'
      then
         icorners += 1.

      if       getCrop( ix    , iy - 1 ) = '#'
         and   getCrop( ix + 1, iy     ) = '#'
      then
         icorners += 1.

      return icorners.

   end method.

   method int cornerBottomRight( ix as int, iy as int ):

      var int icorners.

      if getCrop( ix + 1, iy + 1 ) = '#' then
         return 0.

      if       getCrop( ix + 1, iy     ) <> '#'
         and   getCrop( ix    , iy + 1 ) <> '#'
      then
         icorners += 1.

      if       getCrop( ix + 1, iy     ) = '#'
         and   getCrop( ix    , iy + 1 ) = '#'
      then
         icorners += 1.

      return icorners.

   end method.

   method int cornerBottomLeft( ix as int, iy as int ):

      var int icorners.

      if getCrop( ix - 1, iy + 1 ) = '#' then
         return 0.

      if       getCrop( ix    , iy + 1 ) <> '#'
         and   getCrop( ix - 1, iy     ) <> '#'
      then
         icorners += 1.

      if       getCrop( ix    , iy + 1 ) = '#'
         and   getCrop( ix - 1, iy     ) = '#'
      then
         icorners += 1.

      return icorners.

   end method.

   method char getCrop( ix as int, iy as int ):

      if iy < 1 or iy > iheight or ix < 1 or ix > iwidth then
         return ?.

      return substring( cplot [iy], ix, 1 ).

   end method.

   method void dumpPlots ():

      var int iy.

      output to '12/plots.log' append.

      do iy = 1 to iheight:
         put unformatted cplot [iy] skip.
      end.

      put unformatted skip(1).

      output close.

   end method.

end class.

