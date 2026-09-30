within ThermoSysPro.Fluid.Volumes;

model Pressurizer "Pressurizer"
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
  replaceable package Medium = ThermoSysPro.Properties.Media.WaterSteam constrainedby ThermoSysPro.Properties.Media.PartialTwoPhaseThermoSysProMedium "Medium model" annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable function SaS = Medium.noSaS(SubC = SubCv) annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));
  replaceable function PhasesSeparationFunction = Medium.HomogeneousPhasesSeparation(SubC = Cs.SubC) annotation (choicesAllMatching=true, Dialog(tab="Fluid", group="Medium"));

  parameter Units.SI.Volume V=61.1 "Pressurizer volume";
  parameter Units.SI.Radius Rp=1.265 "Pressurizer cross-sectional radius";
  parameter Units.SI.Area Ae=1 "Wall surface";
  parameter Units.SI.Position Zm=10.15 "Hauteur de la gamme de mesure niveau";
  parameter Real Ccond=0.1 "Condensation coefficient";
  parameter Real Cevap=0.1 "Evaporation coefficient";
  parameter Units.SI.CoefficientOfHeatTransfer Klv=0.5e6
    "Heat exchange coefficient between the liquid and gas phases";
  parameter Units.SI.CoefficientOfHeatTransfer Klp=50000
    "Heat exchange coefficient between the liquid phase and the wall";
  parameter Units.SI.CoefficientOfHeatTransfer Kvp=25
    "Heat exchange coefficient between the gas phase and the wall";
  parameter Units.SI.CoefficientOfHeatTransfer Kpa=542
    "Heat exchange coefficient between the wall and the outside";
  parameter Units.SI.Mass Mp=117e3 "Wall mass";
  parameter Units.SI.SpecificHeatCapacity cpp=600 "Wall specific heat";
  parameter Boolean dynamic_energy_balance=true
    "true: dynamic energy balance equation - false: static energy balance equation";
  parameter Boolean steady_state=true
    "true: start from steady state - false: start from (P0, Vf0) (active if dynamic_energy_balance=true)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance));
  parameter Real Yw0=50
    "Initial water level - percent of the measure scale level (active if steady_state=false)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance and not steady_state));
  parameter Units.SI.AbsolutePressure P0=155e5
    "Initial fluid pressure (active if steady_state=false)" annotation (
      Evaluate=true, Dialog(enable=dynamic_energy_balance and not steady_state));
  parameter Boolean continuous_flow_reversal=false "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";
  parameter Medium.ExtraProperty SubCl0[Medium.nC](quantity=Medium.extraPropertiesNames)=Medium.C_default
    "Initial liquid phase trace substances"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance and not steady_state));
  parameter Medium.ExtraProperty SubCv0[Medium.nC](quantity=Medium.extraPropertiesNames)=Medium.C_default
    "Initial vapor phase trace substances"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance and not steady_state));

protected
  constant Real pi=Modelica.Constants.pi "Pi";
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";
  parameter Units.SI.Area Ap=pi*Rp*Rp "Pressurizer cross-sectional area";
  Medium.C_BiPhase C_record;

