with System;

package Capdpa.With_Struct
is
   package Ws
   is
      type Class is
      limited record
         X : Capdpa.Int;
      end record
      with Import, Convention => CPP;
      type Class_Address is new System.Address;
      function Constructor return Class;
      pragma Cpp_Constructor (Constructor, "_ZN11With_Struct2WsC1Ev");
   end Ws;
   package Ws2 is
      type Class is null record;
      type Class_Address is new System.Address;
   end Ws2;
   type Class is
   limited record
      Value : Capdpa.With_Struct.Ws.Class_Address;
      Value2 : Capdpa.With_Struct.Ws2.Class_Address;
   end record
   with Import, Convention => CPP;
   type Class_Address is new System.Address;
   function Constructor return Class;
   pragma Cpp_Constructor (Constructor, "_ZN11With_StructC1Ev");
end Capdpa.With_Struct;
