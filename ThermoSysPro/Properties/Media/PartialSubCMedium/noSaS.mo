within ThermoSysPro.Properties.Media.PartialSubCMedium;
function noSaS "No trace sink nor source"
  extends partialSaS;
algorithm
  C := fill(0,nSubC);
  annotation (Documentation(info="
Default sink and source law of the components: no trace is consumed nor produced in the control volume (`C = 0`).
"));
end noSaS;
