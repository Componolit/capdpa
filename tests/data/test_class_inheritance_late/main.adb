with Tests;
with Interfaces.C;
with Test_Class_Inheritance_Late.Base;
with Test_Class_Inheritance_Late.Cls;

procedure Main
is
   use Test_Class_Inheritance_Late;

   C : aliased Cls.Class  := Cls.Constructor;
   Val1, Val2, Val3, Val4 : Int;
   use Interfaces.C;
begin
   Val1 := Cls.Method (C'Access);
   Tests.Assert (Val1 = 42, "Wrong value returned (1): " & Val1'Img);
   Val2 := Cls.Pure (C'Access);
   Tests.Assert (Val2 = 43 , "Wrong value returned (2): " & Val2'Img);
   Val3 := Cls.Original (C'Access);
   Tests.Assert (Val3 = 103, "Wrong value returned (3): " & Val3'Img);
   Val4 := Cls.Own(C'Access);
   Tests.Assert (Val4 = 44, "Wrong value returned (4): " & Val4'Img);
end Main;
