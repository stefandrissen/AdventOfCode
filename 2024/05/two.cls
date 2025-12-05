class 05.two:

   constructor two ():

      session:appl-alert-boxes = true.

      input from value( '05/input.txt' ).

      readRules().
      message readUpdates().

      input close.

   end constructor.

   define temp-table ttrules no-undo
      field ipage    as int
      field inext    as int
      field iedges   as int

      index ix ipage inext
      index ix2 iedges
      .

   method void readRules ():

      define buffer burule for ttrules.
      define buffer bu2rule for ttrules.

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
      var logical lupdated.

      repeat:

         import unformatted cpages.

         assign
            lupdated =  false
            ipages   =  num-entries( cpages )
            .

         do ix = 1 to ipages - 1 while not lupdated:

            if not can-find(
                  burule
                     where burule.ipage   =  int( entry( ix    , cpages ) )
                     and   burule.inext   =  int( entry( ix + 1, cpages ) )
                  )
            then
               assign
                  ires = ires + reorderUpdate( cpages )
                  lupdated = true
                  .

         end.

      end.

      return ires.

   end method.

   define temp-table ttruleset like ttrules.

   method int reorderUpdate ( i_cpages as char ):

      var int ires.

      define buffer burule for ttrules.
      define buffer buset  for ttruleset.
      define buffer bunext for ttruleset.

      var char cpages.
      var int ipages, ix.

      // create subset of rules that apply for this manual

      ipages = num-entries( i_cpages ).
      do ix = 1 to ipages:

         for each burule
            where burule.ipage = int( entry( ix, i_cpages ) )
            and   lookup( string( burule.inext ), i_cpages ) > 0
         :

            do for buset:
               create buset.
               buffer-copy burule to buset.
            end.

         end.

      end.

      // count edges per page
      for each buset, each bunext where bunext.ipage = buset.ipage:
         buset.iedges = buset.iedges + 1.
      end.

      do for buset while can-find( first buset ):

         // there is always one record with one edge
         find buset where buset.iedges = 1.

         if cpages = '' then
            cpages = string( buset.inext ).

         cpages = string( buset.ipage ) + ',' + cpages.

         // purge set for edges which can no longer be valid
         for each bunext where bunext.inext = buset.inext:

            // update edge counts, leaving one record in set with one edge
            for each buset where buset.ipage = bunext.ipage:
               buset.iedges = buset.iedges - 1.
            end.

            delete bunext.

         end.

      end.

      ires = int( entry( int( ipages / 2 ), cpages ) ).

      return ires.

      finally:
         empty temp-table ttruleset.
      end finally.

   end method.

end class.