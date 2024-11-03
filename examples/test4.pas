uses mb2;
{$R-,Q-,I-,S-}
var x, xx, d: integer;
begin
   d := 1;
   igraph;
   pixmethod (1);
   repeat
   for xx := 0 to 319 do
      begin
         x := d * xx + 319 * byte (d=-1);
         line (0, 199, x, 0);
         line (0, 199, 319-x, 0);
         line (x, 199, 319-x, 0);
         line (319, 199, 319-x, 0);
         line (319-x, 199, x, 0);
         waiting;
         scan;
         if kp then break;
         color (gr256_col+1)
      end;
      d := - d;
   until kp;
   pause;
   clgraph
end.
