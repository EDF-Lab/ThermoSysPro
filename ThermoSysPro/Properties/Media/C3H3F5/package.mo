within ThermoSysPro.Properties.Media;
package C3H3F5 "C3H3F5 medium using the legacy ThermoSysPro property functions"

  extends PartialTwoPhaseThermoSysProMedium(
    isCompressible=true,
    mediumName="C3H3F5",
    substanceNames={"C3H3F5"},
    singleState=false,
    SpecificEnthalpy(start=3.0e5, nominal=3.0e5, min=h_min, max=h_max),
    Density(start=1000, nominal=1000),
    AbsolutePressure(start=10e5, nominal=10e5, min=p_min, max=p_crit),
    Temperature(start=300, nominal=300),
    smoothModel=false,
    onePhase=false,
    fluidConstants={c3h3f5Constants},
    ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.ph);

  constant AbsolutePressure p_min=1 "Lower pressure bound of the legacy fit";
  constant AbsolutePressure p_crit=3640000 "Critical pressure used by the legacy fit";
  constant SpecificEnthalpy h_min=100000 "Lower enthalpy bound of the legacy fit";
  constant SpecificEnthalpy h_max=640000 "Upper enthalpy bound of the legacy fit";
  constant Temperature T_min=200 "Lower temperature search bound";
  constant Temperature T_max=6000 "Upper temperature search bound";

  constant FluidConstants c3h3f5Constants(
    iupacName="C3H3F5",
    casRegistryNumber="",
    chemicalFormula="C3H3F5",
    structureFormula="",
    molarMass=0.134047);

  redeclare record extends SaturationProperties
  end SaturationProperties;

  redeclare record extends ThermodynamicState "Thermodynamic state"
    SpecificEnthalpy h "Specific enthalpy";
    Density d "Density";
    Temperature T "Temperature";
    AbsolutePressure p "Pressure";
  end ThermodynamicState;

protected
  function saturationTemperature_p
    input AbsolutePressure p "Pressure";
    output Temperature T "Saturation temperature";
  protected
    AbsolutePressure Pcalc;
  algorithm
    if p > p_crit then
      Pcalc := p_crit/100000;
    elseif p <= 0 then
      Pcalc := 1/100000;
    else
      Pcalc := p/100000;
    end if;

    T := -0.0000033655*Pcalc^6 + 0.0004044854*Pcalc^5 - 0.0190328128*Pcalc^4
       + 0.4443722095*Pcalc^3 - 5.4337547883*Pcalc^2
       + 36.7572359309*Pcalc + 246.4280421048;
    annotation (Inline=true);
  end saturationTemperature_p;

  function temperatureResidual_h
    extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(p, u);
    y := pro.T - T;
  end temperatureResidual_h;

  function saturationPressureResidual_p
    extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
    input Temperature T "Saturation temperature";
  algorithm
    y := saturationTemperature_p(u) - T;
  end saturationPressureResidual_p;

