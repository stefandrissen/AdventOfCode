class 05.one:

   constructor one ():

      session:appl-alert-boxes = true.

      input from value( '05/input.txt' ).

      readRules().
      message readUpdates().

      input close.

   end constructor.

   define temp-table ttrules no-undo
      field ipage as int
      field inext as int

      index ix ipage inext
      .

   method void readRules ():

      define buffer burule for ttrules.

      var char crule.
      var logical lend.

      repeat while not lend:

         import unformatted crule.
         if crule > '' then do for burule:

            create burule.
            assign
               burule.ipage = int( entry( 1, crule, '|' ) )
               burule.inext = int( entry( 2, crule, '|' ) )
               .

         end.
         else
            lend = true.

      end.

   end method.

   method int readUpdates ():

      var int ires.

      define buffer burule for ttrules.

      var int ipages, ix.
      var char cpages.
      var logical lgoodUpdate.

      repeat:

         import unformatted cpages.

         assign
            lgoodUpdate =  true
            ipages      =  num-entries( cpages )
            .

         do ix = 1 to ipages - 1 while lgoodUpdate:

            if not can-find(
                  burule
                     where burule.ipage   =  int( entry( ix, cpages ) )
                     and   burule.inext   =  int( entry( ix + 1, cpages ) )
                  )
            then
               lgoodUpdate = false.

         end.

         if lgoodUpdate then
            ires = ires + int( entry( int( ipages / 2 ), cpages ) ).

      end.

      return ires.

   end method.

end class.