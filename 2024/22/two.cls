class 22.two:

   method void solve( cfile as char ):

      var int iseller, isecret.
      var char csecret.

      input from value(
         substitute(
            '&1/&2.txt':u,
            entry( 1, this-object:ToString(), '.' ),
            cfile
         )
      ).

      repeat:

         import unformatted csecret.
         if csecret > '' then do:
            iseller = iseller + 1.
            generate( iseller, int( csecret ) ).
         end.

      end.

      message getBestPrice(). // 1571 too high, 1550 too high

      input close.

   end method.

   define temp-table tt no-undo
      field seller   as int
      field id       as int
      field price    as int
      field sequence as char

      index ix is unique seller id
      index ix2 seller sequence price
      .

   define temp-table ttseq no-undo
      field id as char
      field price as int

      index ix is unique id
      .

   method int getBestPrice():

      define buffer buseq for ttseq.

      // temp-table ttseq:write-json( 'file', 'ttseq.json', true ).
      // temp-table tt:write-json( 'file', 'tt.json', true ).

      for each buseq by buseq.price descending:

         return buseq.price.

      end.

   end method.

   method void generate ( iseller as int, isecret as int ):

      define buffer bu for tt.
      define buffer bu2 for tt.
      define buffer buseq for ttseq.

      var int ix.
      var char cseq.
      var int iprice.

      iprice = isecret modulo 10.

      do ix = 1 to 2000:

         isecret = generateNextSecret( isecret ).

         do for bu:

            create bu.
            assign
               bu.seller   =  iseller
               bu.id       =  ix
               bu.price    =  isecret modulo 10
               .
            cseq += replace( string( bu.price - iprice, '-9' ), ' ', '+' ).
            iprice = bu.price.

            if ix > 3 then do for buseq:

               assign
                  bu.sequence = cseq
                  cseq = substring( cseq, 3 )
                  .
               find buseq where buseq.id = bu.sequence no-error.
               if not available buseq then do:
                  create buseq.
                  assign
                     buseq.id = bu.sequence
                     buseq.price = bu.price
                     .
               end.
               else do:

                  find bu2
                     where bu2.seller   =  bu.seller
                     and   bu2.sequence =  bu.sequence
                     and   rowid( bu2 ) <> rowid( bu )
                  no-error.
                  if available bu2 then do:

                     if bu2.price >= bu.price then
                        delete bu.

                     else do:

                        buseq.price = buseq.price - bu2.price + bu.price.
                        delete bu2.

                     end.

                  end.
                  else
                     buseq.price += bu.price.

               end.

            end.
            else
               delete bu.

         end.

      end.

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
      var int ir1, ir2.

      do while i1 > 0 or i2 > 0:

         assign
            ir1 = i1 modulo 2
            ir2 = i2 modulo 2
            .

         assign
            ires = ires + iexp when ir1 <> ir2

            i1 = ( i1 - ir1 ) / 2
            i2 = ( i2 - ir2 ) / 2

            iexp = iexp * 2
            .

      end.

      return ires.

   end method.

   method int64 prune( i1 as int64 ):

      return i1 modulo 16777216.

   end method.

end class.