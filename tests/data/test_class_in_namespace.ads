package Capdpa.With_Class.In_Namespace
is
   type Class is
   limited record
      null;
   end record
   with Import, Convention => CPP;

   type Class_Address is private;

   function Constructor return Class
   with Global => null;
   pragma Cpp_Constructor (Constructor, "_ZN10With_class12In_namespaceC1Ev");

private
   pragma SPARK_Mode (Off);

   type Class_Address is access Class;

end Capdpa.With_Class.In_Namespace;
