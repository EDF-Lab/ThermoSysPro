within ThermoSysPro.Fluid.Machines;
model StodolaTurbine "Multistage turbine group using Stodola's ellipse"
extends ThermoSysPro.Fluid.Interfaces.IconColors;
 replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  import ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.IF97Region;

  parameter Real Cst=1.e7 "Stodola's ellipse coefficient";
  parameter Real W_fric=0.0
    "Power losses due to hydrodynamic friction (percent)";
  parameter Real eta_stato=1.0
    "Efficiency to account for cinetic losses (<= 1) (s.u.)";
  parameter Units.SI.Area area_nz=1 "Nozzle area";
  parameter Real eta_nz=1.0
    "Nozzle efficency (eta_nz < 1 - turbine with nozzle - eta_nz = 1 - turbine without nozzle)";
  parameter Units.SI.MassFlowRate Qmax=1
    "Maximum mass flow through the turbine";
  parameter Real eta_is_nom=0.8 "Nominal isentropic efficiency";
  parameter Real eta_is_min=0.35 "Minimum isentropic efficiency";
  parameter Real a=-1.3889
    "x^2 coefficient of the isentropic efficiency characteristics eta_is=f(Q/Qmax)";
  parameter Real b=2.6944
    "x coefficient of the isentropic efficiency characteristics eta_is=f(Q/Qmax)";
  parameter Real c=-0.5056
    "Constant coefficient of the isentropic efficiency characteristics eta_is=f(Q/Qmax)";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";
  parameter IF97Region region_e=IF97Region.All_regions "IF97 region before expansion (active for IF97 water/steam only)" annotation(Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));
  parameter IF97Region region_s=IF97Region.All_regions "IF97 region after expansion (active for IF97 water/steam only)" annotation(Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));
  parameter IF97Region region_ps=IF97Region.All_regions "IF97 region after isentropic expansion (active for IF97 water/steam only)" annotation(Evaluate=true, Dialog(tab="Fluid", group="Fluid properties"));


protected
  Integer phase_e=if Integer(region_e) == 0 then 0 else if Integer(region_e)==4 then 2 else 1;
  Integer phase_s=if Integer(region_s) == 0 then 0 else if Integer(region_s)==4 then 2 else 1;
  Integer phase_ps=if Integer(region_ps) == 0 then 0 else if Integer(region_ps)==4 then 2 else 1;
  parameter Units.SI.AbsolutePressure pcrit=ThermoSysPro.Properties.WaterSteam.BaseIF97.data.PCRIT
    "Critical pressure";
  parameter Units.SI.Temperature Tcrit=ThermoSysPro.Properties.WaterSteam.BaseIF97.data.TCRIT
    "Critical temperature";

public
  Real eta_is(start=0.85) "Isentropic efficiency";
  Real eta_is_wet(start=0.83) "Isentropic efficiency for wet steam";
  Units.SI.Power W "Mechanical power produced by the turbine";
  Units.SI.MassFlowRate Q "Mass flow rate";
  Units.SI.SpecificEnthalpy His
    "Fluid specific enthalpy after isentropic expansion";
  Units.SI.SpecificEnthalpy Hrs
    "Fluid specific enthalpy after the real expansion";
  Units.SI.AbsolutePressure Pe(start=10e5, min=0) "Pressure at the inlet";
  Units.SI.AbsolutePressure Ps(start=10e5, min=0) "Pressure at the outlet";
  Units.SI.Temperature Te(min=0) "Temperature at the inlet";
  Units.SI.Temperature Ts(min=0) "Temperature at the outlet";
  Units.SI.Velocity Vs "Fluid velocity at the outlet";
  Units.SI.Density rhos(start=200) "Fluid density at the outlet";
  Real xm(start=1.0,min=0) "Average vapor mass fraction";

