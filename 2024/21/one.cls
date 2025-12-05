class 21.one:

   constructor one ():

      var char ccode.
      var int isum, ipresses, icomplexity.

      output to '21/output.txt'.
      input from '21/example.txt'.

      repeat:

         import ccode.

         ipresses = getPresses( ccode ).
         icomplexity = int( trim( ccode, 'A' ) ) * ipresses.

         message ccode ipresses icomplexity skip(2).
         isum  += icomplexity.

      end.

      message isum. // 203618 is too low

      input close.
      output close.

   end constructor.

   method int getPresses ( ccode as char ):

      var int ipresses, x, y, ix, inum, irobot.
      var char ckey.
      var char [3] ckeypad.

      message ccode.

      do irobot = 1 to 3:

         assign
            x = 2
            y = if irobot = 1 then 0 else 1
            .

         do ix = 1 to length( ccode ):

            ckey = substring( ccode, ix, 1 ).
            ckeypad [irobot] += getPresses( irobot = 1, ckey, input-output x, input-output y ).

         end.

         ccode = ckeypad [irobot].

         message ccode.

      end.

      message skip(1).

      return length( ccode ).

   end method.

   method char getPresses ( lnum as logical, ckey as char, input-output x as int, input-output y as int ):

      var int xn, yn.
      var char cpresses.

      getPos( lnum, ckey, output xn, output yn ).
      assign
         cpresses += move( lnum, x, y, xn, yn )
         x = xn
         y = yn
         .

      return cpresses + 'A'.

   end method.

   method void getPos( lnum as logical, ckey as char, output x as int, output y as int ):

      var int ipos.

      ipos = index( if lnum then ' 0A123456789' else '<v> ^A', ckey ) - 1.
      assign
         x = ipos modulo 3
         y = ( ipos - x ) / 3
         .

   end method.

   method char move( lnum as logical, x as int , y as int, xn as int, yn as int ):

      var char cpresses.
      var logical ly.
      var int iy = 1.

      if ( xn = 0 ) <> ( x <> 0 ) then
         ly = true.

      if lnum then
         iy = 0.

      if ( yn = iy ) = ( y <> iy ) then
         ly = true.

      if ly then
         cpresses += moveY( yn - y ).

      cpresses += moveX( xn - x ).

      if not ly then
         cpresses += moveY( yn - y ).

      return cpresses.

   end method.

   method char moveX ( dx as int ):

      return fill( string( dx > 0, '>/<' ), absolute( dx ) ).

   end method.

   method char moveY ( dy as int ):

      return fill( string( dy > 0, '^/v' ), absolute( dy ) ).

   end method.

end class.