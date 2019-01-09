package Capdpa.With_Reference
is
   type Class is
   limited record
      R : Capdpa.Int_Address;
   end record
   with Import, Convention => CPP;

   type Class_Address is private;

   function Constructor return Class
   with Global => null;
   pragma Cpp_Constructor (Constructor, "_ZN14With_ReferenceC1Ev");

private
   pragma SPARK_Mode (Off);

   type Class_Address is access Class;

end Capdpa.With_Reference;
