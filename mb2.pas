Unit MB2;

{ MCGABase 2.052                           }
{ Copyright by Nuclear Inc., (C) 1998-2002 }
{ Last changes: Hacker KAY, June, 2002.    }

{N+,S-,G+,D-,E-,I-,S-}

Interface

Var gr256_col, keyv : Byte;
    pixsizex, pixsizey : Byte;
    kp, ek, key_left, key_right, key_up, key_down: Boolean;

{$L MB2.OBJ}

Function Sgn (n : Integer) : Shortint;
Procedure Color (a : Byte);
Procedure Igraph;
Procedure Clgraph;
Procedure Cls;
Procedure Clear (x1, y1, x2, y2 : Integer);
Procedure Plot (x, y : Integer; c : Byte);
Procedure Setpal (a, b, c, d : Byte);
Procedure Getpal (a : Byte; Var b, c, d : Byte);
Function Key : Bytebool;
Procedure Line (x1, y1, x2, y2 : Integer);
Function Point (x, y : Integer) : Byte;
Procedure Scan;
Procedure Waiting;
Procedure Mshow;
Procedure Mhide;
Function Rmouse : Boolean;
Procedure Mxr (x0, x1 : Integer);
Procedure Myr (y0, y1 : Integer);
Function Lp : Boolean;
Function Rp : Boolean;
Procedure Mcrd (Var x, y : Integer);
Procedure Mset (x, y : Integer);
Procedure Mpage (p : Word);
Procedure Pause;
Procedure Circle (x, y, r : Integer);
Procedure Print (x, y : Integer; s : String);
Procedure Mwaitoff;
Procedure Putpixel (x, y : Integer; c : Byte);
Procedure Printsize (x, y : Byte);
Procedure Chide;
Procedure Cshow;
Procedure Border (c : Byte);
Procedure Textxy (x, y : Integer; s : String);
Procedure Vset (o : Word);
Procedure Fill (x, y : Integer);
Procedure Linec (x1, y1, x2, y2 : Integer);
Procedure Pixmethod (N: Byte);
Procedure Cursor (x, y: Integer);
Procedure Centre (s: string);

Implementation

Function Sgn; External;
Procedure Color; External;
Procedure Igraph; External;
Procedure Clgraph; External;
Procedure Cls; External;
Procedure Clear; External;
Procedure Plot; External;
Procedure Setpal; External;
Procedure Getpal; External;
Function Key; External;
Procedure Line; External;
Function Point; External;
Procedure Scan; External;
Procedure Waiting; External;
Procedure Mshow; External;
Procedure Mhide; External;
Function Rmouse; External;
Procedure Mxr; External;
Procedure Myr; External;
Function Lp; External;
Function Rp; External;
Procedure Mcrd; External;
Procedure Mset; External;
Procedure Mpage; External;
Procedure Pause; External;
Procedure Circle; External;
Procedure Print; External;
Procedure Mwaitoff; External;
Procedure Putpixel; External;
Procedure Printsize; External;
Procedure Chide; External;
Procedure Cshow; External;
Procedure Border; External;
Procedure Textxy; External;
Procedure Vset; External;
Procedure Fill; External;
Procedure Linec; External;
Procedure Pixmethod; External;
Procedure Cursor (x, y: Integer);
begin
   port[$3d4]:=$e; port[$3d5]:=byte((y*80+x) shr 8);
   port[$3d4]:=$f; port[$3d5]:=byte((y*80+x) and $ff);
end;
Procedure Centre (s: string);
var i: byte;
begin
   for i:=1 to 40-length(s) shr 1 do write (' ');
   writeln (s);
end;

Begin
   Asm
      Mov   gr256_col,15
      Xor   AL,AL
      Mov   kp,AL
      Mov   ek,AL
      Mov   keyv,AL
      Mov   key_left,AL
      Mov   key_right,AL
      Mov   key_up,AL
      Mov   key_down,AL
      Inc   AL
      Mov   pixsizex,AL
      Mov   pixsizey,AL
   End;
   Pixmethod (0);
End.
