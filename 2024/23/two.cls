class 23.two:

   method void solve( cfile as char ):

      readInput( cfile ).
      getSets().

   end method.

   define temp-table tt no-undo
      field one as char
      field two as char

      index ix1 is unique one two
      index ix2 two one
      .

   define temp-table ttnodes no-undo
      field id          as char
      field connections as int

      index ix1 is unique id
      .

   method void getSets():

      define buffer bu1 for tt.
      define buffer bu2 for tt.
      define buffer bunode for ttnodes.

      var char cc, c1, c2.
      var int ix, iy.

      for each bu1 break by bu1.one:

         if first-of( bu1.one ) then do:

            // empty temp-table ttnodes.

            // all computers connected to one
            for each bu2
               where bu2.one = bu1.one
            :

               find bunode where bunode.id = bu2.one no-error.
               if not available bunode then do:
                  create bunode.
                  bunode.id = bu2.one.
               end.
               bunode.connections += 1.

            end.

         end.

      end.

      temp-table ttnodes:write-json( 'file', 'nodes.json', true ).

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