package Capdpa.With_Virtual
is
   type Class is
   tagged limited record
      null;
   end record
   with Import, Convention => CPP;

   type Class_Address is private;

   function Constructor return Class
   with Global => null;
   pragma Cpp_Constructor (Constructor, "_ZN12With_VirtualC1Ev");

   procedure Foo (This : Class)
   with Global => null, Import, Convention => CPP, External_Name => "_ZN12With_Virtual3fooEv";

private
   pragma SPARK_Mode (Off);

   type Class_Address is access Class;

end Capdpa.With_Virtual;
