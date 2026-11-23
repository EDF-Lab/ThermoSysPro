within ThermoSysPro.Fluid.BoundaryConditions;

model SourceQ "Multi-fluid source with fixed mass flow rate"

  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  parameter Units.SI.MassFlowRate Q0=100
    "Mass flow (active if IMassFlow connector is not connected)";
  parameter Units.SI.Temperature T0=290
    "Source temperature (active if option_temperature=true)"
    annotation (Evaluate=true, Dialog(enable=option_temperature));
  parameter Units.SI.SpecificEnthalpy h0=100000
    "Source specific enthalpy (active if option_temperature=false)"
    annotation (Evaluate=true, Dialog(enable=not option_temperature));
  parameter Boolean option_temperature=false
    "true:temperature fixed - false:specific enthalpy fixed";
  parameter Boolean continuous_flow_reversal=false
    "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";
  parameter Medium.ExtraProperty SubC0[Medium.nC](quantity=Medium.extraPropertiesNames) = fill(0,Medium.nC) "Source trace substances" annotation (Evaluate=true, Dialog(
      tab="Fluid",
      group="Medium"));
  parameter Medium.ExtraProperty X0[Medium.nX]= Medium.X_default "Source mass fraction" annotation (Dialog(
      tab="Fluid",
      group="Medium"));

public
  Units.SI.MassFlowRate Q "Fluid mass flow rate";
  Units.SI.AbsolutePressure P "Fluid pressure";
  Units.SI.SpecificEnthalpy h "Fluid specific enthalpy";
  Units.SI.Temperature T(start=300) "Fluid temperature";

public
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal IMassFlow "Fixed mass flow rate" annotation (Placement(transformation(
        origin={0,50},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C(redeclare package Medium = Medium) annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
  InstrumentationAndControl.Connectors.InputReal ISpecificEnthalpyOrTemperature "Fixed specific enthalpy or temperature according to option_temperature" annotation (Placement(transformation(
        origin={0,-50},
        extent={{10,-10},{-10,10}},
        rotation=270)));
equation
  C.Q = Q;
  P = C.P;
  C.h_vol_1 = h;
  C.diff_res_1 = 0;
  C.diff_on_1 = diffusion;

  C.SubC=SubC0;

  C.Xi = X0[1:Medium.nXi];

  /* Mass flow rate */
  if (cardinality(IMassFlow) == 0) then
    IMassFlow.signal = Q0;
  end if;
  Q = IMassFlow.signal;
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
    h = Medium.specificEnthalpy_pTX(p=P, T=T, X=X0);
  else
    h = ISpecificEnthalpyOrTemperature.signal;
    T = Medium.temperature_phX(p=P, h=h, X=X0);
  end if;
/* Flow reversal */
  if continuous_flow_reversal then
    C.h = ThermoSysPro.Functions.SmoothCond(C.Q*C.diff_res_2, C.h_vol_1, C.h_vol_2, 1);
  else
    C.h = if (C.Q > 0) then C.h_vol_1 else C.h_vol_2;
  end if;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Line(points = {{40, 0}, {90, 0}, {72, 10}}), Line(points = {{90, 0}, {72, -10}}), Text(extent = {{-28, 60}, {-10, 40}}, textString = "Q"), Rectangle(extent = {{-40, 40}, {40, -40}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Solid, fillColor = {255, 255, 0}), Text(extent = {{-20, 20}, {22, -24}}, lineColor = {0, 0, 255}, textString = "Q"), Text(extent = {{-40, -40}, {-10, -60}}, textString = "h / T")}),
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Line(points = {{40, 0}, {90, 0}, {72, 10}}), Rectangle(extent = {{-40, 40}, {40, -40}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Solid, fillColor = DynamicSelect({255, 255, 0}, fill_color_static)), Line(points = {{90, 0}, {72, -10}}), Text(extent = {{-30, 60}, {-10, 40}}, textString = "Q"), Text(extent = {{-20, 20}, {22, -24}}, lineColor = {0, 0, 255}, textString = "Q"), Text(extent = {{-40, -40}, {-10, -60}}, textString = "h / T")}),
    Window(x = 0.23, y = 0.15, width = 0.81, height = 0.71),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Authors  

Baligh El Hefni  
Daniel Bouskela   

    "));
end SourceQ;