class 17.two:

   var int64 a, b, c.

   constructor two ():

      var char cinput, canswer.
      var int iinput.
      var datetime dt.

      session:appl-alert-boxes = true.

      output to '17/output.txt' unbuffered.

      cinput = readInput( '17/example.txt' ).

      dt = now.

      do while cinput <> canswer:

         assign
            iinput = iinput + 1
            a = iinput
            b = 0
            c = 0
            .

         if interval( now, dt, 'seconds' ) >= 1 then do:
            put unformatted entry( 2, iso-date( now ), 'T' ) ' ' iinput skip.
            dt = now.
         end.

         canswer = execute( readInput( '17/example.txt' ) ).

      end.

      output close.

      show( string( iinput ) ).

   end constructor.

   method char readInput ( cfile as char ):

      var char cline, cinstr, cval.

      input from value( cfile ).
      repeat:

         import unformatted cline.
         if num-entries( cline, ':' ) = 2 then do:

            assign
               cinstr   =  entry( 1, cline, ':' )
               cval     =  entry( 2, cline, ':' )
               .

            if cinstr begins 'Register ' then do:

               case entry( 2, cinstr, ' ' ):
                  when 'A' then a = int64( cval ).
                  when 'B' then b = int64( cval ).
                  when 'C' then c = int64( cval ).
               end case.

            end.
            else if cinstr = 'Program' then
               return cval.

         end.

      end.

      input close.

   end method.

   method char execute ( cinstructions as char ):

      var int ip, ilen, iopcode, ioperand.
      var char cout.

      ilen = num-entries( cinstructions ).

      do while ip < ilen:

         assign
            iopcode  =  int( entry( ip + 1, cinstructions ) )
            ioperand =  int( entry( ip + 2, cinstructions ) )
            ip       =  ip + 2
            .

         case iopcode:

            when 0 then
               a = truncate( a / exp( 2, combo( ioperand ) ), 0 ).

            when 1 then
               b = bxor( b, ioperand ).

            when 2 then
               b = combo( ioperand ) modulo 8.

            when 3 then
               if a <> 0 then
                  ip = ioperand.

            when 4 then
               b = bxor( b, c ).

            when 5 then
               assign
                  cout += ',' when cout > ''
                  cout += string( combo( ioperand ) modulo 8 )
                  .

            when 6 then
               b = truncate( a / exp( 2, combo( ioperand ) ), 0 ).

            when 7 then
               c = truncate( a / exp( 2, combo( ioperand ) ), 0 ).

         end case.

      end.

      return cout.

   end method.

   method int64 combo ( ioperand as int ):

      if ioperand <= 3 then
         return ioperand.

      case ioperand:
         when 4 then return a.
         when 5 then return b.
         when 6 then return c.
      end case.

      message 'oops!'.

   end method.

   method int64 bxor ( i1 as int64, i2 as int64 ):

      var int64 ires.
      var int64 iexp = 1.

      do while i1 > 0 or i2 > 0:

         if i1 modulo 2 <> i2 modulo 2 then
            ires = ires + iexp.

         i1 = truncate( i1 / 2, 0 ).
         i2 = truncate( i2 / 2, 0 ).
         iexp = iexp * 2.

      end.

      return ires.

   end method.

   method void show ( i_c as char ):

      output to 'clipboard'.
      put unformatted i_c.
      output close.

      message i_c.

   end method.

end class.