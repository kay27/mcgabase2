uses mb2;
var x: integer;
begin
   igraph;
   pixmethod (5);
   for x := 70 to 250 do
      circle (x, 100-14+x and 31, 29);
   pixmethod (1);
   printsize (1, 3);
   print (92, 88, 'TEST OF PIXMETHOD');
   pause;
   clgraph
end.