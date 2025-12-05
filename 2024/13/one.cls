class 13.one:

   constructor one ():

      var int itokens, ix.
      var char cline.
      var int [2] a, b, p.

      session:appl-alert-boxes = true.

      // output to '13/output.txt'.
      input from '13/input.txt'. // 30973

      repeat:

         do ix = 1 to 3:

            import unformatted cline.

            case ix:
               when 1 then
                  assign
                     a[1] = getValue( cline, 'X+' )
                     a[2] = getValue( cline, 'Y+' )
                     .
               when 2 then
                  assign
                     b[1] = getValue( cline, 'X+' )
                     b[2] = getValue( cline, 'Y+' )
                     .
               when 3 then
                  assign
                     p[1] = getValue( cline, 'X=' )
                     p[2] = getValue( cline, 'Y=' )
                     .
            end case.
         end.

         itokens = itokens + calcTokens( a, b, p ).

         import cline.

      end.

      input close.
      // output close.

      message itokens.

   end constructor.

   method int getValue ( cline as char, cwhat as char ):

      var int ipos.

      ipos = index( cline, cwhat ).
      return int( entry( 1, substring( cline, ipos + 2 ) ) ).

   end method.

   method int calcTokens (
      a     as int extent,
      b     as int extent,
      prz   as int extent
   ):

      var int itokensA, itokensB.

      itokensA = calcTokens( a, 3, b, 1, prz ).
      itokensB = calcTokens( b, 1, a, 3, prz ).

      return minimum( itokensA, itokensB ).

   end method.

   method int calcTokens (
      a     as int extent,
      costA as int,
      b     as int extent,
      costB as int,
      prz   as int extent
   ):

      var int itokensA, itokensB.
      var int [2] pos.
      var decimal gradientNeeded, gradNextA, gradNextB.

      // put unformatted substitute( 'prize &1,&2 ', prz[1], prz[2] ) skip.

      gradientNeeded = prz[1] / prz[2].

      do while itokensA <= 100
         and   itokensB <= 100
      :

         // put unformatted substitute( 'pos &1,&2 ', pos[1], pos[2] ) skip.

         gradNextA = ( pos[1] + a[1] ) / ( pos[2] + a[2] ).
         gradNextB = ( pos[1] + b[1] ) / ( pos[2] + b[2] ).

         if absolute( gradientNeeded - gradNextA ) <= absolute( gradientNeeded - gradNextB ) then
            assign
               itokensA += 1
               pos[1] = pos[1] + a[1]
               pos[2] = pos[2] + a[2]
               .
         else
            assign
               itokensB += 1
               pos[1] = pos[1] + b[1]
               pos[2] = pos[2] + b[2]
               .

         if pos[1] = prz[1] and pos[2] = prz[2] then
            return costA * itokensA + costB * itokensB.

      end.

      return 0.

   end method.

end class.