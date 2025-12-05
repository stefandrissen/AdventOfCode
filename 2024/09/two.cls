class 09.two:

   var int idmax.

   constructor two ():

      session:appl-alert-boxes = true.

      createMap( '09/input.txt' ).
      freeSpace().

      message checkSum().

   end constructor.

   define temp-table ttfiles no-undo
      field lfree as logical        serialize-name 'free'
      field id    as int initial ?
      field ipos  as int initial ?  serialize-name 'pos'
      field isize as int            serialize-name 'size'

      index ix1 is unique primary lfree ipos
      index ix2 lfree id
      .

   method void createMap( i_cfile as char ):

      define buffer bufile for ttfiles.

      var char cc.
      var int ilen, ix, id, isize, ipos.

      input from value( i_cfile ).
      import unformatted cc.
      input close.

      ilen = length( cc ).
      do ix = 1 to ilen by 2:

         do for bufile:

            create bufile.
            assign
               bufile.lfree   =  false
               bufile.id      =  id
               bufile.ipos    =  ipos
               bufile.isize   =  int( substring( cc, ix, 1 ) )

               ipos = ipos + bufile.isize
               .

         end.

         isize = int( substring( cc, ix + 1, 1 ) ).

         if isize > 0 then do for bufile:

            create bufile.
            assign
               bufile.lfree   =  true
               bufile.id      =  id
               bufile.ipos    =  ipos
               bufile.isize   =  isize
               .

            ipos = ipos + bufile.isize.

         end.

         id = id + 1.

      end.

      idmax = id.

   end method.

   method void freeSpace():

      define buffer bufile for ttfiles.
      define buffer bufree for ttfiles.

      var int id.

      do id = idmax to 1 by -1:

         find bufile
            where bufile.lfree   =  false
            and   bufile.id      =  id
         no-error.
         if available bufile then do:

            find first bufree
               where bufree.lfree =  true
               and   bufree.isize >= bufile.isize
               and   bufree.ipos  <  bufile.ipos
            no-error.
            if available bufree then do:

               assign
                  bufile.ipos    =  bufree.ipos

                  bufree.isize   =  bufree.isize - bufile.isize
                  bufree.ipos    =  bufree.ipos  + bufile.isize
                  .
               if bufree.isize = 0 then
                  delete bufree.

            end.

         end.

      end.

   end method.

   method int64 checkSum ():

      var int64 isum.

      define buffer bufile for ttfiles.
      define buffer bufree for ttfiles.

      var int ix.

      for each bufree where bufree.lfree = true:
         delete bufree.
      end.

      for each bufile
         by bufile.ipos
      :

         do ix = bufile.ipos to bufile.ipos + bufile.isize - 1:
            isum = isum + ix * bufile.id.
         end.

      end.

      return isum.

   end method.

end class.