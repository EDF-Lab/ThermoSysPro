within ThermoSysPro.Fluid.Machines;
model HeatPumpCompressor "Heat pump compressor "
  extends ThermoSysPro.Fluid.Interfaces.IconColors;

  replaceable package Medium = ThermoSysPro.Properties.Media.C3H3F5 constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium
    "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Real pi=10.0 "Compression factor (Ps/Pe)";
  parameter Real eta=0.85 "Isentropic efficiency";
  parameter Units.SI.Power W_fric=0.0
    "Power losses due to hydrodynamic friction (percent)";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";

public
  Units.SI.Power W "Mechanical power delivered to the compressor";
  Units.SI.MassFlowRate Q "Mass flow rate";
  Units.SI.SpecificEnthalpy His
    "Fluid specific enthalpy after isentropic compression";
  Units.SI.AbsolutePressure Pe(start=10e5) "Inlet pressure";
  Units.SI.AbsolutePressure Ps(start=10e5) "Outlet pressure";
  Units.SI.Temperature Te "Inlet temperature";
  Units.SI.Temperature Ts "Outlet temperature";
  Real xm(start=1.0) "Average vapor mass fraction";

  Interfaces.Connectors.FluidInlet C1(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet C2(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{90,-10},{110,10}}, rotation=0)));
public
  Medium.ThermodynamicState state_e "Fluid thermodynamic state before the compression";
  Medium.ThermodynamicState state_s "Fluid thermodynamic state after the compression";
  Medium.ThermodynamicState state_is
    "Fluid thermodynamic state after the isentropic compression";
equation

  C1.Q = C2.Q;

  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;

  C2.diff_on_1 = if (gamma_diff > 0) then C1.diff_on_1 else false;
  C1.diff_on_2 = if (gamma_diff > 0) then C2.diff_on_2 else false;

  C2.diff_res_1 = C1.diff_res_1 + (if (gamma_diff > 0) then 1/gamma_diff else 0);
  C1.diff_res_2 = C2.diff_res_2 + (if (gamma_diff > 0) then 1/gamma_diff else 0);

  C1.SubC = C2.SubC;
  C1.Xi = C2.Xi;

  Q = C1.Q;
  Pe = C1.P;
  Ps = C2.P;

  /* Mechnical power delivered to the compressor */
  W = Q*(C2.h - C1.h) / (1 - W_fric/100);

  /* Compression factor */
  pi = Ps/Pe;

  /* Average vapor mass fraction */
  xm = (Medium.vapourQuality(state_e) + Medium.vapourQuality(state_s))/2.0;

  /* Compression efficiency */
  His - C1.h = max(xm, 0.01)*eta*(C2.h - C1.h);

  /* Fluid thermodynamic properties before the compression */
  state_e = Medium.setState_phX(Pe, C1.h, C1.Xi);
  Te = Medium.temperature(state_e);

  /* Fluid thermodynamic properties after the compression */
  state_s = Medium.setState_phX(Ps, C2.h, C2.Xi);
  Ts = Medium.temperature(state_s);

  /* Fluid thermodynamic properties after the identropic compression */
  state_is = Medium.setState_psX(Ps, Medium.specificEntropy(state_e), C1.Xi);
  His = Medium.specificEnthalpy(state_is);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid), Line(points={{-60,80},{60,20},{60,-20},
              {-60,-80}}, color={0,0,255})}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor=DynamicSelect({127,255,0}, fill_color_singular),
          fillPattern=FillPattern.Solid),Line(points={{-60,80},{60,20},{60,-20},
              {-60,-80}}, color={0,0,255})}),
    Window(
      x=0.17,
      y=0.1,
      width=0.76,
      height=0.76),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Authors  

Benoît Bride  
Daniel Bouskela   

    "));
end HeatPumpCompressor;
