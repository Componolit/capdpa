package Capdpa.Empty
is
   type Class is
   limited record
      null;
   end record
   with Import, Convention => CPP;
   function Constructor return Class;
   pragma Cpp_Constructor (Constructor, "");
end Capdpa.Empty;
