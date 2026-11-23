within ThermoSysPro.Fluid.Interfaces.Connectors;

connector FluidInlet "Fluid inlet connector"
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialThermoSysProMedium "Medium model" annotation(choicesAllMatching = true, Dialog(tab = "Fluid", group = "Medium"));
  Units.SI.Pressure P(start = 1.e5) "Fluid pressure in the control volume";
  Units.SI.MassFlowRate Q(start = 500) "Mass flow rate of the fluid crossing the boundary of the control volume";
  Units.SI.SpecificEnthalpy h(start = 1.e5) "Specific enthalpy of the fluid crossing the boundary of the control volume";
  Units.SI.SpecificEnthalpy h_vol_1(start = 1.e5) "Fluid specific enthalpy in the control volume 1";
  Units.SI.SpecificEnthalpy h_vol_2(start = 1.e5) "Fluid specific enthalpy in the control volume 2";
  Medium.ExtraProperty SubC[Medium.nC] "Substances concentration (ppm) of the fluid crossing the boundary of the control volume";
  Medium.MassFraction Xi[Medium.nXi] "Independent mixture mass fractions m_i/m of the fluid crossing the boundary of the control volume";
  input Real diff_res_1(start = 1e4) "Diffusion resistance from control volume 1";
  output Real diff_res_2(start = 1e4) "Diffusion resistance from control volume 2";
  input Boolean diff_on_1 "true: with diffusion - false: without diffusion from control volume 1";
  output Boolean diff_on_2 "true: with diffusion - false: without diffusion from control volume 2";
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {108, 199, 255})}),
    Window(x = 0.27, y = 0.33, width = 0.6, height = 0.6),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Author  

Daniel Bouskela   

    "));
end FluidInlet;
