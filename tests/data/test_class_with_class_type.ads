with Capdpa.With_Class.In_Namespace;
with System;

package Capdpa.Full
is
   type Class is
   limited record
      Value : Capdpa.With_Class.In_Namespace.Class;
      Value_Ptr : Capdpa.With_Class.In_Namespace.Class_Address;
   end record
   with Import, Convention => CPP;
   type Class_Address is new System.Address;
   function Constructor return Class;
   pragma Cpp_Constructor (Constructor, "_ZN4FullC1Ev");
end Capdpa.Full;
