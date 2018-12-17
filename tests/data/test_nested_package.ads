with System;

package Capdpa.Outer
is
   package Inner
   is
      type Class is
      limited record
         null;
      end record
      with Import, Convention => CPP;
      type Class_Access is access Class;
      type Class_Address is new System.Address;
      type Class_Array is array (Long_Integer range <>) of Class;
      type Class_Access_Array is array (Long_Integer range <>) of Class_Access;
      type Class_Address_Array is array (Long_Integer range <>) of Class_Address;
      function Constructor return Class;
      pragma Cpp_Constructor (Constructor, "");
   end Inner;
   type Class is
   limited record
      I : Capdpa.Outer.Inner.Class;
   end record
   with Import, Convention => CPP;
   type Class_Access is access Class;
   type Class_Address is new System.Address;
   type Class_Array is array (Long_Integer range <>) of Class;
   type Class_Access_Array is array (Long_Integer range <>) of Class_Access;
   type Class_Address_Array is array (Long_Integer range <>) of Class_Address;
   function Constructor return Class;
   pragma Cpp_Constructor (Constructor, "");
end Capdpa.Outer;