public
  Units.SI.Area Slpin "Exchange surface between the liquid and the wall";
  Units.SI.Area Svpin "Exchange surface between the vapor and the wall";
  Real Yw(start = 50) "Liquid level as a percent of the measure scale";
  Real y(start = 0.5) "Liquid level as a proportion of the measure scale";
  Units.SI.Position Zl(start = 20) "Liquid level in the pressurizer";
  Units.SI.Volume Vl "Liquid phase volume";
  Units.SI.Volume Vv "Gas phase volume";
  Units.SI.AbsolutePressure P(start = 155.0e5) "Average fluid pressure";
  Units.SI.AbsolutePressure Pfond "Fluid pressure at the bottom of the drum";
  Units.SI.SpecificEnthalpy hl "Liquid phase specific enthalpy";
  Units.SI.SpecificEnthalpy hv "Gas phase specific enthalpy";
  Units.SI.SpecificEnthalpy hls "Liquid phase saturation specific enthalpy";
  Units.SI.SpecificEnthalpy hvs "Gas phase saturation specific enthalpy";
  Units.SI.Temperature Tl "Liquid phase temperature";
  Units.SI.Temperature Tv "Gas phase temperature";
  Units.SI.Temperature Tp(start = 617.24) "Wall temperature";
  Units.SI.Temperature Ta "External temperature";
  Units.SI.Power Wlv "Thermal power exchanged from the gas phase to the liquid phase";
  Units.SI.Power Wpl "Thermal power exchanged from the liquid phase to the wall";
  Units.SI.Power Wpv "Thermal power exchanged from the gas phase to the wall";
  Units.SI.Power Wpa "Thermal power exchanged from the outside to the wall";
  Units.SI.Power Wch "Power released by the electrical heaters";
  Units.SI.MassFlowRate BQl
    "Right hand side of the mass balance equation of the liquid phase";
  Units.SI.MassFlowRate BQv
    "Right hand side of the mass balance equation of the gas phase";
  Units.SI.Power BHl
    "Right hand side of the energy balance equation of the liquid phase";
  Units.SI.Power BHv
    "Right hand side of the energy balance equation of the gas phase";
  Units.SI.MassFlowRate Qcond
    "Condensation mass flow rate from the vapor phase";
  Units.SI.MassFlowRate Qevap
    "Evaporation mass flow rate from the liquid phase";
  Units.SI.Density rhol(start=996) "Liquid phase density";
  Units.SI.Density rhov(start=1.5) "Vapor phase density";
  Units.SI.Power Jas "Thermal power diffusion from inlet Cas";
  Units.SI.Power Jex "Thermal power diffusion from outlet Cex";
  Units.SI.Power Js "Thermal power diffusion from outlet Cs";
  Units.SI.Power Jt_l "Total thermal power diffusion for the liquid";
  Units.SI.Power Jt_v "Total thermal power diffusion for the vapor";
  Units.SI.MassFlowRate gamma_as "Diffusion conductance for inlet Cas";
  Units.SI.MassFlowRate gamma_ex "Diffusion conductance for outlet Cex";
  Units.SI.MassFlowRate gamma_s "Diffusion conductance for outlet Cs";
  Real ras "Value of r(Q/gamma) for inlet Cas";
  Real rex "Value of r(Q/gamma) for outlet Cex";
  Real rs "Value of r(Q/gamma) for outlet Cs";
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
  Medium.ThermodynamicState state_l "Liquid state in the pressurizer";
  Medium.ThermodynamicState state_v "Vapor state in the pressurizer";
  Medium.SaturationProperties sat "Saturation properties at pressurizer pressure";
  Real ddphl "Liquid density derivative wrt. pressure at constant enthalpy";
  Real ddhpl "Liquid density derivative wrt. enthalpy at constant pressure";
  Real ddphv "Vapor density derivative wrt. pressure at constant enthalpy";
  Real ddhpv "Vapor density derivative wrt. enthalpy at constant pressure";

  Interfaces.Connectors.FluidInlet Cas(redeclare package Medium = Medium) "Water input" annotation (Placement(
        transformation(extent={{-8,92},{8,108}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Cs(redeclare package Medium = Medium) "Steam output" annotation (Placement(
        transformation(extent={{92,90},{108,106}}, rotation=0)));
  ThermoSysPro.Thermal.Connectors.ThermalPort Ca "Thermal input to the wall"
    annotation (Placement(transformation(extent={{-100,-8},{-80,12}}, rotation=
            0)));
  ThermoSysPro.Thermal.Connectors.ThermalPort Cc "Thermal input to the liquid"
    annotation (Placement(transformation(extent={{-10,-42},{10,-22}}, rotation=
            0)));

public
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal yLevel
    "Water level"
    annotation (Placement(transformation(extent={{80,-10},{100,10}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Cex(redeclare package Medium = Medium) "Water output" annotation (Placement(
        transformation(extent={{-8,-108},{8,-92}}, rotation=0)));
initial equation
  if dynamic_energy_balance then
    if steady_state then
      der(P) = 0;
      der(hl) = 0;
      der(hv) = 0;
      der(y) = 0;
      der(Tp) = 0;
      der(SubCl) = fill(0, Medium.nC);
      der(SubCv) = fill(0, Medium.nC);
    else
      P = P0;
      hl = hls;
      hv = hvs;
      Yw = Yw0;
      der(Tp) = 0;
      SubCl = SubCl0;
      SubCv = SubCv0;
    end if;
  end if;
equation
  /* Unconnected connectors */
  if (cardinality(Cas) == 0) then
    Cas.Q = 0;
    Cas.h = 1.e5;
    Cas.h_vol_1 = 1.e5;
    Cas.diff_res_1 = 0;
    Cas.diff_on_1 = false;
    Cas.SubC = Medium.C_default;
  end if;
  if (cardinality(Cex) == 0) then
    Cex.Q = 0;
    Cex.h_vol_2 = 1.e5;
    Cex.diff_res_2 = 0;
    Cex.diff_on_2 = false;
  end if;
  if (cardinality(Cs) == 0) then
    Cs.Q = 0;
    Cs.h_vol_2 = 1.e5;
    Cs.diff_res_2 = 0;
    Cs.diff_on_2 = false;
  end if;
  Ca.W = Wpa;
  Ca.T = Ta;
  Cc.W = Wch;
  Cc.T = Tl;
  yLevel.signal = Yw;
/* Computation of the geometrical variables */
  Yw = 100*y;
  Zl = Zm*y + 0.5*(V/Ap - Zm);
  Vl = Ap*Zl;
  Vv = V - Vl;
  Slpin = Zl*2*pi*Rp;
  Svpin = (V/Ap - Zl)*2*pi*Rp;
/* Pressure in the expansion line */
  Pfond = P + g*(Vl*rhol + Vv*rhov)/Ap;
/* Liquid phase mass balance equation */
  BQl = Cas.Q - Cex.Q + Qcond - Qevap;
  if dynamic_energy_balance then
    rhol*Ap*Zm*der(y) + Vl*ddphl*der(P) + Vl*ddhpl*der(hl) = BQl;
  else
    0 = BQl;
  end if;
/* Gas phase mass balance equation */
  BQv = Qevap - Cs.Q - Qcond;
  if dynamic_energy_balance then
    -rhov*Ap*Zm*der(y) + Vv*ddphv*der(P) + Vv*ddhpv*der(hv) = BQv;
  else
    0 = BQv;
  end if;
/* Condensation and evaporation mass flows */
  Qevap = Cevap*rhol*Vl*(hl - hls)/(hvs - hls);
  Qcond = Ccond*rhov*Vv*(hvs - hv)/(hvs - hls);
  Cas.P = P;
  Cs.P = P;
  Cex.P = Pfond;
/* Liquid phase energy balance equation */
  BHl = (Qcond + Cas.Q)*(hls - hl) - Qevap*(hvs - hl) - Cex.Q*(Cex.h - hl) - Wpl + Wlv + Wch + Jt_l;
  if dynamic_energy_balance then
    rhol*Vl*der(hl) - Vl*der(P) = BHl;
  else
    0 = BHl;
  end if;
/* Gas phase energy balance equation */
  BHv = Qevap*(hvs - hv) - Qcond*(hls - hv) - Cas.Q*(hls - Cas.h) - Wpv - Wlv - Cs.Q*(Cs.h - hv) + Jt_v;
  if dynamic_energy_balance then
    rhov*Vv*der(hv) - Vv*der(P) = BHv;
  else
    0 = BHv;
  end if;
  Cas.h_vol_2 = hl;
  Cs.h_vol_1 = hv;
  Cex.h_vol_1 = hl;
/* Energy balance equation at the wall */
  if dynamic_energy_balance then
    Mp*cpp*der(Tp) = Wpl + Wpv + Wpa;
  else
    0 = Wpl + Wpv + Wpa;
  end if;
/* Heat exchange between liquid and gas phases */
  Wlv = Klv*Ap*(Tv - Tl);
/* Heat exchange between the liquid phase and the wall */
  Wpl = Klp*Slpin*(Tl - Tp);
/* Heat exchange between the gas phase and the wall */
  Wpv = Kvp*Svpin*(Tv - Tp);
/* Heat exchange between the wall and the outside */
  Wpa = Kpa*Ae*(Ta - Tp);

  /* Traces composition balance equations */
  C_record = PhasesSeparationFunction();
  SubCSaS = SaS();

  BSubCl = Cas.Q*Cas.SubC - Cex.Q*Cex.SubC + Qcond*C_record.Cl - Qevap*SubCl;
  BSubCv = Qevap*SubCl - Cs.Q*Cs.SubC - Qcond*C_record.Cg;

  if dynamic_energy_balance then
    rhol*Vl*der(SubCl) + SubCl*BQl = BSubCl;
    rhov*Vv*der(SubCv) + SubCv*BQv + rhov*Vv*SubCSaS = BSubCv;
  else
    SubCl*BQl = BSubCl;
    SubCv*BQv + rhov*Vv*SubCSaS = BSubCv;
  end if;

  Cex.SubC = SubCl;
  Cs.SubC = SubCv;

  /* Flow reversal */
  if continuous_flow_reversal then
    Cex.h = ThermoSysPro.Functions.SmoothCond(Cex.Q/gamma_ex, Cex.h_vol_1, Cex.h_vol_2, 1);
    Cs.h = ThermoSysPro.Functions.SmoothCond(Cs.Q/gamma_s, Cs.h_vol_1, Cs.h_vol_2, 1);
  else
    Cex.h = if (Cex.Q > 0) then Cex.h_vol_1 else Cex.h_vol_2;
    Cs.h = if (Cs.Q > 0) then Cs.h_vol_1 else Cs.h_vol_2;
  end if;
/* Diffusion power */
  if diffusion then
    ras = if Cas.diff_on_1 then exp(-0.033*(Cas.Q*Cas.diff_res_1)^2) else 0;
    rex = if Cex.diff_on_2 then exp(-0.033*(Cex.Q*Cex.diff_res_2)^2) else 0;
    rs = if Cs.diff_on_2 then exp(-0.033*(Cs.Q*Cs.diff_res_2)^2) else 0;
    gamma_as = if Cas.diff_on_1 then 1/Cas.diff_res_1 else gamma0;
    gamma_ex = if Cex.diff_on_2 then 1/Cex.diff_res_2 else gamma0;
    gamma_s = if Cs.diff_on_2 then 1/Cs.diff_res_2 else gamma0;
    Jas = if Cas.diff_on_1 then ras*gamma_as*(Cas.h_vol_1 - Cas.h_vol_2) else 0;
    Jex = if Cex.diff_on_2 then rex*gamma_ex*(Cex.h_vol_2 - Cex.h_vol_1) else 0;
    Js = if Cs.diff_on_2 then rs*gamma_s*(Cs.h_vol_2 - Cs.h_vol_1) else 0;
  else
    ras = 0;
    rex = 0;
    rs = 0;
    gamma_as = gamma0;
    gamma_ex = gamma0;
    gamma_s = gamma0;
    Jas = 0;
    Jex = 0;
    Js = 0;
  end if;
  Jt_l = Jas + Jex;
  Jt_v = Js;
  Cas.diff_res_2 = 0;
  Cex.diff_res_1 = 0;
  Cs.diff_res_1 = 0;
  Cas.diff_on_2 = diffusion;
  Cex.diff_on_1 = diffusion;
  Cs.diff_on_1 = diffusion;

  /* Fluid thermodynamic properties */
  state_l = Medium.setState_phX(p=P, h=hl, X=Medium.reference_X);
  state_v = Medium.setState_phX(p=P, h=hv, X=Medium.reference_X);
  sat = Medium.setSat_p(P);

  ddphl = Medium.density_derp_h(state_l);
  ddhpl = Medium.density_derh_p(state_l);
  ddphv = Medium.density_derp_h(state_v);
  ddhpv = Medium.density_derh_p(state_v);

  Tl = Medium.temperature(state_l);
  Tv = Medium.temperature(state_v);
  rhol = Medium.density(state_l);
  rhov = Medium.density(state_v);
  hls = Medium.bubbleEnthalpy(sat);
  hvs = Medium.dewEnthalpy(sat);

  annotation (Icon(graphics={
        Line(
          points={{100,90},{100,60},{80,60},{80,60}},
          color={28,108,200},
          thickness=1),
        Ellipse(
          extent={{-80,-92},{80,-42}},
          lineColor={85,170,255},
          fillColor= DynamicSelect({85,170,255},
          if dynamic_energy_balance then fill_color_dynamic
          else if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=DynamicSelect(FillPattern.Sphere,
          if dynamic_energy_balance then FillPattern.Sphere
          else FillPattern.Solid),
          lineThickness=0.5),
        Rectangle(
          extent={{-80,-14},{80,-68}},
          lineColor={85,170,255},
          fillColor= DynamicSelect({85,170,255},
          if dynamic_energy_balance then fill_color_dynamic
          else if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=DynamicSelect(FillPattern.VerticalCylinder,
          if dynamic_energy_balance then FillPattern.VerticalCylinder
          else FillPattern.Solid),
          lineThickness=0.5),
        Ellipse(
          extent={{-80,42},{80,92}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,40},{0,92}},
          color={28,108,200},
          thickness=1),
        Line(points={{0,38},{0,92}}, color={255,255,255}),
        Rectangle(
          extent={{-80,-14},{80,68}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-79,68},{80,68}}, color={255,255,255}),
        Line(points={{80,60},{100,60},{100,90}}, color={255,255,255})}),
                            Diagram(graphics={
        Ellipse(
          extent={{-80,-92},{80,-42}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-14},{80,-68}},
          lineColor={85,170,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,42},{80,92}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,40},{0,92}},
          color={28,108,200},
          thickness=1),
        Line(points={{0,38},{0,92}}, color={255,255,255}),
        Rectangle(
          extent={{-80,-14},{80,68}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-79,68},{80,68}}, color={255,255,255}),
        Text(
          extent={{58,4},{58,-10}},
          lineColor={0,0,255},
          textString=
               "Niveau"),
        Line(
          points={{100,90},{100,60},{80,60},{80,60}},
          color={28,108,200},
          thickness=1),
        Line(points={{80,60},{100,60},{100,90}}, color={255,255,255})}),
    Documentation(info = "
## Copyright © EDF 2002 - 2026   
## ThermoSysPro Version 4.2   
This component model is documented in Sect. 14.3 of the ThermoSysPro book.   
    ", revisions = "
Authors  

Daniel Bouskela  
Baligh El Hefni   

    "));
end Pressurizer;
