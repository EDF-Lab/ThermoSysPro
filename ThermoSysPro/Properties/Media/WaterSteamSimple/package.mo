within ThermoSysPro.Properties.Media;
package WaterSteamSimple "Simple water/steam medium using the legacy ThermoSysPro property functions"

  extends PartialTwoPhaseThermoSysProMedium(
    isCompressible=true,
    mediumName="WaterSteamSimple",
    substanceNames={"water"},
    singleState=false,
    SpecificEnthalpy(start=1e5, nominal=5e5),
    Density(start=150, nominal=500),
    AbsolutePressure(
      start=50e5,
      nominal=10e5,
      min=611.657,
      max=100e6),
    Temperature(
      start=500,
      nominal=500,
      min=273.15,
      max=2273.15),
    smoothModel=false,
    onePhase=false,
    fluidConstants=Modelica.Media.Water.waterConstants,
    ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.ph);

  constant Integer Region=0 "Simple water region. 0: automatic";

  redeclare record extends SaturationProperties
  end SaturationProperties;

  redeclare record extends ThermodynamicState
    SpecificEnthalpy h;
    Density d;
    Temperature T;
    AbsolutePressure p;
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    h(stateSelect=StateSelect.prefer),
    d(stateSelect=StateSelect.default),
    T(stateSelect=StateSelect.default),
    p(stateSelect=StateSelect.prefer))
    Integer phase(
      min=0,
      max=2,
      start=1,
      fixed=false);
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  equation
    pro = ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(p, h, Region);
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
    u = pro.u;
  end BaseProperties;

  redeclare function density_ph
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input SpecificEnthalpy h;
    input FixedPhase phase=0;
    output Density d;
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(p, h, Region);
    d := pro.d;
    annotation (Inline=true);
  end density_ph;

  redeclare function temperature_ph
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input SpecificEnthalpy h;
    input FixedPhase phase=0;
    output Temperature T;
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(p, h, Region);
    T := pro.T;
    annotation (Inline=true);
  end temperature_ph;

  redeclare function extends setState_phX
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(p, h, Region);
    state := ThermodynamicState(
        p=p,
        h=h,
        T=pro.T,
        d=pro.d,
        phase=if pro.x > 0 and pro.x < 1 then 2 else 1);
    annotation (Inline=true);
  end setState_phX;

  redeclare function extends setState_psX
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps pro;
  algorithm
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ps(p, s, Region);
    state := ThermodynamicState(
        p=p,
        h=pro.h,
        T=pro.T,
        d=pro.d,
        phase=if pro.x > 0 and pro.x < 1 then 2 else 1);
    annotation (Inline=true);
  end setState_psX;

  redeclare function extends setState_pTX
  protected
    SpecificEnthalpy h;
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    h := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.SpecificEnthalpy_PT(p, T, Region);
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(p, h, Region);
    state := ThermodynamicState(
        p=p,
        h=h,
        T=pro.T,
        d=pro.d,
        phase=if pro.x > 0 and pro.x < 1 then 2 else 1);
    annotation (Inline=true);
  end setState_pTX;

  redeclare function extends setState_dTX
  algorithm
    assert(false, "WaterSteamSimple: setState_dTX is not available in the legacy ThermoSysPro implementation");
    state := ThermodynamicState(
        p=reference_p,
        h=0,
        T=T,
        d=d,
        phase=phase);
  end setState_dTX;

  redeclare function extends setSmoothState
    import Modelica.Media.Common.smoothStep;
  algorithm
    state := setState_phX(
        smoothStep(
          x,
          state_a.p,
          state_b.p,
          x_small),
        smoothStep(
          x,
          state_a.h,
          state_b.h,
          x_small),
        fill(0, 0));
    annotation (Inline=true);
  end setSmoothState;

  redeclare function specificEnthalpy_pTX
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input Temperature T;
    input MassFraction X[:];
    input FixedPhase phase=0;
    output SpecificEnthalpy h;
  algorithm
    h := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.SpecificEnthalpy_PT(p, T, Region);
    annotation (Inline=true);
  end specificEnthalpy_pTX;

  redeclare function temperature_phX
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input SpecificEnthalpy h;
    input MassFraction X[:];
    input FixedPhase phase=0;
    output Temperature T;
  algorithm
    T := temperature_ph(p, h, phase);
    annotation (Inline=true);
  end temperature_phX;

  redeclare function density_phX
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    input SpecificEnthalpy h;
    input MassFraction X[:];
    input FixedPhase phase=0;
    output Density d;
  algorithm
    d := density_ph(p, h, phase);
    annotation (Inline=true);
  end density_phX;

  redeclare function extends pressure
  algorithm
    p := state.p;
    annotation (Inline=true);
  end pressure;

  redeclare function extends temperature
  algorithm
    T := state.T;
    annotation (Inline=true);
  end temperature;

  redeclare function extends density
  algorithm
    d := state.d;
    annotation (Inline=true);
  end density;

  redeclare function extends specificEnthalpy
  algorithm
    h := state.h;
    annotation (Inline=true);
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy
  algorithm
    u := state.h - state.p/state.d;
    annotation (Inline=true);
  end specificInternalEnergy;

  redeclare function extends specificEntropy
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(
        state.p,
        state.h,
        Region);
    s := pro.s;
    annotation (Inline=true);
  end specificEntropy;

  redeclare function extends specificGibbsEnergy
  algorithm
    g := state.h - state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
  algorithm
    f := state.h - state.p/state.d - state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificHelmholtzEnergy;

  redeclare function extends specificHeatCapacityCp
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(
        state.p,
        state.h,
        Region);
    cp := pro.cp;
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
  algorithm
    cv := specificHeatCapacityCp(state);
    annotation (Inline=true);
  end specificHeatCapacityCv;

  redeclare function extends dynamicViscosity
  algorithm
    eta := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.DynamicViscosity_rhoT(rho=state.d, T=state.T);
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
  algorithm
    lambda := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.ThermalConductivity_rhoT(rho=state.d, T=state.T);
    annotation (Inline=true);
  end thermalConductivity;

  redeclare function extends surfaceTension
  algorithm
    sigma := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.SurfaceTension_T(sat.Tsat);
    annotation (Inline=true);
  end surfaceTension;

  redeclare function extends velocityOfSound
  algorithm
    assert(false, "WaterSteamSimple: velocityOfSound is not available in the legacy ThermoSysPro implementation");
    a := 0;
  end velocityOfSound;

  redeclare function extends isentropicEnthalpy
  algorithm
    h_is := specificEnthalpy(
        setState_psX(p_downstream, specificEntropy(refState), fill(0, 0)));
    annotation (Inline=true);
  end isentropicEnthalpy;

  redeclare function extends saturationTemperature
  algorithm
    T := ThermoSysPro.Properties.WaterSteamSimple.Temperature.Tsat_P(p);
    annotation (Inline=true);
  end saturationTemperature;

  redeclare function extends saturationTemperature_derp
  algorithm
    dTp := ThermoSysPro.Properties.WaterSteamSimple.Temperature.dTsatp_P(p);
    annotation (Inline=true);
  end saturationTemperature_derp;

  redeclare function extends saturationPressure
  algorithm
    p := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Pressure_sat_hl(0);
    annotation (Inline=true);
  end saturationPressure;

  redeclare function setSat_p
    extends Modelica.Icons.Function;
    input AbsolutePressure p;
    output SaturationProperties sat;
  protected
    ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat;
    ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat;
  algorithm
    (lsat,vsat) := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_sat_P(p);
    sat := SaturationProperties(psat=p, Tsat=lsat.T);
    annotation (Inline=true);
  end setSat_p;

  redeclare function setSat_T
    extends Modelica.Icons.Function;
    input Temperature T;
    output SaturationProperties sat;
  algorithm
    assert(false, "WaterSteamSimple: setSat_T is not available in the legacy ThermoSysPro implementation");
    sat := SaturationProperties(psat=0, Tsat=T);
  end setSat_T;

  redeclare function extends bubbleEnthalpy
  protected
    ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat;
    ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat;
  algorithm
    (lsat,vsat) := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_sat_P(sat.psat);
    hl := lsat.h;
    annotation (Inline=true);
  end bubbleEnthalpy;

  redeclare function extends dewEnthalpy
  protected
    ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat;
    ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat;
  algorithm
    (lsat,vsat) := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_sat_P(sat.psat);
    hv := vsat.h;
    annotation (Inline=true);
  end dewEnthalpy;

  redeclare function extends bubbleDensity
  algorithm
    dl := density_ph(sat.psat, bubbleEnthalpy(sat));
    annotation (Inline=true);
  end bubbleDensity;

  redeclare function extends dewDensity
  algorithm
    dv := density_ph(sat.psat, dewEnthalpy(sat));
    annotation (Inline=true);
  end dewDensity;

  redeclare function extends bubbleEntropy
  algorithm
    sl := specificEntropy(
        setState_phX(
          sat.psat,
          bubbleEnthalpy(sat),
          fill(0, 0)));
    annotation (Inline=true);
  end bubbleEntropy;

  redeclare function extends dewEntropy
  algorithm
    sv := specificEntropy(
        setState_phX(
          sat.psat,
          dewEnthalpy(sat),
          fill(0, 0)));
    annotation (Inline=true);
  end dewEntropy;

  redeclare function extends setBubbleState
  algorithm
    state := setState_phX(
        sat.psat,
        bubbleEnthalpy(sat),
        fill(0, 0),
        phase);
    annotation (Inline=true);
  end setBubbleState;

  redeclare function extends setDewState
  algorithm
    state := setState_phX(
        sat.psat,
        dewEnthalpy(sat),
        fill(0, 0),
        phase);
    annotation (Inline=true);
  end setDewState;

  redeclare function extends dBubbleDensity_dPressure
  algorithm
    ddldp := 0;
    annotation (Inline=true);
  end dBubbleDensity_dPressure;

  redeclare function extends dDewDensity_dPressure
  algorithm
    ddvdp := 0;
    annotation (Inline=true);
  end dDewDensity_dPressure;

  redeclare function extends dBubbleEnthalpy_dPressure
  algorithm
    dhldp := 0;
    annotation (Inline=true);
  end dBubbleEnthalpy_dPressure;

  redeclare function extends dDewEnthalpy_dPressure
  algorithm
    dhvdp := 0;
    annotation (Inline=true);
  end dDewEnthalpy_dPressure;

  redeclare function extends density_derh_p
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(
        state.p,
        state.h,
        Region);
    ddhp := pro.ddhp;
    annotation (Inline=true);
  end density_derh_p;

  redeclare function extends density_derp_h
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(
        state.p,
        state.h,
        Region);
    ddph := pro.ddph;
    annotation (Inline=true);
  end density_derp_h;
end WaterSteamSimple;
