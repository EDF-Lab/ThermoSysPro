within ThermoSysPro.Properties.Media;
package WaterSteam "1 - Water/steam properties library (IAPWS-IF97)"

  extends PartialTwoPhaseThermoSysProMedium(
    isCompressible=true,
    mediumName="WaterIF97",
    substanceNames={"water"},
    singleState=false,
    SpecificEnthalpy(start=1.0e5, nominal=5.0e5),
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

  redeclare record extends SaturationProperties
  end SaturationProperties;

  redeclare record extends ThermodynamicState "Thermodynamic state"
    SpecificEnthalpy h "Specific enthalpy";
    Density d "Density";
    Temperature T "Temperature";
    AbsolutePressure p "Pressure";
  end ThermodynamicState;
  constant Integer Region = 0 "IF97 region. 0:automatic";

  redeclare replaceable model extends BaseProperties(
    h(stateSelect= StateSelect.prefer),
    d(stateSelect= StateSelect.default),
    T(stateSelect= StateSelect.default),
    p(stateSelect= StateSelect.prefer))
    "Base properties of waterBase properties (p, d, T, h, u, R_s, MM and, if applicable, X and Xi) of a medium"
    Integer phase(
      min=0,
      max=2,
      start=1,
      fixed=false) "2 for two-phase, 1 for one-phase, 0 if not known";
  protected
      ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  equation
      pro = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(p, h, Region);
      MM = fluidConstants[1].molarMass;
      R_s = Modelica.Constants.R/fluidConstants[1].molarMass;

      phase =  if ((h < ThermoSysPro.Properties.WaterSteam.BaseIF97.Regions.hl_p(p))
                 or (h > ThermoSysPro.Properties.WaterSteam.BaseIF97.Regions.hv_p(p))
                 or (p >ThermoSysPro.Properties.WaterSteam.BaseIF97.data.PCRIT)) then 1 else 2;

      sat = setSat_p(state.p);
      state = setState_ph(p, h, phase);

      d=pro.d;
      T=pro.T;
      u = pro.u;
  end BaseProperties;

  redeclare function density_ph
    "Computes density as a function of pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    input Integer region=Region
      "If 0, region is unknown, otherwise known and this input";
    output Density d "Density";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
    pro :=ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
      p,
      h,
      region);
    d := pro.d;
    annotation (Inline=true);
  end density_ph;

  redeclare function temperature_ph
    "Computes temperature as a function of pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    input Integer region=Region
      "If 0, region is unknown, otherwise known and this input";
    output Temperature T "Temperature";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;

  algorithm
    pro :=ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
      p,
      h,
      region);
    T := pro.T;
    annotation (Inline=true);
  end temperature_ph;

  redeclare function extends setState_phX
    "Return thermodynamic state of water as function of p, h, and optional region"
    input Integer region=Region
      "If 0, region is unknown, otherwise known and this input";
  algorithm
    state := ThermodynamicState(
          d=density_ph(
            p,
            h,
            region=region),
          T=temperature_ph(
            p,
            h,
            region=region),
          phase=if region == 0 then 0 else if region==4 then 2 else 1,
          h=h,
          p=p);
    annotation (Inline=true);
  end setState_phX;

  redeclare function temperature_ps
    "Compute temperature from pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    input Integer region=Region
      "If 0, region is unknown, otherwise known and this input";
    output Temperature T "Temperature";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps pro;
  algorithm
    pro :=ThermoSysPro.Properties.WaterSteam.IF97.Water_Ps(
      p,
      s,
      region);
    T := pro.T;
    annotation (Inline=true);
  end temperature_ps;

  redeclare function density_ps
    "Computes density as a function of pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    input Integer region=Region
      "If 0, region is unknown, otherwise known and this input";
    output Density d "Density";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps pro;
  algorithm
    pro :=ThermoSysPro.Properties.WaterSteam.IF97.Water_Ps(
      p,
      s,
      region);
    d := pro.d;
    annotation (Inline=true);
  end density_ps;

  redeclare function specificEnthalpy_pT
    "Computes specific enthalpy as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    input Integer region=Region
      "If 0, region is unknown, otherwise known and this input";
    output SpecificEnthalpy h "Specific enthalpy";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_pT
                               pro;
  algorithm

    pro := ThermoSysPro.Properties.WaterSteam.IF97_packages.IF97_wAJ.Water_PT(p, T, region);
    h := pro.h;
    annotation (Inline=true);
  end specificEnthalpy_pT;

  redeclare function specificEnthalpy_ps
    "Computes specific enthalpy as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    input Integer region=Region
      "If 0, region is unknown, otherwise known and this input";
    output SpecificEnthalpy h "Specific enthalpy";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps pro;
  algorithm
    pro :=ThermoSysPro.Properties.WaterSteam.IF97.Water_Ps(
      p,
      s,
      region);
    h := pro.h;
    annotation (Inline=true);
  end specificEnthalpy_ps;

  redeclare function density_pT
    "Computes density as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    input Integer region=Region
      "If 0, region is unknown, otherwise known and this input";
    output Density d "Density";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_pT
                               pro;
  algorithm

    pro := ThermoSysPro.Properties.WaterSteam.IF97_packages.IF97_wAJ.Water_PT(p, T, region);
    d := pro.d;

    annotation (Inline=true);
  end density_pT;

  redeclare function extends dewEnthalpy "Dew curve specific enthalpy of water"
  protected
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat;
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat;

  algorithm
    (lsat,vsat):=ThermoSysPro.Properties.WaterSteam.IF97_packages.IF97_wAJ.Water_sat_P(sat.psat);
    hv := vsat.h;
    annotation (Inline=true);
  end dewEnthalpy;

  redeclare function extends dewDensity "Dew curve specific density of water"
  protected
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat;
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat;
  algorithm
    (lsat,vsat):=ThermoSysPro.Properties.WaterSteam.IF97_packages.IF97_wAJ.Water_sat_P(sat.psat);
    dv := vsat.rho;
    annotation (Inline=true);
  end dewDensity;

  redeclare function extends setDewState
    "Set the thermodynamic state on the dew line"
  algorithm
    state := ThermodynamicState(
          phase=phase,
          p=sat.psat,
          T=sat.Tsat,
          h=dewEnthalpy(sat),
          d=dewDensity(sat));

    annotation (Inline=true);
  end setDewState;

  redeclare function extends bubbleEnthalpy
    "Boiling curve specific enthalpy of water"
  protected
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat;
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat;

  algorithm
    (lsat,vsat):=ThermoSysPro.Properties.WaterSteam.IF97_packages.IF97_wAJ.Water_sat_P(sat.psat);
    hl := lsat.h;
    annotation (Inline=true);
  end bubbleEnthalpy;

  redeclare function extends bubbleDensity
    "Boiling curve specific density of water"
  protected
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat;
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat;

  algorithm
    (lsat,vsat):=ThermoSysPro.Properties.WaterSteam.IF97_packages.IF97_wAJ.Water_sat_P(sat.psat);
    dl := lsat.rho;
    annotation (Inline=true);
  end bubbleDensity;

  redeclare function extends setBubbleState
    "Set the thermodynamic state on the bubble line"
  algorithm
    state := ThermodynamicState(
          phase=phase,
          p=sat.psat,
          T=sat.Tsat,
          h=bubbleEnthalpy(sat),
          d=bubbleDensity(sat));
    annotation (Inline=true);
  end setBubbleState;

  redeclare function extends dynamicViscosity "Dynamic viscosity of water"
  algorithm

    // Water/Steam  /// FONCTIONNE EN DIPHASIQUE ???
  //   if fluid==1 then
    eta := ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(rho=state.d,T=state.T);
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
    "Thermal conductivity of water"
  input Integer region=Region;
  algorithm
    lambda := ThermoSysPro.Properties.WaterSteam.IF97.ThermalConductivity_rhoT(rho=state.d,T=state.T,P=state.p,region=region);

    annotation (Inline=true);
  end thermalConductivity;

  redeclare function extends surfaceTension
    "Surface tension in two phase region of water"
  algorithm
    sigma := ThermoSysPro.Properties.WaterSteam.IF97.SurfaceTension_T(sat.Tsat);
    annotation (Inline=true);
  end surfaceTension;

  redeclare function extends pressure "Return pressure of ideal gas"
  algorithm
    p := state.p;
    annotation (Inline=true);
  end pressure;

  redeclare function extends temperature "Return temperature of ideal gas"
  algorithm
    T := state.T;
    annotation (Inline=true);
  end temperature;

  redeclare function extends density "Return density of ideal gas"
  algorithm
    d := state.d;
    annotation (Inline=true);
  end density;

  redeclare function extends specificEnthalpy "Return specific enthalpy"
    extends Modelica.Icons.Function;
  algorithm
    h := state.h;
    annotation (Inline=true);
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy
    "Return specific internal energy"
    extends Modelica.Icons.Function;
  algorithm
    u := state.h - state.p/state.d;
    annotation (Inline=true);
  end specificInternalEnergy;

  redeclare function extends specificEntropy "Specific entropy of water"
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;

  algorithm
    pro :=ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
      state.p,
      state.h,
      Region);
    s := pro.s;

    annotation (Inline=true);
  end specificEntropy;

  redeclare function extends specificGibbsEnergy "Return specific Gibbs energy"
    extends Modelica.Icons.Function;
  algorithm
    g := state.h - state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
    "Return specific Helmholtz energy"
    extends Modelica.Icons.Function;
  algorithm
    f := state.h - state.p/state.d - state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificHelmholtzEnergy;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity at constant pressure of water"
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;

  algorithm
    pro :=ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
      state.p,
      state.h,
      Region);
    cp := pro.cp;
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
    "Specific heat capacity at constant volume of water"
  algorithm
    cv := Modelica.Media.Water.IF97_Utilities.cv_ph(
        state.p,
        state.h,
        state.phase,
        Region);
    annotation (Inline=true);
  end specificHeatCapacityCv;

  redeclare function extends velocityOfSound
    "Return velocity of sound as a function of the thermodynamic state record"
  algorithm
    a := ThermoSysPro.Properties.WaterSteam.IF97_Utilities.AnalyticDerivatives.velocityOfSound_pT(state.p,state.T,Region);
    annotation (Inline=true);
  end velocityOfSound;

  redeclare function extends isentropicEnthalpy "Compute h(s,p)"
  algorithm
  //   h_is := Modelica.Media.Water.IF97_Utilities.isentropicEnthalpy(p_downstream, specificEntropy(refState), 0);
    h_is := ThermoSysPro.Properties.WaterSteam.IF97_Utilities.AnalyticDerivatives.dynamicIsentropicEnthalpy(p_downstream, specificEntropy(refState), refState.d, refState.T, refState.phase);
    annotation (Inline=true);
  end isentropicEnthalpy;

  redeclare function extends density_derh_p
    "Density derivative by specific enthalpy"

  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
      pro := ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
      state.p,
      state.h,
      Region);
      ddhp:=pro.ddhp;
    annotation (Inline=true);
  end density_derh_p;

  redeclare function extends density_derp_h "Density derivative by pressure"
   protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;
  algorithm
      pro := ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
      state.p,
      state.h,
      Region);
      ddph:=pro.ddph;
    annotation (Inline=true);
  end density_derp_h;
  //   redeclare function extends density_derT_p
  //     "Density derivative by temperature"
  //   algorithm
  //     ddTp := IF97_Utilities.ddTp(state.p, state.h, state.phase);
  //   end density_derT_p;
  //
  //   redeclare function extends density_derp_T
  //     "Density derivative by pressure"
  //   algorithm
  //     ddpT := IF97_Utilities.ddpT(state.p, state.h, state.phase);
  //   end density_derp_T;

  redeclare function extends bubbleEntropy
    "Boiling curve specific entropy of water"
  protected
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat;
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat;
      ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;

  algorithm
    (lsat,vsat):=ThermoSysPro.Properties.WaterSteam.IF97_packages.IF97_wAJ.Water_sat_P(sat.psat);
     pro := ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
        sat.psat,
        lsat.h,
        Region);
      sl:=pro.s;
    annotation (Inline=true);
  end bubbleEntropy;

  redeclare function extends dewEntropy "Dew curve specific entropy of water"
  protected
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat;
     ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat;
      ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro;

  algorithm
    (lsat,vsat):=ThermoSysPro.Properties.WaterSteam.IF97_packages.IF97_wAJ.Water_sat_P(sat.psat);
     pro := ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
        sat.psat,
        vsat.h,
        Region);
    sv := pro.s;
    annotation (Inline=true);
  end dewEntropy;

  redeclare function extends saturationTemperature
    "Saturation temperature of water"
  algorithm
    T := ThermoSysPro.Properties.WaterSteam.BaseIF97.Basic.tsat(p);
    annotation (Inline=true);
  end saturationTemperature;

  redeclare function extends saturationTemperature_derp
    "Derivative of saturation temperature w.r.t. pressure"
  algorithm
    dTp := ThermoSysPro.Properties.WaterSteam.BaseIF97.Basic.dtsatofp(p);
    annotation (Inline=true);
  end saturationTemperature_derp;

  redeclare function extends saturationPressure "Saturation pressure of water"
  algorithm
    p := ThermoSysPro.Properties.WaterSteam.BaseIF97.Basic.psat(T);
    annotation (Inline=true);
  end saturationPressure;

  redeclare function extends dBubbleDensity_dPressure
    "Bubble point density derivative"
  // algorithm
  //   ddldp := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.drhol_dp(sat.psat);
    annotation (Inline=true);
  end dBubbleDensity_dPressure;

  redeclare function extends dDewDensity_dPressure
    "Dew point density derivative"
  // algorithm
  //   ddvdp := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.drhov_dp(sat.psat);
    annotation (Inline=true);
  end dDewDensity_dPressure;

  redeclare function extends dBubbleEnthalpy_dPressure
    "Bubble point specific enthalpy derivative"
  // algorithm
  //   dhldp := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.dhl_dp(sat.psat);
    annotation (Inline=true);
  end dBubbleEnthalpy_dPressure;

  redeclare function extends dDewEnthalpy_dPressure
    "Dew point specific enthalpy derivative"
  // algorithm
  //   dhvdp := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.dhv_dp(sat.psat);
    annotation (Inline=true);
  end dDewEnthalpy_dPressure;

  redeclare function extends setState_psX
    "Return thermodynamic state of water as function of p, s, and optional region"
    input Integer region=Region
      "If 0, region is unknown, otherwise known and this input";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps pro;
  algorithm
    pro :=ThermoSysPro.Properties.WaterSteam.IF97.Water_Ps(
      p,
      s,
      region);
    state := ThermodynamicState(
          d=pro.d,
          T=pro.T,
          phase=if region == 0 then 0 else if region==4 then 2 else 1,
          h=pro.h,
          p=p);
    annotation (Inline=true);
  end setState_psX;

  redeclare function extends setState_pTX
    "Return thermodynamic state of water as function of p, T, and optional region"
    input Integer region=Region
      "If 0, region is unknown, otherwise known and this input";
  protected
    ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_pT pro;
  algorithm
    pro :=ThermoSysPro.Properties.WaterSteam.IF97.Water_PT(
      p,
      T,
      region);
    state := ThermodynamicState(
          d=pro.d,
          T=T,
          phase=1,
          h=pro.h,
          p=p);
    annotation (Inline=true);
  end setState_pTX;

  redeclare function extends setSmoothState
    "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
    import Modelica.Media.Common.smoothStep;
  algorithm
    state := ThermodynamicState(
          p=smoothStep(
            x,
            state_a.p,
            state_b.p,
            x_small),
          h=smoothStep(
            x,
            state_a.h,
            state_b.h,
            x_small),
          d=density_ph(smoothStep(
            x,
            state_a.p,
            state_b.p,
            x_small), smoothStep(
            x,
            state_a.h,
            state_b.h,
            x_small)),
          T=temperature_ph(smoothStep(
            x,
            state_a.p,
            state_b.p,
            x_small), smoothStep(
            x,
            state_a.h,
            state_b.h,
            x_small)),
          phase=0);
    annotation (Inline=true);
  end setSmoothState;

  redeclare function extends setState_dTX
    "Return thermodynamic state of water as function of d, T, and optional region"
    //     input Integer region=Region
    //       "If 0, region is unknown, otherwise known and this input";
    //   algorithm
    //     state := ThermodynamicState(
    //           d=d,
    //           T=T,
    //           phase=if region == 0 then 0 else if
    //         region == 4 then 2 else 1,
    //           h=specificEnthalpy_dT(
    //             d,
    //             T,
    //             region=region),
    //           p=pressure_dT(
    //             d,
    //             T,
    //             region=region));
    //     annotation (Inline=true);
  end setState_dTX;

  redeclare function extends specificEnthalpy_dT
    "Computes specific enthalpy as a function of density and temperature"
    //     extends Modelica.Icons.Function;
    //     input Density d "Density";
    //     input Temperature T "Temperature";
    //     input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    //     input Integer region=Region
    //       "If 0, region is unknown, otherwise known and this input";
    //     output SpecificEnthalpy h "Specific enthalpy";
    //   algorithm
    //     h := Modelica.Media.Water.IF97_Utilities.h_dT(
    //         d,
    //         T,
    //         phase,
    //         region);
    //     annotation (Inline=true);

  end specificEnthalpy_dT;

  redeclare function extends pressure_dT
  "Computes pressure as a function of density and temperature"
    //   extends Modelica.Icons.Function;
    //   input Density d "Density";
    //   input Temperature T "Temperature";
    //   input FixedPhase phase=0 "2 for two-phase, 1 for one-phase, 0 if not known";
    //   input Integer region=Region
    //     "If 0, region is unknown, otherwise known and this input";
    //   output AbsolutePressure p "Pressure";
    // algorithm
    //   p := Modelica.Media.Water.IF97_Utilities.p_dT(
    //       d,
    //       T,
    //       phase,
    //       region);
    //   annotation (Inline=true);

  end pressure_dT;

  redeclare function extends isentropicExponent "Return isentropic exponent"
  // algorithm
  //   gamma := if dT_explicit then Modelica.Media.Water.IF97_Utilities.isentropicExponent_dT(
  //       state.d,
  //       state.T,
  //       state.phase,
  //       Region) else if pT_explicit then Modelica.Media.Water.IF97_Utilities.isentropicExponent_pT(
  //       state.p,
  //       state.T,
  //       Region) else Modelica.Media.Water.IF97_Utilities.isentropicExponent_ph(
  //       state.p,
  //       state.h,
  //       state.phase,
  //       Region);
  //   annotation (Inline=true);
  end isentropicExponent;

  redeclare function extends isothermalCompressibility
    "Isothermal compressibility of water"
  // algorithm
  //   //    assert(state.phase <> 2, "Isothermal compressibility can not be computed with 2-phase inputs!");
  //   kappa := if dT_explicit then Modelica.Media.Water.IF97_Utilities.kappa_dT(
  //       state.d,
  //       state.T,
  //       state.phase,
  //       Region) else if pT_explicit then Modelica.Media.Water.IF97_Utilities.kappa_pT(
  //       state.p,
  //       state.T,
  //       Region) else Modelica.Media.Water.IF97_Utilities.kappa_ph(
  //       state.p,
  //       state.h,
  //       state.phase,
  //       Region);
  //   annotation (Inline=true);
  end isothermalCompressibility;

  redeclare function extends isobaricExpansionCoefficient
    "Isobaric expansion coefficient of water"
  // algorithm
  //   //    assert(state.phase <> 2, "The isobaric expansion coefficient can not be computed with 2-phase inputs!");
  //   beta := if dT_explicit then Modelica.Media.Water.IF97_Utilities.beta_dT(
  //       state.d,
  //       state.T,
  //       state.phase,
  //       Region) else if pT_explicit then Modelica.Media.Water.IF97_Utilities.beta_pT(
  //       state.p,
  //       state.T,
  //       Region) else Modelica.Media.Water.IF97_Utilities.beta_ph(
  //       state.p,
  //       state.h,
  //       state.phase,
  //       Region);
  //   annotation (Inline=true);
  end isobaricExpansionCoefficient;
end WaterSteam;
