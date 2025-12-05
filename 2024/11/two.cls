class 11.two:

   define temp-table ttstones no-undo
      field idepth   as int
      field ivalue   as int64
      field istones  as int64

      index ix is unique idepth ivalue
      .

   constructor two ():

      var int64 istones.
      var char cstones.
      var int ix.
      var datetime [2] dt.

      session:appl-alert-boxes = true.

      input from '11/input.txt'.
      import unformatted cstones.
      input close.

      dt[1] = now.

      do ix = 1 to num-entries( cstones, ' ' ):

         istones = istones + calcStones( int64( entry( ix, cstones, ' ' ) ), 75 ).

      end.

      dt[2] = now.

      message istones 'in' interval( dt[2], dt[1], 'milliseconds' ) 'ms'.

   end constructor.

   method int64 calcStones ( i_ivalue as int64, i_idepth as int ):

      var int64 istones.

      define buffer bustone for ttstones.

      var int ilen.
      var char cstone.

      if i_idepth = 0 then
         return 1.

      find bustone where bustone.idepth = i_idepth and bustone.ivalue = i_ivalue no-error.
      if available bustone then
         return bustone.istones.

      if i_ivalue = 0 then
         istones = calcStones( 1, i_idepth - 1 ).

      else if length( string( i_ivalue ) ) modulo 2 = 0 then
         assign
            cstone   =  string( i_ivalue )
            ilen     =  length( cstone ) / 2

            istones  =  calcStones( int64( substring( cstone, 1, ilen ) ) , i_idepth - 1 )
                     +  calcStones( int64( substring( cstone, 1 + ilen ) ), i_idepth - 1 )
            .

      else
         istones = calcStones( i_ivalue * 2024, i_idepth - 1 ).

      create bustone.
      assign
         bustone.idepth    =  i_idepth
         bustone.ivalue    =  i_ivalue
         bustone.istones   =  istones
         .

      return istones.

   end method.

end class.