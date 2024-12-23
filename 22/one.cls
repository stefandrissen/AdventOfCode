class 22.one:

   method void solve( cfile as char ):

      var int64 isum.
      var int isecret.
      var char csecret.

      input from value( cfile ).

      repeat:

         import unformatted csecret.
         isecret = generate( int( csecret ) ).
         isum = isum + isecret.

         message csecret + ':' isecret.

      end.

      input close.

      message skip isum.

   end method.

   method int generate ( isecret as int ):

      var int ix.

      do ix = 1 to 2000:
         isecret = generateNextSecret( isecret ).
      end.

      return isecret.

   end method.

   method int generateNextSecret( i_isecret as int ):

      var int isecret.

      isecret = i_isecret.
      isecret = prune( mix( isecret * 64, isecret ) ).
      isecret = prune( mix( int( truncate( isecret / 32, 0 ) ), isecret ) ).
      isecret = prune( mix( isecret * 2048, isecret ) ).

      return isecret.

   end method.

   method int64 mix ( i1 as int64, i2 as int64 ):

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

   method int64 prune( i1 as int64 ):

      return i1 modulo 16777216.

   end method.

end class.