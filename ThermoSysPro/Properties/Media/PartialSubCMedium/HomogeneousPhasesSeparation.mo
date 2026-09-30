within ThermoSysPro.Properties.Media.PartialSubCMedium;
function HomogeneousPhasesSeparation
  extends partialPhasesSeparation;
//   input Real x(min=0, max=1) "Title";

algorithm
  // HomogeneousSubstance
  C_record.Cl := SubC;
  C_record.Cg := SubC;

//   // Non-volatile
//   C_record.Cl := SubC / (1-x);
//   C_record.Cg := fill(0,size(SubC,1));

//   // Fully-volatile
//   C_record.Cl := fill(0,size(SubC,1));
//   C_record.Cg := SubC / x;
end HomogeneousPhasesSeparation;
