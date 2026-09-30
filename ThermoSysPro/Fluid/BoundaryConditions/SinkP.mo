within ThermoSysPro.Fluid.BoundaryConditions;

model SinkP "Multi-fluid sink with fixed pressure"

  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Units.SI.AbsolutePressure P0=100000 "Sink pressure";
  parameter Units.SI.Temperature T0=290
    "Source temperature (active if option_temperature=true)"
    annotation (Evaluate=true, Dialog(enable=option_temperature));
  parameter Units.SI.SpecificEnthalpy h0=100000
    "Source specific enthalpy (active if option_temperature=false)"
    annotation (Evaluate=true, Dialog(enable=not option_temperature));
  parameter Boolean option_temperature=true
    "true:temperature fixed - false:specific enthalpy fixed";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";
  Medium.ExtraProperty SubC[Medium.nC](quantity=Medium.extraPropertiesNames, start=Medium.C_default) "Trace substances";
  Medium.MassFraction X[Medium.nXi](start=Medium.X_default[1:Medium.nXi]) "Mass fraction of the fluid crossing the boundary of the control volume";


public
  Units.SI.MassFlowRate Q "Fluid mass flow rate";
  Units.SI.AbsolutePressure P "Fluid pressure";
  Units.SI.SpecificEnthalpy h "Fluid specific enthalpy";
  Units.SI.Temperature T "Fluid temperature";

public
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal IPressure
    "Fixed pressure"
    annotation (Placement(transformation(
        origin={50,0},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  InstrumentationAndControl.Connectors.InputReal              ISpecificEnthalpyOrTemperature
    "Fixed specific enthalpy or temperature according to option_temperature"
    annotation (Placement(transformation(
        origin={0,-50},
        extent={{10,-10},{-10,10}},
        rotation=270)));
equation
  Q = C.Q;
  C.P = P;
  C.h_vol_2 = h;
  C.diff_res_2 = 0;
  C.diff_on_2 = diffusion;

  X = C.Xi;
  SubC = C.SubC;

  if (cardinality(IPressure) == 0) then
    IPressure.signal = P0;
  end if;
  P = IPressure.signal;
/* Specific enthalpy or temperature */
  if (cardinality(ISpecificEnthalpyOrTemperature) == 0) then
    if option_temperature then
      ISpecificEnthalpyOrTemperature.signal = T0;
    else
      ISpecificEnthalpyOrTemperature.signal = h0;
    end if;
  end if;
  if option_temperature then
    T = ISpecificEnthalpyOrTemperature.signal;
    h = Medium.specificEnthalpy_pTX(p=P, T=T, X=X);
  else
    h = ISpecificEnthalpyOrTemperature.signal;
    T = Medium.temperature_phX(p=P, h=h, X=X);
  end if;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Line(points = {{-90, 0}, {-40, 0}, {-58, 10}}), Line(points = {{-40, 0}, {-58, -10}}), Text(extent = {{40, 28}, {58, 8}}, textString = "P"), Rectangle(extent = {{-40, 40}, {40, -40}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Solid, fillColor = {127, 255, 0}), Text(extent = {{-94, 26}, {98, -30}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Solid, textString = "P"), Text(extent = {{12, -42}, {42, -62}}, textString = "h / T")}),
    Window(x = 0.06, y = 0.16, width = 0.67, height = 0.71),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Line(points = {{-90, 0}, {-40, 0}, {-58, 10}}), Rectangle(extent = {{-40, 40}, {40, -40}}, lineColor = {0, 0, 255}, fillPattern = FillPattern.Solid, fillColor = DynamicSelect({127, 255, 0}, fill_color_singular)), Line(points = {{-40, 0}, {-58, -10}}), Text(extent = {{-94, 26}, {98, -30}}, textString = "P"), Text(extent = {{40, 28}, {58, 8}}, textString = "P"), Text(extent = {{12, -42}, {42, -62}}, textString = "h / T")}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Authors  

Daniel Bouskela  
Baligh El Hefni   

    "));
end SinkP;