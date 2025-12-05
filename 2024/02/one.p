var int [8] ivalue.
var int isafe, ix, idiff.
var logical lsafe, lascending, ldescending.

session:appl-alert-boxes = true.

input from '02/report.txt'.

repeat:

   assign
      lascending  =  ?
      ldescending =  ?
      lsafe       =  true
      ivalue      =  ?
      .

   import ivalue.

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

   if lsafe then
      isafe = isafe + 1.

end.

message isafe.