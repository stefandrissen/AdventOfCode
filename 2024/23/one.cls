class 23.one:

   method void solve( cfile as char ):

      readInput( cfile ).
      getSetsOfThree().

   end method.

   define temp-table tt no-undo
      field one as char
      field two as char

      index ix1 is unique one two
      index ix2 two one
      .

   define temp-table ttLAN no-undo
      field id as char

      index ix is unique id
      .

   method void getSetsOfThree():

      define buffer bu1 for tt.
      define buffer bu2 for tt.
      define buffer bu3 for tt.
      define buffer buLAN for ttLAN.

      var int iLANs.
      var char cLAN.

      for each bu1:

         for each bu2
            where bu2.one =   bu1.two
            and   bu2.two <>  bu1.one
            and   can-find(
                     bu3
                        where bu3.one  =  bu2.two
                        and   bu3.two  =  bu1.one
                  )
         :

            if bu1.one begins 't' or bu1.two begins 't' or bu2.two begins 't' then do:

               cLAN = createLAN( bu1.one, bu1.two, bu2.two ).
               do for buLAN:
                  if not can-find( buLAN where buLAN.id = cLAN ) then do:
                     // message cLAN.
                     create buLAN.
                     buLAN.id = cLAN.
                     iLANs += 1.
                  end.
               end.

            end.

         end.

      end.

      message iLANs.

   end method.

   define temp-table ttsort no-undo
      field id as char

      index ix is unique id
      .

   method char createLAN( id1 as char, id2 as char, id3 as char ):

      var char cc.

      define buffer bu for ttsort.

      create bu. bu.id = id1.
      create bu. bu.id = id2.
      create bu. bu.id = id3.

      for each bu:
         cc = cc + ',' + bu.id.
      end.

      return substring( cc, 2 ).

      finally:
         empty temp-table ttsort.
      end finally.

   end method.

   method void readInput ( cfile as char ):

      define buffer bu for tt.
      var char cc.

      input from value( cfile ).

      repeat:

         import unformatted cc.
         if cc > '' then do for bu:
            create bu.
            assign
               bu.one = entry( 1, cc, '-' )
               bu.two = entry( 2, cc, '-' )
               .
            create bu.
            assign
               bu.one = entry( 2, cc, '-' )
               bu.two = entry( 1, cc, '-' )
               .
         end.

      end.

      input close.

   end method.

end class.