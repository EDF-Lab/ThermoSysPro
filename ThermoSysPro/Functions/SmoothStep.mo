within ThermoSysPro.Functions;

function SmoothStep "Smooth step function"
  input Real x;
  input Real alpha = 100;
  output Real y;
algorithm
  y := 1/(1 + exp(-alpha*x/2));
  annotation(
    smoothOrder = 2,
    Inline = false,
    LateInline = true,
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2  
    "));
end SmoothStep;