with System;

package Capdpa.With_Virtual
is
   type Class is
   tagged limited record
      null;
   end record
   with Import, Convention => CPP;
   type Class_Address is access Class;
   function Constructor return Class;
   pragma Cpp_Constructor (Constructor, "_ZN12With_VirtualC1Ev");
   procedure Foo (This : access Class)
   with Import, Convention => CPP, External_Name => "_ZN12With_Virtual3fooEv";
end Capdpa.With_Virtual;