public
  redeclare replaceable model extends BaseProperties(
    h(stateSelect=StateSelect.prefer),
    d(stateSelect=StateSelect.default),
    T(stateSelect=StateSelect.default),
    p(stateSelect=StateSelect.prefer))
    "Base properties of C3H3F5"
    Integer phase(
      min=0,
      max=2,
      start=1,
      fixed=false) "2 for two-phase, 1 for one-phase, 0 if not known";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  equation
    pro = ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(p, h);
    MM = fluidConstants[1].molarMass;
    R_s = Modelica.Constants.R/fluidConstants[1].molarMass;

    phase = if pro.x > 0 and pro.x < 1 then 2 else 1;
    sat = setSat_p(p);
    state = ThermodynamicState(
      p=p,
      h=h,
      T=pro.T,
      d=pro.d,
      phase=phase);

    T = pro.T;
    d = pro.d;
    u = h - p/d;
  end BaseProperties;

  redeclare function density_ph
    "Computes density as a function of pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(p, h);
    d := pro.d;
    annotation (Inline=true);
  end density_ph;

  redeclare function temperature_ph
    "Computes temperature as a function of pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    output Temperature T "Temperature";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(p, h);
    T := pro.T;
    annotation (Inline=true);
  end temperature_ph;

  redeclare function extends setState_phX
    "Return thermodynamic state as function of p and h"
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(p, h);
    state := ThermodynamicState(
      p=p,
      h=h,
      T=pro.T,
      d=pro.d,
      phase=if pro.x > 0 and pro.x < 1 then 2 else 1);
    annotation (Inline=true);
  end setState_phX;

  redeclare function extends setState_psX
    "Return thermodynamic state as function of p and s"
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ps(p, s);
    state := ThermodynamicState(
      p=p,
      h=pro.h,
      T=pro.T,
      d=pro.d,
      phase=if pro.x > 0 and pro.x < 1 then 2 else 1);
    annotation (Inline=true);
  end setState_psX;

  redeclare function specificEnthalpy_pT
    "Compute specific enthalpy from p and T by inverting the legacy C3H3F5_Ph fit"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "Specific enthalpy";
  protected
    Temperature Tlow;
    Temperature Thigh;
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph proLow;
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph proHigh;
  algorithm
    proLow := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(p, h_min);
    proHigh := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(p, h_max);
    Tlow := proLow.T;
    Thigh := proHigh.T;

    if T <= Tlow then
      h := h_min;
    elseif T >= Thigh then
      h := h_max;
    else
      h := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
        function temperatureResidual_h(p=p, T=T),
        h_min,
        h_max);
    end if;
  end specificEnthalpy_pT;

  redeclare function specificEnthalpy_pTX
    "Return specific enthalpy from pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] "Mass fractions";
    input FixedPhase phase=0
      "2 for two-phase, 1 for one-phase, 0 if not known";
    output SpecificEnthalpy h "Specific enthalpy at p, T, X";
  algorithm
    h := specificEnthalpy_pT(p, T, phase);
    annotation (Inline=true);
  end specificEnthalpy_pTX;

  redeclare function density_pT
    "Computes density as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  algorithm
    d := density_ph(p, specificEnthalpy_pT(p, T, phase), phase);
    annotation (Inline=true);
  end density_pT;

  redeclare function extends setState_pTX
    "Return thermodynamic state as function of p and T"
  protected
    SpecificEnthalpy h;
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    h := specificEnthalpy_pT(p, T, phase);
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(p, h);
    state := ThermodynamicState(
      p=p,
      h=h,
      T=pro.T,
      d=pro.d,
      phase=if pro.x > 0 and pro.x < 1 then 2 else 1);
    annotation (Inline=true);
  end setState_pTX;

  redeclare function extends setState_dTX
    "Return thermodynamic state as function of d and T"
  algorithm
    assert(false, "C3H3F5: setState_dTX is not available in the legacy ThermoSysPro implementation");
    state := ThermodynamicState(
      p=p_min,
      h=h_min,
      T=T,
      d=d,
      phase=phase);
  end setState_dTX;

  redeclare function extends setSmoothState
    "Return a smooth thermodynamic state"
    import Modelica.Media.Common.smoothStep;
  algorithm
    state := ThermodynamicState(
      p=smoothStep(x, state_a.p, state_b.p, x_small),
      h=smoothStep(x, state_a.h, state_b.h, x_small),
      T=temperature_ph(
        smoothStep(x, state_a.p, state_b.p, x_small),
        smoothStep(x, state_a.h, state_b.h, x_small)),
      d=density_ph(
        smoothStep(x, state_a.p, state_b.p, x_small),
        smoothStep(x, state_a.h, state_b.h, x_small)),
      phase=0);
    annotation (Inline=true);
  end setSmoothState;

  redeclare function temperature_ps
    "Compute temperature from pressure and specific entropy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    output Temperature T "Temperature";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ps(p, s);
    T := pro.T;
    annotation (Inline=true);
  end temperature_ps;

  redeclare function density_ps
    "Computes density as a function of pressure and specific entropy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    output Density d "Density";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ps(p, s);
    d := pro.d;
    annotation (Inline=true);
  end density_ps;

  redeclare function extends pressure "Return pressure"
  algorithm
    p := state.p;
    annotation (Inline=true);
  end pressure;

  redeclare function extends temperature "Return temperature"
  algorithm
    T := state.T;
    annotation (Inline=true);
  end temperature;

  redeclare function extends density "Return density"
  algorithm
    d := state.d;
    annotation (Inline=true);
  end density;

  redeclare function extends specificEnthalpy "Return specific enthalpy"
  algorithm
    h := state.h;
    annotation (Inline=true);
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy
    "Return specific internal energy"
  algorithm
    u := state.h - state.p/state.d;
    annotation (Inline=true);
  end specificInternalEnergy;

  redeclare function extends specificEntropy "Specific entropy"
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(state.p, state.h);
    s := pro.s;
    annotation (Inline=true);
  end specificEntropy;

  redeclare function extends specificGibbsEnergy "Return specific Gibbs energy"
  algorithm
    g := state.h - state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
    "Return specific Helmholtz energy"
  algorithm
    f := state.h - state.p/state.d - state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificHelmholtzEnergy;

  redeclare function extends specificHeatCapacityCp
    "Approximate specific heat capacity at constant pressure"
  protected
    constant Temperature dT=0.1;
  algorithm
    cp := (specificEnthalpy_pT(state.p, state.T + dT) - specificEnthalpy_pT(state.p, state.T - dT))/(2*dT);
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
    "Approximate specific heat capacity at constant volume"
  algorithm
    cv := specificHeatCapacityCp(state);
    annotation (Inline=true);
  end specificHeatCapacityCv;

  redeclare function extends velocityOfSound
    "Velocity of sound is not available in the legacy C3H3F5 implementation"
  algorithm
    assert(false, "C3H3F5: velocityOfSound is not available in the legacy ThermoSysPro implementation");
    a := 0;
  end velocityOfSound;

  redeclare function extends isentropicEnthalpy "Compute h(s,p)"
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ps(p_downstream, specificEntropy(refState));
    h_is := pro.h;
    annotation (Inline=true);
  end isentropicEnthalpy;

  redeclare function extends dynamicViscosity
    "Dynamic viscosity is not available in the legacy C3H3F5 implementation"
  algorithm
    assert(false, "C3H3F5: dynamicViscosity is not available in the legacy ThermoSysPro implementation");
    eta := 0;
  end dynamicViscosity;

  redeclare function extends thermalConductivity
    "Thermal conductivity is not available in the legacy C3H3F5 implementation"
  algorithm
    assert(false, "C3H3F5: thermalConductivity is not available in the legacy ThermoSysPro implementation");
    lambda := 0;
  end thermalConductivity;

  redeclare function extends surfaceTension
    "Surface tension is not available in the legacy C3H3F5 implementation"
  algorithm
    assert(false, "C3H3F5: surfaceTension is not available in the legacy ThermoSysPro implementation");
    sigma := 0;
  end surfaceTension;

  redeclare function extends saturationTemperature
    "Saturation temperature"
  algorithm
    T := saturationTemperature_p(p);
    annotation (Inline=true);
  end saturationTemperature;

  redeclare function extends saturationTemperature_derp
    "Derivative of saturation temperature w.r.t. pressure"
  protected
    constant AbsolutePressure dp=1;
  algorithm
    dTp := (saturationTemperature_p(p + dp) - saturationTemperature_p(p - dp))/(2*dp);
    annotation (Inline=true);
  end saturationTemperature_derp;

  redeclare function extends saturationPressure
    "Saturation pressure"
  protected
    Temperature Tlow;
    Temperature Thigh;
  algorithm
    Tlow := saturationTemperature_p(p_min);
    Thigh := saturationTemperature_p(p_crit);

    if T <= Tlow then
      p := p_min;
    elseif T >= Thigh then
      p := p_crit;
    else
      p := Modelica.Math.Nonlinear.solveOneNonlinearEquation(
        function saturationPressureResidual_p(T=T),
        p_min,
        p_crit);
    end if;
  end saturationPressure;

  redeclare function setSat_p
    "Return saturation properties from pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output SaturationProperties sat "Saturation property record";
  algorithm
    sat := SaturationProperties(
      psat=p,
      Tsat=saturationTemperature_p(p));
    annotation (Inline=true);
  end setSat_p;

  redeclare function setSat_T
    "Return saturation properties from temperature"
    extends Modelica.Icons.Function;
    input Temperature T "Temperature";
    output SaturationProperties sat "Saturation property record";
  algorithm
    sat := SaturationProperties(
      psat=saturationPressure(T),
      Tsat=T);
    annotation (Inline=true);
  end setSat_T;

  redeclare function extends bubbleEnthalpy
    "Boiling curve specific enthalpy"
  protected
    AbsolutePressure Pcalc;
  algorithm
    Pcalc := max(p_min, min(p_crit, sat.psat))/100000;
    hl := 1000*(-0.0000039275*Pcalc^6 + 0.0004780040*Pcalc^5
       - 0.0227439765*Pcalc^4 + 0.5370471515*Pcalc^3
       - 6.6496487588*Pcalc^2 + 46.8685173786*Pcalc
       + 166.7823742593);
    annotation (Inline=true);
  end bubbleEnthalpy;

  redeclare function extends dewEnthalpy
    "Dew curve specific enthalpy"
  protected
    AbsolutePressure Pcalc;
  algorithm
    Pcalc := max(p_min, min(p_crit, sat.psat))/100000;
    hv := 1000*(-0.00000274*Pcalc^6 + 0.00032217*Pcalc^5
       - 0.01489673*Pcalc^4 + 0.34258030*Pcalc^3
       - 4.15381744*Pcalc^2 + 27.64876596*Pcalc
       + 385.22149853);
    annotation (Inline=true);
  end dewEnthalpy;

  redeclare function extends bubbleDensity
    "Boiling curve density"
  protected
    AbsolutePressure Pcalc;
  algorithm
    Pcalc := max(p_min, min(p_crit, sat.psat))/100000;
    dl := 0.0000057803*Pcalc^6 - 0.0007528646*Pcalc^5
       + 0.0377373800*Pcalc^4 - 0.9314090824*Pcalc^3
       + 11.9184348938*Pcalc^2 - 89.9582798898*Pcalc
       + 1467.5902188299;
    annotation (Inline=true);
  end bubbleDensity;

  redeclare function extends dewDensity
    "Dew curve density"
  protected
    AbsolutePressure Pcalc;
  algorithm
    Pcalc := max(p_min, min(p_crit, sat.psat))/100000;
    dv := 0.00000207*Pcalc^6 - 0.00019163*Pcalc^5
       + 0.00675913*Pcalc^4 - 0.10924667*Pcalc^3
       + 0.84661954*Pcalc^2 + 2.83415571*Pcalc
       + 2.12959146;
    annotation (Inline=true);
  end dewDensity;

  redeclare function extends bubbleEntropy
    "Boiling curve specific entropy"
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(sat.psat, bubbleEnthalpy(sat));
    sl := pro.s;
    annotation (Inline=true);
  end bubbleEntropy;

  redeclare function extends dewEntropy
    "Dew curve specific entropy"
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.C3H3F5.C3H3F5_Ph(sat.psat, dewEnthalpy(sat));
    sv := pro.s;
    annotation (Inline=true);
  end dewEntropy;

  redeclare function extends setBubbleState
    "Set the thermodynamic state on the bubble line"
  algorithm
    state := setState_phX(sat.psat, bubbleEnthalpy(sat), fill(0, 0), phase);
    annotation (Inline=true);
  end setBubbleState;

  redeclare function extends setDewState
    "Set the thermodynamic state on the dew line"
  algorithm
    state := setState_phX(sat.psat, dewEnthalpy(sat), fill(0, 0), phase);
    annotation (Inline=true);
  end setDewState;

  redeclare function extends dBubbleDensity_dPressure
    "Bubble point density derivative"
  algorithm
    ddldp := 0;
    annotation (Inline=true);
  end dBubbleDensity_dPressure;

  redeclare function extends dDewDensity_dPressure
    "Dew point density derivative"
  algorithm
    ddvdp := 0;
    annotation (Inline=true);
  end dDewDensity_dPressure;

  redeclare function extends dBubbleEnthalpy_dPressure
    "Bubble point specific enthalpy derivative"
  algorithm
    dhldp := 0;
    annotation (Inline=true);
  end dBubbleEnthalpy_dPressure;

  redeclare function extends dDewEnthalpy_dPressure
    "Dew point specific enthalpy derivative"
  algorithm
    dhvdp := 0;
    annotation (Inline=true);
  end dDewEnthalpy_dPressure;

  redeclare function extends density_derh_p
    "Density derivative by specific enthalpy"
  algorithm
    ddhp := -1e6;
    annotation (Inline=true);
  end density_derh_p;

  redeclare function extends density_derp_h
    "Density derivative by pressure"
  algorithm
    ddph := 1e-8;
    annotation (Inline=true);
  end density_derp_h;

  annotation (Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024</b></p>
<p><b>ThermoSysPro Version 4.1</b></p>
</html>"));
end C3H3F5;
