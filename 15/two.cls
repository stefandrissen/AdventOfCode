class 15.two:

   var int ixrobot, iyrobot.

   define temp-table ttmap no-undo
      field x as int
      field y as int
      field c as char

      index ix is unique x y
      index iy y x
      .

   constructor two ():

      session:appl-alert-boxes = true.

      output to 'output.txt'.

      moveRobot( readInput( '15/input.txt' ) ). // 1439676 = too high

      message calcSumGPS().

      dumpMap().

      output close.

   end constructor.

   method char readInput ( cfile as char ):

      define buffer bu1 for ttmap.
      define buffer bu2 for ttmap.

      var int ix, iy.
      var char cline, cc, cmoves.
      var logical lmoves.

      input from value( cfile ).

      repeat:

         import unformatted cline.

         if cline = '' then
            lmoves = true.

         if lmoves then
            cmoves = cmoves + cline.

         else do:

            do ix = 1 to length( cline ):

               cc = substring( cline, ix, 1 ).
               if cc = '@' then
                  assign
                     ixrobot = ( ix - 1 ) * 2
                     iyrobot = iy
                     .

               else if cc <> '.' then do for bu1, bu2:

                  create bu1.
                  assign
                     bu1.x = ( ix - 1 ) * 2
                     bu1.y = iy
                     bu1.c = if cc = 'O' then '[' else cc
                     .
                  create bu2.
                  assign
                     bu2.x = bu1.x + 1
                     bu2.y = iy
                     bu2.c = if cc = 'O' then ']' else cc
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

      var int ix, imoves, imove.

      var char cmove = '<^>v'.
      var int [4] dx = [ -1,  0, 1, 0 ].
      var int [4] dy = [  0, -1, 0, 1 ].

      imoves = length( cmoves ).
      do ix = 1 to imoves:

         imove = index( cmove, substring( cmoves, ix, 1 ) ).
         if moveRobot( dx[imove], dy[imove] ) then
            assign
               ixrobot += dx[imove]
               iyrobot += dy[imove]
               .

      end.

   end method.

   method logical moveRobot ( i_dx as int, i_dy as int ):

      define buffer bu for ttmap.

      var int ix, iy.

      ix = ixrobot + i_dx.
      iy = iyrobot + i_dy.

      if not can-find( bu where bu.x = ix and bu.y = iy ) then
         return true.

      if not push( ix, iy, i_dx, i_dy ) then
         return false.

      return true.

   end method.

   method logical push( i_x as int, i_y as int, i_dx as int, i_dy as int ):

      if i_dx <> 0 then
         return pushHorizontal( i_x, i_y, i_dx ).

      if i_dy <> 0 then
         return pushVertical( i_x, i_y, i_dy ).

   end method.

   method logical pushHorizontal( i_x as int, i_y as int, i_dx as int ):

      define buffer bu for ttmap.

      find bu where bu.x = i_x and bu.y = i_y no-error.
      if not available bu then
         return true.

      if bu.c = '#' then
         return false.

      if pushHorizontal( i_x + i_dx, i_y, i_dx ) then do:
         bu.x = bu.x + i_dx.
         return true.
      end.

      return false.

   end method.

   method logical pushVertical( i_x as int, i_y as int, i_dy as int ):

      define buffer bu for ttmap.
      var int ioffset = 1.

      find bu where bu.x = i_x and bu.y = i_y no-error.
      if not available bu then
         return true.

      if bu.c = '#' then
         return false.

      if bu.c = ']' then ioffset = -1.

      if       pushVertical( i_x          , i_y + i_dy, i_dy )
         and   pushVertical( i_x + ioffset, i_y + i_dy, i_dy )
      then do:

         bu.y = bu.y + i_dy.
         find bu where bu.x = i_x + ioffset and bu.y = i_y.
         bu.y = bu.y + i_dy.
         return true.

      end.

      return false.

   end method.

   method int calcSumGPS (
   ):

      var int isum.

      define buffer bu for ttmap.

      for each bu where bu.c = '[':

         isum = isum + 100 * bu.y + bu.x.

      end.

      return isum.

   end method.

   method void dumpMap ():

      define buffer bu for ttmap.

      var char cmap.

      for each bu break by bu.y:

         substring( cmap, bu.x + 1, 1 ) = bu.c.

         if last-of( bu.y ) then do:

            if bu.y = iyrobot then
               substring( cmap, ixrobot + 1, 1 ) = '@'.

            put unformatted cmap skip.

            cmap = ''.

         end.

      end.

   end method.

end class.