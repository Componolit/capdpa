package Capdpa.With_Enum
   with SPARK_Mode
is
   type Weekend is (Saturday, Sunday);
   for Weekend use (Saturday => 0, Sunday => 1);
   type Constants is (One, Two, Three);
   for Constants use (One => 1, Two => 2, Three => 3);
end Capdpa.With_Enum;
