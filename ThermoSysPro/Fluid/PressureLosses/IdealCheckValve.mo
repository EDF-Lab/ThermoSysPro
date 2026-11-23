within ThermoSysPro.Fluid.PressureLosses;
model IdealCheckValve "Ideal check valve"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialSubCMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Units.SI.PressureDifference dPOuvert=0.01
    "Pressure difference when the valve opens";
  parameter Units.SI.MassFlowRate Qmin=1.e-6
    "Mass flow trhough the valve when the valve is closed";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";

public
  Boolean ouvert(start=true, fixed=true) "Valve state";
  discrete Boolean touvert(start=false, fixed=true);
  discrete Boolean tferme(start=false, fixed=true);
  Units.SI.MassFlowRate Q "Mass flow rate";
  Units.SI.SpecificEnthalpy h(start=100000)
    "Fluid specific enthalpy";
  Units.SI.PressureDifference deltaP
    "Pressure difference between the inlet and the outlet";

  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
equation

  C1.Q = C2.Q;
  C1.h = C2.h;

  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;

  C2.diff_on_1 = if (gamma_diff > 0) then C1.diff_on_1 else false;
  C1.diff_on_2 = if (gamma_diff > 0) then C2.diff_on_2 else false;

  C2.diff_res_1 = C1.diff_res_1 + (if (gamma_diff > 0) then 1/gamma_diff else 0);
  C1.diff_res_2 = C2.diff_res_2 + (if (gamma_diff > 0) then 1/gamma_diff else 0);

  C1.Xi = C2.Xi;

  C1.SubC = C2.SubC;

  Q = C1.Q;
  h = C1.h;
  deltaP = C1.P - C2.P;

  /* Pressure loss */
  if ouvert then
    deltaP = 0;
  else
   Q - Qmin = 0;
  end if;

  touvert = (deltaP > dPOuvert);
  tferme = (not (Q > 0));

  when {pre(tferme),pre(touvert)} then
    ouvert = pre(touvert);
  end when;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-70,70},{-50,50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,255}),
        Line(points={{-90,0},{-60,0}}),
        Line(points={{60,0},{100,0}}),
        Text(extent={{-96,-56},{96,-112}}, textString=
                                               "DP=0"),
        Line(
          points={{-60,-60},{-60,60},{60,-60},{60,60}},
          color={0,203,0},
          thickness=0.5)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-70,70},{-50,50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor= DynamicSelect({127,255,0}, fill_color_singular)),
        Line(points={{-100,0},{-60,0}}),
        Line(points={{60,0},{100,0}}),
        Text(extent={{-96,-56},{96,-112}}, textString=
                                               "DP=0"),
        Line(
          points={{-60,-60},{-60,60},{60,-60},{60,60}},
          color={0,203,0},
          thickness=0.5)}),
    Window(
      x=0.08,
      y=0.02,
      width=0.84,
      height=0.9),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Authors  

Daniel Bouskela  
Baligh El Hefni   

    "));
end IdealCheckValve;
