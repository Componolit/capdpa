with System;

package Capdpa.With_Constants
is
   One : constant := 1;
   Two : constant := 2;
   Three : constant := 3;
   type Negative is (Minus_One, Minus_Two, Minus_Three);
   for Negative use (Minus_One => -1, Minus_Two => -2, Minus_Three => -3);
   type Class is
   limited record
      null;
   end record
   with Import, Convention => CPP;
   type Class_Address is new System.Address;
   function Constructor return Class;
   pragma Cpp_Constructor (Constructor, "_ZN14With_constantsC1Ev");
end Capdpa.With_Constants;
