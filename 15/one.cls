class 15.one:

   var int iwidth, iheight.

   define temp-table ttmap no-undo
      field x as int
      field y as int
      field c as char

      index ix is unique x y
      index iy y x
      .

   constructor one ():

      session:appl-alert-boxes = true.

      output to 'output.txt'.

      moveRobot( readInput( '15/input.txt' ) ).

      message calcSumGPS().

      dumpMap().

      output close.

   end constructor.

   method char readInput ( cfile as char ):

      define buffer bu for ttmap.

      var int ix, iy.
      var char cline, cmoves.
      var logical lmoves.

      input from value( cfile ).

      repeat:

         import unformatted cline.

         if cline = '' then
            assign
               iheight = iy - 1
               lmoves = true
               .

         if lmoves then
            cmoves = cmoves + cline.

         else do:

            do ix = 1 to length( cline ):

               do for bu:
                  create bu.
                  assign
                     bu.x = ix - 1
                     bu.y = iy
                     bu.c = substring( cline, ix, 1 )
                     .
               end.

            end.

            iy += 1.

         end.

      end.

      input close.

      return cmoves.

   end method.

   method void moveRobot ( cmoves as char ):

      define buffer bu for ttmap.

      var int x, y, ix, imoves, imove.

      var char cmove = '<^>v'.
      var int [4] dx = [ -1,  0, 1, 0 ].
      var int [4] dy = [  0, -1, 0, 1 ].


      find bu where bu.c = '@'.
      assign
         x = bu.x
         y = bu.y
         bu.c = '.'
         .

      imoves = length( cmoves ).
      do ix = 1 to imoves:

         imove = index( cmove, substring( cmoves, ix, 1 ) ).
         if moveRobot( x, y, dx[imove], dy[imove] ) then
            assign
               x = x + dx[imove]
               y = y + dy[imove]
               .

      end.

      find bu where bu.x = x and bu.y = y.
      bu.c = '@'.

   end method.

   method logical moveRobot ( i_x as int, i_y as int, i_dx as int, i_dy as int ):

      define buffer bu1 for ttmap.
      define buffer bu2 for ttmap.

      var int ix, iy.

      ix = i_x + i_dx.
      iy = i_y + i_dy.

      find bu1 where bu1.x = ix and bu1.y = iy.

      if bu1.c = '#' then
         return false.

      if bu1.c = '.' then
         return true.

      if findSpace( ix, iy, i_dx, i_dy ) then do:

         if i_dx = 1 then
            find first bu2 where bu2.y = iy and bu2.x > ix and bu2.c = '.'.

         else if i_dx = -1 then
            find last bu2 where bu2.y = iy and bu2.x < ix and bu2.c = '.'.

         else if i_dy = 1 then
            find first bu2 where bu2.x = ix and bu2.y > iy and bu2.c = '.'.

         else if i_dy = -1 then
            find last bu2 where bu2.x = ix and bu2.y < iy and bu2.c = '.'.

         else
            message 'oops'.

         assign
            bu2.c = bu1.c
            bu1.c = '.'
            .

         return true.

      end.

      return false.

   end method.

   method logical findSpace( i_x as int, i_y as int, i_dx as int, i_dy as int ):

      define buffer bu for ttmap.

      var int ix, iy.

      ix = i_x + i_dx.
      iy = i_y + i_dy.

      find bu where bu.x = ix and bu.y = iy.

      case bu.c:
         when '.' then return true.
         when '#' then return false.
         when 'O' then return findSpace( ix, iy, i_dx, i_dy ).
      end case.

      message 'oops'.

   end method.

   method int calcSumGPS (
   ):

      var int isum.

      define buffer bu for ttmap.

      for each bu where bu.c = 'O':

         isum = isum + 100 * bu.y + bu.x.

      end.

      return isum.

   end method.

   method void dumpMap ():

      define buffer bu for ttmap.

      var char cmap.
      var int iy.

      do iy = 0 to iheight:

         cmap = fill( '.', iwidth ).

         for each bu where bu.y = iy:
            substring( cmap, bu.x + 1, 1 ) = bu.c.
         end.

         put unformatted cmap skip.

      end.

   end method.

end class.