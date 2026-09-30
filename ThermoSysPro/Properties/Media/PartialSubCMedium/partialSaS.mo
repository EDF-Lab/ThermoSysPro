within ThermoSysPro.Properties.Media.PartialSubCMedium;
partial function partialSaS
  input Real SubC[:] "Total Species Concentrations";
  output Real C[size(SubC,1)];
end partialSaS;