public
  Medium.ThermodynamicState state_e;
  Medium.ThermodynamicState state_s1;
  Medium.ThermodynamicState state_s;
  Medium.ThermodynamicState state_ps;
  Interfaces.Connectors.FluidInlet Ce(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{-111,-10},{-91,10}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Cs(redeclare package Medium = Medium) annotation (Placement(transformation(
          extent={{91,-10},{111,10}}, rotation=0)));
  ThermoSysPro.ElectroMechanics.Connectors.MechanichalTorque M
    annotation (Placement(transformation(
        origin={0,-100},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal MechPower
                              annotation (Placement(transformation(
        origin={110,-90},
        extent={{10,-10},{-10,10}},
        rotation=180)));
equation

  if (cardinality(M) == 0) then
    M.Ctr = 0;
    M.w = 0;
  else
    M.Ctr*M.w = W;
  end if;

  Ce.Q = Cs.Q;

  Ce.h_vol_1 = Cs.h_vol_1;
  Ce.h_vol_2 = Cs.h_vol_2;

  Cs.diff_on_1 = if (gamma_diff > 0) then Ce.diff_on_1 else false;
  Ce.diff_on_2 = if (gamma_diff > 0) then Cs.diff_on_2 else false;

  Cs.diff_res_1 = Ce.diff_res_1 + (if (gamma_diff > 0) then 1/gamma_diff else 0);
  Ce.diff_res_2 = Cs.diff_res_2 + (if (gamma_diff > 0) then 1/gamma_diff else 0);

  /* Fluid composition balance equations*/
  Ce.Xi = Cs.Xi;


  Ce.SubC = Cs.SubC;

  Q = Ce.Q;
  Pe = Ce.P;
  Ps = Cs.P;


  /* Isentropic efficiency */
  eta_is = if (Q < Qmax) then (max(eta_is_min,(a*(Q/Qmax)^2 + b*(Q/Qmax) + c))) else eta_is_nom;
  eta_is_wet = xm*eta_is;

  /* Average vapor mass fraction during the expansion */
  if noEvent((Pe > pcrit) or (Te > Tcrit)) then
    xm = 1;
  else
    xm = (Medium.vapourQuality(state_e) + Medium.vapourQuality(state_s1))/2.0;
  end if;

  /* Stodola's ellipse law */
  if noEvent((Pe > pcrit) or (Te > Tcrit)) then
    Q = sqrt((Pe^2 - Ps^2)/(Cst*Te));
  else
    Q = sqrt((Pe^2 - Ps^2)/(Cst*Te*Medium.vapourQuality(state_e)));
  end if;

  /* Fluid specific enthalpy after the expansion */
  Hrs - Ce.h = xm*eta_is*(His - Ce.h);

  /* Fluid specific enthalpy at the outlet of the nozzle */
  Vs = Q/rhos/area_nz;
  Cs.h - Hrs = (1 - eta_nz)*Vs^2/2;

  /* Mechanical power produced by the turbine */
  W = Q*eta_stato*(Ce.h - Cs.h)*(1 - W_fric/100);
  MechPower.signal = W;

  /* Fluid thermodynamic properties before the expansion */
  state_e=Medium.setState_ph(p=Pe, h=Ce.h, phase=phase_e);

  Te = state_e.T;

  /* Fluid thermodynamic properties after the expansion */
  state_s1 = Medium.setState_ph(p=Ps, h=Hrs, phase=phase_s);

  /* Fluid thermodynamic properties at the outlet of the nozzle */
  state_s = Medium.setState_ph(p=Ps, h=Cs.h, phase=phase_s);

  Ts = state_s.T;
  rhos = state_s.d;

  /* Fluid thermodynamic properties after the isentropic expansion */
  state_ps = Medium.setState_ps(p=Ps, s=Medium.specificEntropy(state_e), phase=phase_ps);
  His = state_ps.h;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Polygon(
          points={{-100,40},{-100,-40},{100,-100},{100,100},{-100,40}},
          lineColor={0,0,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid), Line(
          points={{0,-70},{0,-90}},
          color={0,0,0},
          thickness=0.5)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Polygon(
          points={{-100,40},{-100,-40},{100,-100},{100,100},{-100,40}},
          lineColor={0,0,0},
          fillColor= DynamicSelect({127,255,0}, fill_color_singular),
          fillPattern=FillPattern.Solid), Line(
          points={{0,-70},{0,-90}},
          color={0,0,0},
          thickness=0.5)}),
    Window(
      x=0.17,
      y=0.1,
      width=0.76,
      height=0.76),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 10.2 of the ThermoSysPro book.   
    ", revisions = "
Authors  

Daniel Bouskela  
Baligh El Hefni   

    "));
end StodolaTurbine;
