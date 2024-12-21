class 19.one:

   var int imin, imax.

   constructor one ():

      output to '19/output.txt' unbuffered.

      message skip getCombos( '19/input.txt' ).

      output close.

   end constructor.

   define temp-table ttAllTowels no-undo
      field stripes as char

      index ix stripes
      .

   define temp-table ttTowels no-undo

      field stripes as char

      index ix stripes
      .

   define temp-table ttCache no-undo
      field stripes  as char
      field length   as int

      index ix length stripes
      .

   method int getCombos ( cfile as char ):

      var int icombos.

      define buffer buTowel for ttTowels.

      var char ctowels, cpattern.

      input from value( cfile ).

      import unformatted ctowels.

      createTowels( ctowels ).

      put unformatted ctowels skip(1).

      repeat:

         import unformatted cpattern.

         if cpattern > '' then do:

            put unformatted entry( 1, entry( 2, iso-date( now ), 'T' ), '+' ). // ' ' cpattern.

            getPossibleTowels( cpattern ).

            if       isEndingPossible( cpattern )
               and   matchPatterns( cpattern ) = ''
            then do:
               put ' found'.
               icombos = icombos + 1.
            end.
            put skip.

         end.

      end.

      input close.

      return icombos.

   end method.

   method void createTowels ( ctowels as char ):

      define buffer buTowel for ttAllTowels.

      var int ix, ilen.

      do ix = 1 to num-entries( ctowels ):

         do for buTowel.
            create buTowel.
            assign
               buTowel.stripes = trim( entry( ix, ctowels ) )

               ilen = length( buTowel.stripes )
               imin = ilen when imin = 0
               imin = minimum( imin, ilen )
               imax = maximum( imax, ilen )
               .
         end.

      end.

   end method.

   method void getPossibleTowels ( cpattern as char ):

      define buffer buAll   for ttAllTowels.
      define buffer buTowel for ttTowels.

      empty temp-table ttTowels.

      for each buAll
         where index( cpattern, buAll.stripes ) > 0
      :

         create buTowel.
         buTowel.stripes = buAll.stripes.

         // message butowel.stripes.

      end.

   end method.

   method char matchPatterns ( cpattern as char ):

      var logical lfound.

      define buffer buCache for ttCache.
      define buffer buTowel for ttTowels.

      var int ix.

      // message cpattern.

      for each buCache
         where cpattern begins buCache.stripes

         by buCache.length descending
      :

         return substring( cpattern, buCache.length ).

      end.

      // put unformatted '~t' cpattern skip.

      do ix = imin to imax:

         find buTowel where buTowel.stripes = substring( cpattern, 1, ix ) no-error.
         if available buTowel then do:

            create buCache.
            assign
               buCache.stripes = buTowel.stripes
               buCache.length  = length( buCache.stripes )
               .

            if matchPatterns( substring( cpattern, ix + 1 ) ) = '' then
               return ''.

         end.

      end.

      return cpattern.

   end method.

   method logical isEndingPossible ( cpattern as char ):

      var logical lfound.

      define buffer buTowel for ttTowels.

      var int ix, ilen.
      var character cc.

      ilen = length( cpattern ).

      do ix = imin to ilen while not lfound:

         cc = substring( cpattern, ilen - ix + 1 ).
         // message 'looing for' cc.

         lfound = can-find( buTowel where buTowel.stripes = cc ).

      end.

      // message cpattern ilen imin  lfound.

      return lfound.

   end method.

end class.