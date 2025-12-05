var int [8] ivalue.
var int isafe.

function safeReport logical ( int extent ) forward.
function safeReport2 logical ( int extent, int ) forward.

session:appl-alert-boxes = true.

input from '02/report.txt'.

repeat:

   ivalue = ?.

   import ivalue.

   if safeReport( ivalue ) then
      isafe = isafe + 1.

end.

message isafe.

function safeReport returns logical (
   i_ivalue as int extent
):

   var int ix, iy, iskip.
   def var ivalue as int extent.

   do ix = 1 to extent( i_ivalue ) while i_ivalue [ix] <> ?:
   end.

   extent( ivalue ) = ix - 1.

   do ix = 1 to extent( ivalue ):
      ivalue [ix] = i_ivalue [ix].
   end.

   do iskip = 0 to extent( ivalue ):

      if safeReport2( ivalue, iskip ) then
         return true.

   end.

end function.

function safeReport2 returns logical (
   i_ivalue as int extent,
   i_iskip  as int
):

   var int ix, iy, idiff.
   var logical lascending, ldescending, lsafe.
   def var ivalue as int extent.

   extent( ivalue ) = extent( i_ivalue ) - ( if i_iskip = 0 then 0 else 1 ).

   do ix = 1 to extent( i_ivalue ):

      if ix <> i_iskip then
         assign
            iy = iy + 1
            ivalue [iy] = i_ivalue [ix]
            .

   end.

   assign
      lascending  =  ?
      ldescending =  ?
      lsafe       =  true
      .

   do ix = 2 to extent( ivalue ) while lsafe and ivalue [ix] <> ?:

      idiff = ivalue [ix] - ivalue [ix - 1].

      if idiff = 0 then
         lsafe = false.

      else if abs( idiff ) > 3 then
         lsafe = false.

      else if idiff > 0 then do:

         if ldescending then
            lsafe = false.
         else
            lascending = true.

      end.
      else if idiff < 0 then do:

         if lascending then
            lsafe = false.
         else
            ldescending = true.

      end.

   end.

   return lsafe.

end function.