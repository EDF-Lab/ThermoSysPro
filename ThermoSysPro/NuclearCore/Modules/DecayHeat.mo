within ThermoSysPro.NuclearCore.Modules;
model DecayHeat "Calculation of the decay heat given by the decay of the fission
  products in the core of the nuclear reactor"

  parameter Real Kris[:]={0.0251,0.01654,0.02586}
    "Fraction of the power associated to group i";
  parameter Real Tris[:]={15,137,2910}
    "Time constant associated to group i (s)";
  parameter ThermoSysPro.Units.SI.Power Pres_start[:]={89.35e6,58.88e6,92.05e6}
    "Initial residual power (used if steqdy_state=false)";
  parameter Boolean steady_state=true "Initialize the decay heat at equilibrium" annotation(choices(checkBox=true));

protected
  parameter Integer N=size(Kris, 1) "Number of groups of radio-isotopes";

public
  ThermoSysPro.Units.SI.Power Pneut(start=3560e6) "Total neutronic power (W)";
  ThermoSysPro.Units.SI.Power PresTot "Total decay heat (W)";
  ThermoSysPro.Units.SI.Power Pres[N](start=Pres_start)
    "Residual power associated to the groups of radio-isotopes (W)";
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal Pneutrons
    annotation (extent=[-120,-10; -100,10], Placement(transformation(extent={{-120,
            -10},{-100,10}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal DecayHeat
    annotation (extent=[100,-10; 120,10], Placement(transformation(extent={{100,
            -10},{120,10}}, rotation=0)));
initial equation
  if steady_state then
    for i in 1:N loop
      der(Pres[i]) = 0;
    end for;
  else
    Pres = Pres_start;
  end if;
equation
  Pneut =Pneutrons.signal;
  PresTot =DecayHeat.signal;

  PresTot = sum(Pres);
  for i in 1:N loop
    der(Pres[i]) = (Kris[i]*Pneut - Pres[i])/Tris[i];
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
          extent={{-78,90},{78,-96}},
          textColor={0,0,0},
          textString=
               "%name"),
        Text(
          extent={{-132,28},{-132,16}},
          textColor={0,0,0},
          textString=
               "Pneut"),
        Text(
          extent={{130,26},{130,14}},
          textColor={0,0,0},
          textString=
               "Pres")},
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
        extent=[-78, 90; 78, -96],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="%name"),
      Text(
        extent=[-132, 28; -132, 16],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Pneut"),
      Text(
        extent=[130, 26; 130, 14],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Pres")), Diagram(
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
          extent={{-78,74},{78,-74}},
          textColor={0,0,0},
          textString="Decay Heat"),
        Text(
          extent={{116,24},{116,12}},
          textColor={0,0,0},
          textString=
               "Pres"),
        Text(
          extent={{-118,24},{-118,12}},
          textColor={0,0,0},
          textString=
               "Pneut")},
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
        extent=[-76, 74; 80, -74],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="PuissResiduelle"),
      Text(
        extent=[116, 24; 116, 12],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Pres"),
      Text(
        extent=[-118, 24; -118, 12],
        style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0}),
        string="Pneut")),
    Documentation(info="# Decay heat module

The *DecayHeat* module calculates the decay heat (or residual power) produced by radioactive decay of fission products the core.
The model represents the decay heat source using a set of (\\\\(N \\\\)) equivalent groups. Each group is characterized by:

- A fraction of the neutronic power associated with the group
- A characteristic decay time constant
- The corresponding residual power that evolves dynamically.

## Nomenclature

|      Symbol     | Description                                           |        Unit        | Definition                                              | Modelica name   |
|:------:|-------------|:----:|------------|--------------|
|     \\\\( K_i\\\\)     | Power fraction associated with decay heat group \\\\(i \\\\) |          -         | Fraction of power contributing to group \\\\(i \\\\) | `Kris[i]`       |
|     \\\\( T_i\\\\)    | Decay time constant of group \\\\(i \\\\)                    | \\\\( \\mathrm{s} \\\\) | Characteristic response time of decay heat group \\\\(i \\\\)  | `Tris[i]`       |
| \\\\( P_{res,i,0}\\\\) | Initial residual power of group \\\\(i \\\\)                 | \\\\( \\mathrm{W} \\\\) | Used when `steady_state = false`                        | `Pres_start[i]` |
|      \\\\( N\\\\)      | Number of decay heat groups                           |          -         | Number of equivalent radioactive isotope groups         | `size(Kris,1)`  |
|    \\\\( P_{neut}\\\\)   | Neutronic power               | \\\\( \\mathrm{W} \\\\) | Instantaneous power produced by fission             | `Pneut`            |
|   \\\\( P_{res,i}\\\\)   | Residual power of group \\\\(i \\\\) | \\\\( \\mathrm{W} \\\\) | Decay heat contribution associated with group \\\\(i \\\\)| `Pres[i]`          |
|    \\\\( P_{res}\\\\)    | Total decay heat              | \\\\( \\mathrm{W} \\\\) | Sum of all group contributions                      | `PresTot`          |
| \\\\( P_{neut}^{in}\\\\) | Neutronic power input         | \\\\( \\mathrm{W} \\\\) | Input signal containing reactor neutronic power     | `Pneutrons.signal` |
| \\\\( P_{res}^{out}\\\\) | Decay heat output             | \\\\( \\mathrm{W} \\\\) | Output signal containing total decay heat           | `DecayHeat.signal` |


## Governing equations
For each decay heat group \\\\(i \\\\), the residual power evolves according to the following differential equation:

$$ \\frac{dP_{res,i}}{dt} = \\frac{K_i P_{neut} -P_{res,i}}{T_i} $$

The total decay heat is obtained by summing the contributions of each group:

$$ P_{res} = \\sum_{i=1}^{N} P_{res,i} $$





## Copyright © EDF 2002 - 2026  


## ThermoSysPro Version 4.2  

    "));
end DecayHeat;
