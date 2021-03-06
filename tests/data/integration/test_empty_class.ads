package Test_Empty_Class
   with SPARK_Mode => On
is
   package Empty
      with SPARK_Mode => On
   is
      type Class is
      limited record
         null;
      end record
      with Import, Convention => CPP;

      type Class_Address is private;
      type Class_Array is array (Natural range <>) of Class;
      type Class_Address_Array is array (Natural range <>) of Class_Address;

      function Constructor return Class
      with Global => null;
      pragma Cpp_Constructor (Constructor, "_ZN5EmptyC1Ev");

   private
      pragma SPARK_Mode (Off);

      type Class_Address is access Class;

   end Empty;

end Test_Empty_Class;
