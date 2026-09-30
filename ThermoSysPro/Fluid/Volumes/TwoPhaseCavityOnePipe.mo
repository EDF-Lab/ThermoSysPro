within ThermoSysPro.Fluid.Volumes;

model TwoPhaseCavityOnePipe "TwoPhaseCavity for one shell pass "
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable function SaS = Medium.noSaS(SubC = SubCv) annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable function PhasesSeparationFunction = Medium.HomogeneousPhasesSeparation(SubC = CvBP.SubC) annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Boolean Vertical=true "true: vertical cylinder - false: horizontal cylinder";
  parameter Units.SI.Radius R=1.05 "Radius of the Cavity cross-sectional area";
  parameter Units.SI.Length L=16.27 "Cavity length";
  parameter Units.SI.Length Lc=2.5
    "Support plate spacing in cooling zone(chicanes)";
  parameter Units.SI.Volume V=pi*R^2*L "Cavity volume";
  parameter Units.SI.Volume Vmin=1.e-6;
  parameter Integer Ns=10 "Number of segments";
  parameter Integer NbTubT=10000 "Number of total pipes in Cavity";
  parameter Integer NbTubV=150 "Numbers of pipes in a vertical plan in Cavity";
  parameter Units.SI.Length L2=25 "tubes length";
  parameter Units.SI.Diameter Dext=0.020 "External pipe diameter";
  parameter Real COP=1 "Corrective terme for heat exchange coefficient or Fouling coefficient";
  parameter Real Kcorr=1 "Corrective terme for heat exchange coefficient between the vapor and the liquid Kvl (with a stagnation point Kcorr = 0.5)";
  parameter Boolean Cal_hcond=false "false : condensation heat transfer coefficient = hcond (parameter) - true: calculate by Nusselt corelation";
  parameter Units.SI.CoefficientOfHeatTransfer hcond=8e3
    "Heat transfer coefficient between the vapor and the cooling pipes ";
  parameter Units.SI.CoefficientOfHeatTransfer Kpa=0.02
    "Heat exchange coefficient between the wall and the outside ambiant";
  parameter Units.SI.Temperature Ta=300 "External temperature";
  parameter Units.SI.Mass Mp=50e3 "Wall mass";
  parameter Units.SI.SpecificHeatCapacity cpp=600 "Wall specific heat";
  parameter Boolean step_square=true "true: Square step - false: Triangular step";
  parameter Units.SI.PathLength Ls=L2/Ns "Section length for one pipe";
  parameter Units.SI.Area Surf_exe=pi*Dext*Ls*NbTubT
    "Section heat exchange surface";
  parameter Units.SI.Area Surf_tot=Surf_exe*Ns "Total heat exchange surface";
  parameter Boolean dynamic_energy_balance=true "true: dynamic energy balance equation - false: static energy balance equation";
  parameter Boolean steady_state=true "true: start from steady state - false: start from (P0, Vf0) (active if dynamic_energy_balance=true)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance));
  parameter Real Vf0=0.5 "Fraction of initial water volume in the drum (active if dynamic_energy_balance=true and steady_state=false)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance and not steady_state));
  parameter Units.SI.AbsolutePressure P0=1.e5
    "Fluid initial pressure (active if dynamic_energy_balance=true and steady_state=false)"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance and not
          steady_state));
  parameter Boolean continuous_flow_reversal=false "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false "true: energy balance equation with diffusion - false: energy balance equation without diffusion";
  parameter Medium.ExtraProperty SubCl0[Medium.nC](quantity=Medium.extraPropertiesNames)=Medium.C_default
    "Initial liquid phase trace substances"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance and not steady_state));
  parameter Medium.ExtraProperty SubCv0[Medium.nC](quantity=Medium.extraPropertiesNames)=Medium.C_default
    "Initial vapor phase trace substances"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance and not steady_state));

protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  constant Real pi=Modelica.Constants.pi;
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";
  Medium.C_BiPhase C_record;

public
  Units.SI.Pressure P(start=10000) "Fluid average pressure";
  Units.SI.Pressure Pfond(start=11000)
    "Fluid pressure at the bottom of the cavity";
  Units.SI.SpecificEnthalpy hl(start=200e3) "Liquid phase specific enthalpy";
  Units.SI.SpecificEnthalpy hv(start=250e3) "Gas phase specific enthalpy";
  Units.SI.SpecificEnthalpy hvIn(start=2400000)
    "Steam average specific enthalpy input cavity";
  Units.SI.Temperature Tl(start=310) "Liquid phase temperature";
  Units.SI.Temperature Tv(start=320) "Gas phase temperature";
  Units.SI.Volume Vl(start=100) "Liquid phase volume";
  Units.SI.Volume Vv(start=2000) "Gas phase volume";
  Real xl(start=0.5) "Mass vapor fraction in the liquid phase";
  Real xv(start=0) "Mass vapor fraction in the gas phase";
  Units.SI.Density rhol(start=996) "Liquid phase density";
  Units.SI.Density rhov(start=1.5) "Gas phase density";
  Units.SI.MassFlowRate BQl
    "Right hand side of the mass balance equation of the liquid phase";
  Units.SI.MassFlowRate BQv
    "Right hand side of the mass balance equation of the gas phaser";
  Units.SI.Power BHl
    "Right hand side of the energy balance equation of the liquid phase";
  Units.SI.Power BHv
    "Right hand side of the energy balance equation of the gas phase";
  Units.SI.MassFlowRate Qcond(start=1000)
    "Condensation mass flow rate from the vapor phase";
  Units.SI.MassFlowRate QcondS(start=100)
    "Splitter mass flow rate of the liquid phase from the two-phase input";
  Units.SI.Power Wvl
    "Thermal power exchanged from the gas phase to the liquid phase";
  Units.SI.Power Wlp
    "Thermal power exchanged from the liquid phase to the wall";
  Units.SI.Power Wvp "Thermal power exchanged from the gas phase to the wall";
  Units.SI.Power Wpa "Thermal power losses to ambiant";
  Units.SI.Power dW[Ns](start = fill(10e5, Ns)) "Power exchange between the wall and the fluid in each section side 3";
  Units.SI.Power Wt "Total power exchanged on the water side 3";
  Units.SI.Power Wt2(start = 0) "Total power exchanged Deheating zone";
  Units.SI.Temperature Tp1[Ns](start = fill(320, Ns)) "Wall temperature in section i of side 1";
  Units.SI.Temperature Tp(start = 320) "Wall temperature of cavity";
  Units.SI.Position zl(start = 1.05) "Liquid level in Cavity";
  Units.SI.Area Al "Cross sectional area of the liquid phase";
  Units.SI.Angle theta "Angle";
  Units.SI.Area Avl(start = 1.0) "Heat exchange surface between the liquid and gas phases";
  Units.SI.Area Alp "Liquid phase surface on contact with the wall";
  Units.SI.Area Avp "Gas phase surface on contact with the wall";
  Units.SI.Area Ape "Wall surface on contact with the outside";
  Units.SI.ReynoldsNumber Rel(start=6.e4) "Liquid phase Reynolds number";
  Units.SI.ReynoldsNumber Rev(start=6.e3) "Steam phase Reynolds number";
  Units.SI.ReynoldsNumber Revl(start=6.e3) "Steam liquid Reynolds number";
  Units.SI.ThermalConductivity kl(start=1) "Liquid phase thermal conductivity";
  Units.SI.ThermalConductivity kv(start=1) "Steam phase thermal conductivity";
  Units.SI.DynamicViscosity mul(start=2.e-4) "Liquid phase dynamic viscosity ";
  Units.SI.DynamicViscosity muv(start=2.e-5) "Steam phase dynamic viscosity ";
  Units.SI.CoefficientOfHeatTransfer hcond3[Ns](start=fill(1e4, Ns))
    "Heat transfer coefficient between the vapor and the cooling pipes 2";
  Units.SI.CoefficientOfHeatTransfer Kvl(start=10)
    "Heat exchange coefficient between the liquid and gas phases";
  Units.SI.CoefficientOfHeatTransfer Klp(start=10)
    "Heat exchange coefficient between the liquid phase and the wall";
  Units.SI.CoefficientOfHeatTransfer Kvp(start=10)
    "Heat exchange coefficient between the gas phase and the wall";
  Units.SI.Power Je "Thermal power diffusion from inlet Ce";
  Units.SI.Power JvGCT "Thermal power diffusion from inlet CvGCT";
  Units.SI.Power JvBP "Thermal power diffusion from inlet CvBP";
  Units.SI.Power Jl "Thermal power diffusion from outlet Cl";
  Units.SI.Power Jt_l "Total thermal power diffusion for the liquid";
  Units.SI.Power Jt_v "Total thermal power diffusion for the vapor";
  Units.SI.MassFlowRate gamma_e "Diffusion conductance for inlet Ce";
  Units.SI.MassFlowRate gamma_vGCT "Diffusion conductance for inlet CvGCT";
  Units.SI.MassFlowRate gamma_vBP "Diffusion conductance for inlet CvBP";
  Units.SI.MassFlowRate gamma_l "Diffusion conductance for outlet Cl";
  Real re "Value of r(Q/gamma) for inlet Ce";
  Real rvGCT "Value of r(Q/gamma) for inlet CvGCT";
  Real rvBP "Value of r(Q/gamma) for inlet CvBP";
  Real rl "Value of r(Q/gamma) for outlet Cl";
  Medium.ExtraProperty BSubCl[Medium.nC](quantity=Medium.extraPropertiesNames)
    "Right hand side of the trace balance equation of the liquid phase";
  Medium.ExtraProperty BSubCv[Medium.nC](quantity=Medium.extraPropertiesNames)
    "Right hand side of the trace balance equation of the vapor phase";
  Medium.ExtraProperty SubCl[Medium.nC](quantity=Medium.extraPropertiesNames, start=Medium.C_default)
    "Liquid phase trace substances";
  Medium.ExtraProperty SubCv[Medium.nC](quantity=Medium.extraPropertiesNames, start=Medium.C_default)
    "Vapor phase trace substances";
  Medium.ExtraProperty SubCSaS[Medium.nC](quantity=Medium.extraPropertiesNames)
    "Trace modification in the trace balance equation";

  Medium.ThermodynamicState state_l "Liquid state in the cavity";
  Medium.ThermodynamicState state_v "Vapor state in the cavity";
  Medium.ThermodynamicState state_in_l "Water inlet state";
  Medium.ThermodynamicState state_in_v "Average vapor inlet state";
  Medium.ThermodynamicState state_out_l "Water outlet state";
  Medium.SaturationProperties sat "Saturation properties at cavity pressure";
  Units.SI.SpecificEnthalpy hlsat "Bubble enthalpy at cavity pressure";
  Units.SI.SpecificEnthalpy hvsat "Dew enthalpy at cavity pressure";
  Real ddphl "Liquid density derivative wrt. pressure at constant enthalpy";
  Real ddhpl "Liquid density derivative wrt. enthalpy at constant pressure";
  Real ddphv "Vapor density derivative wrt. pressure at constant enthalpy";
  Real ddhpv "Vapor density derivative wrt. enthalpy at constant pressure";

  Interfaces.Connectors.FluidInlet CvBP(redeclare package Medium = Medium) "Steam input" annotation (Placement(
        transformation(extent={{-86,50},{-66,70}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Cl(redeclare package Medium = Medium) "Water output" annotation (Placement(
        transformation(extent={{-85,-170},{-65,-150}}, rotation=0)));
  ThermoSysPro.Thermal.Connectors.ThermalPort Cth3[Ns]
                                     annotation (Placement(transformation(
          extent={{-82,0},{-70,12}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal yLevel
    "Water level"                        annotation (Placement(transformation(
          extent={{88,-107},{108,-87}}, rotation=0)));
public
  Interfaces.Connectors.FluidInlet Ce(redeclare package Medium = Medium) "Water input" annotation (Placement(
        transformation(extent={{-219,19},{-199,39}}, rotation=0)));
  Interfaces.Connectors.FluidInlet CvGCT(redeclare package Medium = Medium) "Steam input" annotation (Placement(
        transformation(extent={{-160,50},{-140,70}}, rotation=0)));
initial equation
  if dynamic_energy_balance then
    if steady_state then
      der(hl) = 0;
      der(hv) = 0;
//Vl = Vf0*V; // without liquid level control
      der(Vl) = 0;
// with liquid level control
      der(P) = 0;
      der(Tp) = 0;
      der(hvIn) = 0;
      der(SubCl) = fill(0, Medium.nC);
      der(SubCv) = fill(0, Medium.nC);
    else
      hl = hlsat;
      hv = hvsat;
      Vl = Vf0*V;
      P = P0;
      Tp = 320;
      hvIn = hv;
      SubCl = SubCl0;
      SubCv = SubCv0;
    end if;
  end if;
equation
  /* Unconnected connectors */
  if (cardinality(Ce) == 0) then
    Ce.Q = 0;
    Ce.h = 1.e5;
    Ce.h_vol_1 = 1.e5;
    Ce.diff_res_1 = 0;
    Ce.diff_on_1 = false;
    Ce.SubC = Medium.C_default;
  end if;
  if (cardinality(CvGCT) == 0) then
    CvGCT.Q = 0;
    CvGCT.h = 1.e5;
    CvGCT.h_vol_1 = 1.e5;
    CvGCT.diff_res_1 = 0;
    CvGCT.diff_on_1 = false;
    CvGCT.SubC = Medium.C_default;
  end if;
  if (cardinality(CvBP) == 0) then
    CvBP.Q = 0;
    CvBP.h = 1.e5;
    CvBP.h_vol_1 = 1.e5;
    CvBP.diff_res_1 = 0;
    CvBP.diff_on_1 = false;
    CvBP.SubC = Medium.C_default;
  end if;
  if (cardinality(Cl) == 0) then
    Cl.Q = 0;
    Cl.h_vol_2 = 1.e5;
    Cl.diff_res_2 = 0;
    Cl.diff_on_2 = false;
  end if;
/* Wall temperature and heat flow rate*/
  Cth3.T = Tp1;
  Cth3.W = dW;
/* Liquid volume */
  if Vertical then
    theta = 1;
    Al = pi*R^2;
    Vl = Al*zl;
    Avl = Al;
  else
    theta = Modelica.Math.asin(max(-0.9999, min(0.9999, (R - zl)/R)));
    Al = (pi/2 - theta)*R^2 - R*(R - zl)*Modelica.Math.cos(theta);
    Vl = Al*L;
    Avl = 2*R*Modelica.Math.cos(theta)*L;
  end if;
/* Cavity volume */
  V = Vl + Vv;
/* Water level */
  yLevel.signal = zl;
/* Liquid surface and vapor surface on contact with wall */
  Alp = if Vertical then 2*pi*R*zl + Al else (pi - 2*theta)*R*L + 2*Al;
  Avp = if Vertical then 2*pi*R*(L - zl) + Al else (pi + 2*theta)*R*L + 2*(pi*R^2 - Al);
/* Wall surface on contact with the outside */
  Ape = Alp + Avp;

  /* Pressure at the bottom of the cavity */
  Pfond = P + Medium.density(state_out_l)*g*zl;

  /* Liquid phase mass balance equation */
  BQl = -Cl.Q + Qcond + QcondS + (1 - Medium.vapourQuality(state_in_l))*Ce.Q;

  if dynamic_energy_balance then
    rhol*der(Vl) + Vl*(ddphl*der(P) + ddhpl*der(hl)) = BQl;
  else
    0 = BQl;
  end if;

  /* Vapor phase mass balance equation */
  BQv = CvBP.Q + CvGCT.Q - Qcond - QcondS + Medium.vapourQuality(state_in_l)*Ce.Q;

  if dynamic_energy_balance then
    rhov*der(Vv) + Vv*(ddphv*der(P) + ddhpv*der(hv)) = BQv;
  else
    0 = BQv;
  end if;
  Cl.P = Pfond;
  CvGCT.P = P;
  CvBP.P = P;
  Ce.P = P;

  /* Liquid phase energy balance equation */
  BHl = -Cl.Q*(Cl.h - (hl - P/rhol)) + (Qcond + QcondS)*(hlsat - (hl - P/rhol)) + (1 - Medium.vapourQuality(state_in_l))*Ce.Q*((if (Medium.vapourQuality(state_in_l) > 0) then hlsat else Ce.h) - (hl - P/rhol)) - Wlp + Wvl + Jt_l;

  if dynamic_energy_balance then
    Vl*((P/rhol*ddphl - 1)*der(P) + (P/rhol*ddhpl + rhol)*der(hl)) = BHl;
  else
    0 = BHl;
  end if;

  /* Gas phase energy balance equation */
  BHv = CvBP.Q*(CvBP.h - (hv - P/rhov)) + CvGCT.Q*(CvGCT.h - (hv - P/rhov)) - (Qcond + QcondS)*(hlsat - (hv - P/rhov)) + Medium.vapourQuality(state_in_l)*Ce.Q*((if (Medium.vapourQuality(state_in_l) < 1) then hvsat else Ce.h) - (hv - P/rhov)) - Wvl - Wvp + Wt + Jt_v;

  if dynamic_energy_balance then
    Vv*((P/rhov*ddphv - 1)*der(P) + (P/rhov*ddhpv + rhov)*der(hv)) = BHv;
  else
    0 = BHv;
  end if;
  Ce.h_vol_2 = hl;
  CvGCT.h_vol_2 = hv;
  CvBP.h_vol_2 = hv;
  Cl.h_vol_1 = hl;

  /* Condensation mass flow rates */
  // Only the power used to condensate steam
  Qcond = (-Wt + Wt2 + noEvent(max(Wvl, 0)) + Wvp)/(hvsat - hlsat);

  QcondS = (1 - Medium.vapourQuality(state_in_v))*(CvBP.Q + CvGCT.Q);

  /* Steam average specific enthalpy input cavity */
  // 0 = noEvent(hvIn*(max(CvBP.Q, 1e-10) + max(CvGCT.Q, 1e-10)) - max(CvBP.Q, 1e-10)*CvBP.h - max(CvGCT.Q, 1e-10)*CvGCT.h);
  if dynamic_energy_balance then
    0.1*Medium.density(state_in_v)*der(hvIn) = CvBP.Q*(CvBP.h - (hvIn - P/rhov)) + CvGCT.Q*(CvGCT.h - (hvIn - P/rhov));
  else
    0 = hvIn*(CvBP.Q + CvGCT.Q) - CvBP.Q*CvBP.h - CvGCT.Q*CvGCT.h;
  end if;

  /* Traces composition balance equations */
  C_record = PhasesSeparationFunction();
  SubCSaS = SaS();

  BSubCl = (1 - Medium.vapourQuality(state_in_l))*Ce.Q*Ce.SubC - Cl.Q*Cl.SubC + (Qcond + QcondS)*C_record.Cl;
  BSubCv = CvBP.Q*CvBP.SubC + CvGCT.Q*CvGCT.SubC + Medium.vapourQuality(state_in_l)*Ce.Q*Ce.SubC - (Qcond + QcondS)*C_record.Cg;

  if dynamic_energy_balance then
    rhol*Vl*der(SubCl) + SubCl*BQl = BSubCl;
    rhov*Vv*der(SubCv) + SubCv*BQv + rhov*Vv*SubCSaS = BSubCv;
  else
    SubCl*BQl = BSubCl;
    SubCv*BQv + rhov*Vv*SubCSaS = BSubCv;
  end if;

  Cl.SubC = SubCl;

  /* Flow reversal */
  if continuous_flow_reversal then
    Cl.h = ThermoSysPro.Functions.SmoothCond(Cl.Q/gamma_l, Cl.h_vol_1, Cl.h_vol_2, 1);
  else
    Cl.h = if (Cl.Q > 0) then Cl.h_vol_1 else Cl.h_vol_2;
  end if;
/* Diffusion power */
  if diffusion then
    re = if Ce.diff_on_1 then exp(-0.033*(Ce.Q*Ce.diff_res_1)^2) else 0;
    rvGCT = if CvGCT.diff_on_1 then exp(-0.033*(CvGCT.Q*CvGCT.diff_res_1)^2) else 0;
    rvBP = if CvBP.diff_on_1 then exp(-0.033*(CvBP.Q*CvBP.diff_res_1)^2) else 0;
    rl = if Cl.diff_on_2 then exp(-0.033*(Cl.Q*Cl.diff_res_2)^2) else 0;
    gamma_e = if Ce.diff_on_1 then 1/Ce.diff_res_1 else gamma0;
    gamma_vGCT = if CvGCT.diff_on_1 then 1/CvGCT.diff_res_1 else gamma0;
    gamma_vBP = if CvBP.diff_on_1 then 1/CvBP.diff_res_1 else gamma0;
    gamma_l = if Cl.diff_on_2 then 1/Cl.diff_res_2 else gamma0;
    Je = if Ce.diff_on_1 then re*gamma_e*(Ce.h_vol_1 - Ce.h_vol_2) else 0;
    JvGCT = if CvGCT.diff_on_1 then rvGCT*gamma_vGCT*(CvGCT.h_vol_1 - CvGCT.h_vol_2) else 0;
    JvBP = if CvBP.diff_on_1 then rvBP*gamma_vBP*(CvBP.h_vol_1 - CvBP.h_vol_2) else 0;
    Jl = if Cl.diff_on_2 then rl*gamma_l*(Cl.h_vol_2 - Cl.h_vol_1) else 0;
  else
    re = 0;
    rvGCT = 0;
    rvBP = 0;
    rl = 0;
    gamma_e = gamma0;
    gamma_vGCT = gamma0;
    gamma_vBP = gamma0;
    gamma_l = gamma0;
    Je = 0;
    JvGCT = 0;
    JvBP = 0;
    Jl = 0;
  end if;
  Jt_l = Je + Jl;
  Jt_v = JvGCT + JvBP;
  Ce.diff_res_2 = 0;
  CvGCT.diff_res_2 = 0;
  CvBP.diff_res_2 = 0;
  Cl.diff_res_1 = 0;
  Ce.diff_on_2 = diffusion;
  CvGCT.diff_on_2 = diffusion;
  CvBP.diff_on_2 = diffusion;
  Cl.diff_on_1 = diffusion;

  /* Fluid thermodynamic properties*/
  state_in_l = Medium.setState_phX(p=P, h=Ce.h, X=Medium.reference_X);
  state_l = Medium.setState_phX(p=(P + Pfond)/2, h=hl, X=Medium.reference_X);
  state_in_v = Medium.setState_phX(p=P, h=hvIn, X=Medium.reference_X);
  state_v = Medium.setState_phX(p=P, h=hv, X=Medium.reference_X);
  state_out_l = Medium.setState_phX(p=Pfond, h=Cl.h, X=Medium.reference_X);
  sat = Medium.setSat_p(P);
  hlsat = Medium.bubbleEnthalpy(sat);
  hvsat = Medium.dewEnthalpy(sat);

  ddphl = Medium.density_derp_h(state_l);
  ddhpl = Medium.density_derh_p(state_l);
  ddphv = Medium.density_derp_h(state_v);
  ddhpv = Medium.density_derh_p(state_v);

  Tl = Medium.temperature(state_l);
  rhol = Medium.density(state_l);
  xl = noEvent(max(0, min(1, (hl - hlsat)/(hvsat - hlsat))));

  Tv = Medium.temperature(state_v);
  rhov = Medium.density(state_v);
  xv = noEvent(max(0, min(1, (hv - hlsat)/(hvsat - hlsat))));

  muv = Medium.dynamicViscosity(state_in_v);
  mul = Medium.dynamicViscosity(state_l);
  kl = noEvent(Medium.thermalConductivity(state_l));
  kv = noEvent(Medium.thermalConductivity(state_in_v));

  /* Heat transfer coefficient between liquid and wall*/
  /* SACADURA, Von Karman equation*/
  Rel = noEvent(abs(Cl.Q*zl/(pi*R^2*mul)));

  Klp = 0.037*kl*Rel^0.8*(mul*Medium.specificHeatCapacityCp(state_l)/kl)^0.3333/zl;

  /* Heat transfer coefficient between steam and wall*/
  Rev = noEvent(abs((CvBP.Q + CvGCT.Q + Medium.vapourQuality(state_in_l)*Ce.Q)*(L - zl)/(pi*R^2*muv)));
  Revl = noEvent(abs((CvBP.Q + CvGCT.Q + Medium.vapourQuality(state_in_l)*Ce.Q)*(2*R)/(pi*R^2*muv)));

  Kvp = 0.037*kv*Rev^0.8*(muv*Medium.specificHeatCapacityCp(state_v)/kv)^0.3333/(L - zl);

  /* Heat transfer coefficient between steam and liquid */
  Kvl = 0.105*kv*Revl^0.68*(muv*Medium.specificHeatCapacityCp(state_v)/kv)^0.33333*(L/2/R)^(-0.103)/(2*R);

  /* Thermal power losses*/
  /* Energy balance equation at the wall */
  if dynamic_energy_balance then
    Mp*cpp*der(Tp) = Wlp + Wvp - Wpa;
  else
    0 = Wlp + Wvp - Wpa;
  end if;
/* Heat exchange between liquid and gas phases */
  Wvl = Kcorr*Kvl*Avl*(Tv - Tl);
/* Heat exchange between the liquid phase and the wall */
  Wlp = Klp*Alp*(Tl - Tp);
/* Heat exchange between the gas phase and the wall */
  Wvp = Kvp*Avp*(Tv - Tp);
/* Thermal power losses to ambiant, for simplifid we use the wall surface on contact with the fluid (Ape)*/
  Wpa = Kpa*Ape*(Tp - Ta);
  for i in 1:Ns loop
/* Heat transfer coefficient of liquid*/
    if Cal_hcond then
      // Nusselt corelation
      hcond3[i] = ThermoSysPro.Functions.SmoothCond(Tv - Tp1[i],
                       COP*0.728*((g*rhol*(rhol - rhov)*kl^3*(hvsat - hlsat))/(NbTubV*mul*Dext*ThermoSysPro.Functions.SmoothMax((Tv-Tp1[i]), 0.1)))^0.25,
                       COP*0.728*((g*rhol*(rhol - rhov)*kl^3*(hvsat - hlsat))/(NbTubV*mul*Dext*0.1))^0.25);
    else
      hcond3[i] = hcond;
    end if;
/* Power exchanged for each section */
    dW[i] = -hcond3[i]*(Tv - Tp1[i])*Surf_exe + Wt2/Ns;
  end for;
  Wt = sum(dW);

  /* Total power exchanged for deheating*/
  /* This equation is not valid for mass flow rate in the pipes = 0 */
  Wt2 = noEvent(if (hvIn > hvsat) then -(CvBP.Q + CvGCT.Q)*(hvIn - hvsat) else 0);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-250,-200},{100,100}},
        grid={2,2},
        initialScale=0.1), graphics={
        Text(
          extent={{-96,-68},{-78,-76}},
          lineColor={0,0,255},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString=
               "Pipe 3"),
        Text(
          extent={{-118,-15},{-42,-51}},
          lineColor={0,0,255},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString=
               "Horizontal_1pipe"),
        Rectangle(
          extent={{-112,-76},{-56,-80}},
          lineColor={0,0,255},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-138,-54},{-120,-54}},
          color={0,0,255},
          arrow={Arrow.Filled,Arrow.None}),
        Text(
          extent={{-152,-76},{-114,-94}},
          lineColor={0,0,255},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString=
               "in"),
        Line(
          points={{-134,-78},{-116,-78}},
          color={0,0,255},
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-56,-78},{-50,-78},{-50,-54},{-114,-54},{-124,-54}},
          color={0,0,255},
          arrow={Arrow.None,Arrow.Filled}),
        Rectangle(
          extent={{-116,-42},{-44,-114}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-114,-52},{-96,-56}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-126,42},{-32,12}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString=
               "Condensation pipes"),
        Text(
          extent={{-114,30},{-48,6}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString=
               " +  Deheating pipes")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-250,-200},{100,100}},
        grid={2,2},
        initialScale=0.1), graphics={
        Ellipse(
          extent={{-100,50},{100,-150}},
          lineColor={28,108,200},
          fillColor= DynamicSelect({85,170,255},
          if dynamic_energy_balance then fill_color_dynamic
          else if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-250,50},{-50,-150}},
          lineColor={28,108,200},
          fillColor= DynamicSelect({85,170,255},
          if dynamic_energy_balance then fill_color_dynamic
          else if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-160,50},{8,-150}},
          lineColor={28,108,200},
          fillColor= DynamicSelect({85,170,255},
          if dynamic_energy_balance then fill_color_dynamic
          else if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid),
        Line(
          points={{-238,-98},{88,-98}},
          color={0,0,255},
          pattern=LinePattern.Dash),
        Line(
          points={{-228,-112},{78,-112}},
          color={0,0,255},
          pattern=LinePattern.Dash),
        Line(
          points={{-214,-126},{66,-126}},
          color={0,0,255},
          pattern=LinePattern.Dash),
        Line(
          points={{-196,-138},{48,-138}},
          color={0,0,255},
          pattern=LinePattern.Dash),
        Line(
          points={{-232,-106},{82,-106}},
          color={0,0,255},
          pattern=LinePattern.Dash),
        Line(
          points={{-222,-118},{72,-118}},
          color={0,0,255},
          pattern=LinePattern.Dash),
        Line(
          points={{-206,-132},{56,-132}},
          color={0,0,255},
          pattern=LinePattern.Dash),
        Line(
          points={{-182,-144},{32,-144}},
          color={0,0,255},
          pattern=LinePattern.Dash),
        Line(
          points={{-160,-150},{8,-150}},
          color={0,0,255}),
        Line(points={{-160,50},{10,50}}, color={0,0,255}),
        Text(
          extent={{-90,84},{-58,70}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString="Steam LP"),
        Text(
          extent={{-164,84},{-132,70}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "Steam HP"),
        Text(
          extent={{-248,52},{-206,40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString="Water/steam")}),
    Window(
      x=0.11,
      y=0.06,
      width=0.78,
      height=0.88),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
    ", revisions = "
Authors  

Baligh El Hefni  
Daniel Bouskela   

    "));
end TwoPhaseCavityOnePipe;
