package Capdpa.Outer
is
   package Inner
   is
      type Class is
      limited record
         null;
      end record
      with Import, Convention => CPP;
      function Constructor return Class;
      pragma Cpp_Constructor (Constructor, "");
   end Inner;
   type Class is
   limited record
      I : Capdpa.Outer.Inner.Class;
   end record
   with Import, Convention => CPP;
   function Constructor return Class;
   pragma Cpp_Constructor (Constructor, "");
end Capdpa.Outer;