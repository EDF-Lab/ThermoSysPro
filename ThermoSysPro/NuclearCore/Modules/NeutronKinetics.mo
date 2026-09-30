within ThermoSysPro.NuclearCore.Modules;
model NeutronKinetics "Neutronic power evolution by neutron kinetics"

  parameter Real Kfuel=1
    "Ratio between the power produced in the fuel and the total power";

  parameter Real Ptot0=524e6 "Initial power of the core";
  parameter ThermoSysPro.Units.SI.Energy FissionEnergy = 3.2e-11 "Energy from each fission";
  parameter Real NeutronsPerFission = 2.43 "Average number of neutrons per thermal fission";

protected
  Real SumBeta=sum(Beta.signal);

public
  ThermoSysPro.Units.SI.Power Pneut(start=Ptot0) "Neutronic power (W)";
  ThermoSysPro.Units.SI.Power Pndelay[6](start=fill(Ptot0*1e-3,6))
    "Power given by the 6 groups of delayed neutrons (W)";
  ThermoSysPro.Units.SI.Power Ptot "Total power of the reactor (W)";
  ThermoSysPro.Units.SI.Power Pfuel "Power produced in the fuel (W)";
  ThermoSysPro.Units.SI.Power Ph2o "Power directly received by the moderator (W)";
  Real Reac "Total reactivity (pcm)";
  ThermoSysPro.Units.SI.Power Pres "Residual power (W)";

  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal Reactivity
    annotation (extent=[-120, 30; -100, 50], Placement(transformation(extent={{-114,70},
            {-94,90}},           rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal DecayHeat
    annotation (extent=[-120,-50; -100,-30], Placement(transformation(extent={{-116,0},
            {-96,20}},             rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal Pneutrons
    annotation (extent=[100,40; 120,60], Placement(transformation(extent={{100,
            40},{120,60}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal TotalPower
    annotation (extent=[100, 6; 120, 26], Placement(transformation(extent={{100,
            6},{120,26}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal PowerInFuel
    annotation (extent=[100,-26; 120,-6], Placement(transformation(extent={{100,
            -26},{120,-6}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal PowerOutFuel
    annotation (extent=[100,-60; 120,-40], Placement(transformation(extent={{100,
            -60},{120,-40}}, rotation=0)));

  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal S annotation (
      extent=[-120,30; -100,50], Placement(transformation(extent={{-114,36},{-94,
            56}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal Lambda[6]
    annotation (extent=[-120,-50; -100,-30], Placement(transformation(extent={{-116,
            -32},{-96,-12}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal Beta[6]
    annotation (extent=[-120,-50; -100,-30], Placement(transformation(extent={{-116,
            -66},{-96,-46}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal Tlife annotation
    (extent=[-120,-50; -100,-30], Placement(transformation(extent={{-116,-98},{-96,
            -78}}, rotation=0)));
initial equation

  Ptot = Ptot0; //Start from a predefined level of power

  for i in 1:6 loop
    der(Pndelay[i]) = 0; //Initialize at equilibrium
  end for;

equation
  Reac =Reactivity.signal;
  Pres =DecayHeat.signal;
  Pneut =Pneutrons.signal;
  Ptot =TotalPower.signal;
  Pfuel =PowerInFuel.signal;
  Ph2o =PowerOutFuel.signal;

  Ptot - (Pneut + Pres) = 0;
  Pfuel - Kfuel*Ptot = 0;
  Ph2o - (1 - Kfuel)*Ptot = 0;

  // Point reactor kinetics equations

    der(Pneut) = (Reac*1e-5 - SumBeta)*Pneut/Tlife.signal + sum(Lambda.signal .* Pndelay) + S.signal*FissionEnergy/Tlife.signal/NeutronsPerFission;

  for i in 1:6 loop
    der(Pndelay[i]) = Beta[i].signal*Pneut/Tlife.signal - Lambda[i].signal*Pndelay[i];

  end for;

  annotation (Icon(
      graphics={
        Ellipse(
          extent={{-100,100},{100,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,128,0}),
        Ellipse(
          extent={{-100,20},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,128,0}),
        Rectangle(
          extent={{-100,40},{100,-42}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,128,0}),
        Text(
          extent={{-78,92},{78,-84}},
          textColor={0,0,0},
          textString=
               "%name"),
        Text(
          extent={{-130,86},{-130,74}},
          textColor={0,0,0},
          textString=
               "Reac"),
        Text(
          extent={{-134,16},{-134,4}},
          textColor={0,0,0},
          textString=
               "Pres"),
        Text(
          extent={{140,38},{140,26}},
          textColor={0,0,0},
          textString=
               "Ptot"),
        Text(
          extent={{142,74},{142,62}},
          textColor={0,0,0},
          textString=
               "Pneut"),
        Text(
          extent={{142,6},{142,-6}},
          textColor={0,0,0},
          textString=
               "Pfuel"),
        Text(
          extent={{142,-28},{142,-40}},
          textColor={0,0,0},
          textString=
               "Ph2o"),
        Text(
          extent={{-132,50},{-132,38}},
          textColor={0,0,0},
          textString="S"),
        Text(
          extent={{-138,-16},{-138,-28}},
          textColor={0,0,0},
          textString="Lambda"),
        Text(
          extent={{-138,-50},{-138,-62}},
          textColor={0,0,0},
          textString="Beta"),
        Text(
          extent={{-134,-82},{-134,-94}},
          textColor={0,0,0},
          textString="Tlife")},
      Ellipse(extent=[-100, 100; 100, -20], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=3,
          fillColor=45,
          rgbfillColor={255,128,0})),
      Ellipse(extent=[-100, 20; 100, -100], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=3,
          fillColor=45,
          rgbfillColor={255,128,0})),
      Rectangle(extent=[-100, 40; 100, -42], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0})),
      Text(
        extent=[-78, 92; 78, -84],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="%name"),
      Text(
        extent=[-130, 68; -130, 56],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Reac"),
      Text(
        extent=[-134, -14; -134, -26],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Pres"),
      Text(
        extent=[140, 38; 140, 26],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Ptot"),
      Text(
        extent=[142, 74; 142, 62],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Pneut"),
      Text(
        extent=[142, 6; 142, -6],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Pfuel"),
      Text(
        extent=[142, -28; 142, -40],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Ph2o")), Diagram(
      graphics={
        Ellipse(
          extent={{-100,104},{100,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,128,0}),
        Ellipse(
          extent={{-100,20},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,128,0}),
        Rectangle(
          extent={{-100,44},{100,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,128,0}),
        Text(
          extent={{-128,100},{-128,88}},
          textColor={0,0,0},
          textString=
               "Reac"),
        Text(
          extent={{-124,32},{-124,20}},
          textColor={0,0,0},
          textString=
               "Pres"),
        Text(
          extent={{-88,60},{92,-56}},
          textColor={0,0,255},
          textString="Neutron Kinetics"),
        Text(
          extent={{112,72},{112,60}},
          textColor={0,0,0},
          textString=
               "Pneut"),
        Text(
          extent={{110,36},{110,24}},
          textColor={0,0,0},
          textString=
               "Ptot"),
        Text(
          extent={{112,4},{112,-8}},
          textColor={0,0,0},
          textString=
               "Pfuel"),
        Text(
          extent={{112,-30},{112,-42}},
          textColor={0,0,0},
          textString=
               "Ph2o"),
        Text(
          extent={{-128,66},{-128,54}},
          textColor={0,0,0},
          textString="Source"),
        Text(
          extent={{-132,-2},{-132,-14}},
          textColor={0,0,0},
          textString="Lambda"),
        Text(
          extent={{-132,-34},{-132,-46}},
          textColor={0,0,0},
          textString="Beta"),
        Text(
          extent={{-128,-68},{-128,-80}},
          textColor={0,0,0},
          textString="Tlife")},
      Ellipse(extent=[-100, 100; 100, -20], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=3,
          fillColor=45,
          rgbfillColor={255,128,0})),
      Ellipse(extent=[-100, 20; 100, -100], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=3,
          fillColor=45,
          rgbfillColor={255,128,0})),
      Rectangle(extent=[-100, 40; 100, -42], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0})),
      Text(
        extent=[-110, 62; -110, 50],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Reac"),
      Text(
        extent=[-110, -18; -110, -30],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Pres"),
      Text(
        extent=[-88, 60; 92, -56],
        style(color=3, rgbcolor={0,0,255}),
        string="CinetiqueNeutronique"),
      Text(
        extent=[112, 72; 112, 60],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Pneut"),
      Text(
        extent=[110, 36; 110, 24],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Ptot"),
      Text(
        extent=[112, 4; 112, -8],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Pfuel"),
      Text(
        extent=[112, -30; 112, -42],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Ph2o")),
    Documentation(info="# Point Kinetics Model

This module contains a model of the neutronic power with six groups of delayed neutrons (it could be easily changed to 8 groups if needed). 
Starting from the total reactivity (model input from the *ReactivityFeedbacks* module), this module calculates the time evolution of the fission power of the reactor. 
The total power take into account also the residual power (which is computed and provided by the *DecayHeat* module).

The default values for \\\\(T_{life}\\\\) (prompt neutron lifetime), \\\\(\\beta\\\\) (delayed neutron fraction) and \\\\(\\lambda\\\\) (decay constant), valid for U235, are taken from *S. Marguet, La physique des réacteurs nucléaire, Ed. Lavoisier, 2013*.

The equations can also be derived from the same source, setting:
- \\\\(n(t)\\\\) proportional to \\\\(P_{neut}\\\\)
- \\\\(C_i(t)\\\\) proportional to \\\\(P_{delay,i}\\\\)

## Nomenclature
|     Symbol    | Description                 |        Unit        | Definition                                            | Modelica name        |
|:------:|-------------|:----:|------------|--------------|
|  \\\\(K_{fuel} \\\\) | Fuel power fraction         |          -         | Fraction of total reactor power deposited in the fuel | `Kfuel`              |
| \\\\(P_{tot,0} \\\\) | Initial reactor power       | \\\\( \\mathrm{W} \\\\) | Initial total reactor power                           | `Ptot0`              |
|   \\\\(E_f \\\\)    | Energy released per fission | \\\\( \\mathrm{J} \\\\) | Average recoverable energy per fission event          | `FissionEnergy`      |
|    \\\\(\\mathrm{\\nu} \\\\)    | Neutrons per fission        |          -         | Average number of neutrons produced per fission       | `NeutronsPerFission` |
|    \\\\(\\rho \\\\)  | Reactor reactivity                      |           pcm           | Total reactivity inserted into the core                             | `Reactivity.signal` |
|  \\\\(P_{res} \\\\)  | Decay heat power                        |    \\\\( \\mathrm{W} \\\\)   | Residual power provided by the decay heat model                     | `DecayHeat.signal`  |
|     \\\\(S \\\\)     | External neutron source                 |   neutrons \\\\( \\mathrm{s^{-1}} \\\\)   | External neutron source strength                                    | `S.signal`          |
| \\\\(\\lambda_i \\\\) | Decay constant of precursor group \\\\( i \\\\) | \\\\( \\mathrm{s^{-1}} \\\\) | Radioactive decay constant of delayed neutron precursor group  \\\\( i \\\\) | `Lambda[i].signal`  |
|  \\\\(\\beta_i \\\\)  | Delayed neutron fraction of group  \\\\( i \\\\)|            -            | Fraction of fission neutrons emitted by precursor group  \\\\( i \\\\)       | `Beta[i].signal`    |
|     \\\\(l \\\\)    | Prompt neutron lifetime                 |    \\\\( \\mathrm{s} \\\\)   | Mean lifetime of prompt neutrons                                    | `Tlife.signal`      |
| \\\\(P_{neut} \\\\) | Neutronic power                | \\\\( \\mathrm{W} \\\\) | Power generated directly by fission reactions                       | `Pneut`       |
| \\\\(P_{delay,i} \\\\) | Delayed-neutron group power    | \\\\( \\mathrm{W} \\\\) | Power-equivalent inventory of delayed neutron precursor group \\\\( i \\\\) | `Pndelay[i]`  |
|  \\\\(P_{tot} \\\\) | Total reactor power            | \\\\( \\mathrm{W} \\\\) | Sum of neutronic and decay heat power                               | `Ptot`        |
| \\\\(P_{fuel} \\\\) | Fuel power                     | \\\\( \\mathrm{W} \\\\) | Fraction of total power deposited in the fuel                       | `Pfuel`       |
| \\\\(P_{H_2O} \\\\) | Moderator power                | \\\\( \\mathrm{W} \\\\) | Fraction of total power deposited directly in the moderator         | `Ph2o`        |
|   \\\\(\\beta \\\\)  | Total delayed neutron fraction |          -         | Sum of the delayed neutron fractions                                | `SumBeta`     |



## Governing equations

The neutronic power balance is defined as follows:

$$ \\frac{dP_{neut}}{dt} =\\frac{\\rho - \\beta}{l} P_{neut} + \\sum_{i=1}^{6} \\lambda_i P_{delay,i} + S \\frac{E_f}{l \\nu} $$

For each precursor group \\\\(i\\\\), the contribution is governed by the following equation:


$$ \\frac{dP_{delay,i}}{dt} =\\frac{\\beta_i}{l} P_{neut} - \\lambda_i P_{delay,i} $$

The total core power is computed as the sum of the neutronic power \\\\(P_{neut}\\\\) and the residual power \\\\(P_{res}\\\\). 
By means of the parameter \\\\(K_{fuel}\\\\), it is possible to specify the fraction of power deposited in the fuel:

$$ P_{fuel} = K_{fuel} P_{tot} $$

with the remaining power deposited directly in the coolant.



"));
end NeutronKinetics;
