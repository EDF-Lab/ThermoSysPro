within ThermoSysPro.NuclearCore.Modules;
model ReactivityFeedbacks "This module calculates the neutronic feedback due to control rods, Doppler effect, moderator temperature, 
  boron and xenon concentration"

  parameter Boolean steady_state = true annotation(Dialog(group="Reference State"),choices(checkBox=true));

  parameter ThermoSysPro.Units.SI.Temperature Tref_mod = 585.45 "Moderator Reference Temperature" annotation(Dialog(group="Reference State"));
  parameter Integer Np =1  "Number of poisons" annotation(Dialog(group="Reactivity Contributions"));
  parameter Real kp[Np] "Poisons Coefficient" annotation(Dialog(group="Reactivity Contributions"));
  parameter Real kB = -10 "Soluble Poison (Boron) Coefficient (pcm/ppm)" annotation(Dialog(group="Reactivity Contributions"));
  parameter ThermoSysPro.Units.SI.Temperature Tref_fuel(start=973.15, fixed=false)
    "fuel effective reference temperature (K)" annotation(Dialog(group="Reference State"));

  parameter Integer n_rods = 2 "Number of Control Rods" annotation(Dialog(group="Control Rods Parameters"));
  parameter Real rod_stroke[n_rods] = {100,100} "Rod Stroke in the core (in steps, cm...)" annotation(Dialog(group="Control Rods Parameters"));

  parameter Real RodsPos0[n_rods]={10,0} "Control rods initial position (0 -> completely extracted from the core)" annotation(Dialog(group="Control Rods Parameters"));

  parameter Boolean continuosInsertion = true "Whether to use constant rod worths or tables" annotation(Dialog(group="Control Rods Parameters"),choices(checkBox=true));

  parameter Integer rodWorthModel = 0 "0: constant worth, 1: S-shape, 2: table" annotation(Dialog(group="Control Rods Parameters"),choices(checkBox=true));

  parameter Integer rod_nodes = 10 "Number of sections in the rod worth tables" annotation(Dialog(group="Control Rods Parameters",enable=rodWorthModel==2));

  parameter Real Z_rodNodes[n_rods,rod_nodes + 3]={{i*rod_stroke[j]/rod_nodes for i in -1:rod_nodes + 1} for j in 1:n_rods} "Z of rodworth sections" annotation (Dialog(group="Control Rods Parameters", enable=rodWorthModel==2));

  parameter Real rodWorth_tab[n_rods, rod_nodes+3] = zeros(n_rods, rod_nodes+3) "Rod Worth of as a function of Z (see Z_rodNodes)" annotation(Dialog(enable=rodWorthModel==2,group="Control Rods Parameters"));

  parameter Real cumRodWorth[n_rods, rod_nodes+3] = {ThermoSysPro.Functions.CumulativeIntegral(rod_nodes+3, Z_rodNodes[i], rodWorth_tab[i]) for i in 1:n_rods} "Cumulative rod worth" annotation(Dialog(enable=false,group="Control Rods Parameters"));

  parameter Real ReacFuel0(start=1000,fixed=false) "Reference Reactivity of Fuel" annotation(Dialog(group="Reference State"));

  Real RodsPos[n_rods] "Position of groups (steps)";
  Real RodsSpeedsValue[n_rods] "Velocity of rods groups (insertion in step/min)";
  Real k[n_rods]  "Integer position of groups (steps)";
  Real T_fuel "Fuel effective temperature (K)";
  Real T_CoreAv "Average temperature of the moderator in the core (K)";
  Real Cbore "Concentration of the boron";
  Real Cpois[Np] "Concentration of the xénon";

  Real Reac "Total reactivity (pcm)";

  Real ReacSP "Reactivity given by soluble poison, i.e. Boron (pcm)";
  Real ReacB "Reactivity given by the control bars (pcm)";
   Real ReacBi[n_rods] "Reactivity given by the control bars (pcm)";
 Real ReacD "Reactivity given by the Doppler effect (fuel temperature) (pcm)";
 Real ReacM "Reactivity given by the moderator effect (pcm)";
  Real ReacP "Reactivity given by the poisons (pcm)";
  Real ReacPi[Np] "Reactivity given by the poisons (pcm)";
  Real ReacFuel;


  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal SortieReac
    annotation (extent=[100, 70; 120, 90], Placement(transformation(extent={{134,-10},
            {154,10}},         rotation=0), iconTransformation(extent={{134,-10},
            {154,10}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal EntreeCbore
    annotation (extent=[-120, -70; -100, -50], Placement(transformation(extent={{-152,50},
            {-132,70}},              rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal EntreeT_CoreAv
    annotation (extent=[-120, -30; -100, -10], Placement(transformation(extent={{-152,82},
            {-132,102}},             rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal EntreeT_fuel
    annotation (extent=[-120, 10; -100, 30], Placement(transformation(extent={{-152,
            110},{-132,130}},    rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal RodsSpeeds[n_rods]
    annotation (extent=[-120,90; -100,110], Placement(transformation(extent={{-152,
            140},{-132,160}},
                            rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal EntreeCpois[Np]
    annotation (extent=[-120,-110; -100,-90], Placement(transformation(extent={{-152,20},
            {-132,40}},            rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal alfa_mod
    annotation (extent=[-120,-110; -100,-90], Placement(transformation(extent={{-152,
            -12},{-132,8}},        rotation=0), iconTransformation(extent={{-152,
            -12},{-132,8}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal alfa_dop
    annotation (extent=[-120,-110; -100,-90], Placement(transformation(extent={{-152,
            -38},{-132,-20}},       rotation=0), iconTransformation(extent={{-152,
            -38},{-132,-20}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal ReacGd
    annotation (extent=[-120,-110; -100,-90], Placement(transformation(extent={{-152,
            -68},{-132,-50}},        rotation=0), iconTransformation(extent={{-152,
            -70},{-132,-52}})));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal rodWorth[n_rods] annotation (extent=[-120,-110; -100,-90], Placement(
        transformation(extent={{-152,-100},{-132,-82}},  rotation=0),
        iconTransformation(extent={{-152,-102},{-132,-84}})));
  InstrumentationAndControl.Connectors.InputReal deltaReacFuel annotation (
      extent=[-120,-110; -100,-90], Placement(transformation(extent={{-152,-128},
            {-132,-110}}, rotation=0), iconTransformation(extent={{-152,-138},{-132,
            -120}})));

 protected
  constant Real pi = Modelica.Constants.pi "pi";


initial equation
  RodsPos = RodsPos0;

  Tref_fuel=T_fuel;

 if steady_state then
    Reac=0;
 end if;

equation
  Reac = SortieReac.signal;
  for i in 1:n_rods loop
    der(RodsPos[i]) =if ((RodsPos[i] >= rod_stroke[i]) and (RodsSpeedsValue[i] > 0))
       then 0 else RodsSpeedsValue[i]/60;
  end for;
  RodsSpeedsValue = RodsSpeeds.signal;
  T_fuel = EntreeT_fuel.signal;
  T_CoreAv = EntreeT_CoreAv.signal;
  Cbore = EntreeCbore.signal;
  Cpois =EntreeCpois.signal;

  /* Total reactivity given by the control bars */
  ReacB = sum(ReacBi);

  for i in 1:n_rods loop
    if continuosInsertion then
      k[i] =min(rod_stroke[i], max(RodsPos[i], 0));
    else
      k[i] =min(rod_stroke[i], integer(max(floor(RodsPos[i] + 0.5), 0)));
    end if;

    if rodWorthModel==0 then
      ReacBi[i] = k[i]*rodWorth[i].signal;
    elseif rodWorthModel==1 then
      ReacBi[i] = rodWorth[i].signal*(k[i]/rod_stroke[i]-1/2/pi*sin(2*pi*k[i]/rod_stroke[i]));
    elseif rodWorthModel==2 then
      ReacBi[i] =  ThermoSysPro.Functions.LinearInterpolation(Z_rodNodes[i], cumRodWorth[i], RodsPos[i]);
    else
      assert(false,"Unsupported rodWorthModel = " + String(rodWorthModel) +". Supported values are 0, 1 and 2.");
    end if;
  end for;


  /* Reactivity given by the soluble poison (boron) */
  ReacSP = kB * Cbore;

  /* Reactivity given by the Doppler effect */
  ReacD = alfa_dop.signal*(T_fuel-Tref_fuel);

  /* Reactivity given by the moderator effect */
  ReacM = alfa_mod.signal*(T_CoreAv-Tref_mod);

  /* Reactivity given by the Xenon*/
  ReacP = sum(ReacPi);
  ReacPi =kp.*Cpois;

  ReacFuel = ReacFuel0+ deltaReacFuel.signal;

  /* Total reactivity*/
  Reac = ReacFuel + ReacB + ReacD + ReacM + ReacP + ReacSP + ReacGd.signal;

  annotation (Icon(
      coordinateSystem(extent={{-140,-160},{140,160}}),
      graphics={
        Text(
          extent={{-172,66},{-172,54}},
          textColor={0,0,255},
          textString=
               "Cbore"),
        Text(
          extent={{-182,96},{-182,84}},
          textColor={0,0,255},
          textString=
               "T_CoreAv"),
        Text(
          extent={{-176,128},{-176,116}},
          textColor={0,0,255},
          textString=
               "T_fuel"),
        Text(
          extent={{-184,156},{-184,144}},
          textColor={0,0,255},
          textString="RodSpeed"),
        Text(
          extent={{124,18},{124,6}},
          textColor={0,0,255},
          textString=
               "Reac"),
        Ellipse(
          extent={{-140,-42},{140,-160}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,128,0}),
        Ellipse(
          extent={{-140,160},{140,42}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,128,0}),
        Rectangle(
          extent={{-140,102},{140,-106}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,128,0}),
        Text(
          extent={{-84,100},{80,-100}},
          textColor={0,0,255},
          textString=
               "%name"),
        Text(
          extent={{-174,36},{-174,24}},
          textColor={0,0,255},
          textString="Cpois"),
        Text(
          extent={{-176,4},{-176,-8}},
          textColor={0,0,255},
          textString="alfa_mod"),
        Text(
          extent={{-174,-24},{-174,-36}},
          textColor={0,0,255},
          textString="alfa_dop"),
        Text(
          extent={{-174,-54},{-174,-66}},
          textColor={0,0,255},
          textString="ReacGd"),
        Text(
          extent={{-178,-86},{-178,-98}},
          textColor={0,0,255},
          textString="RodWorth"),
        Text(
          extent={{-186,-124},{-186,-136}},
          textColor={0,0,255},
          textString="deltaReacFuel")},
      Text(
        extent=[-136, -78; -136, -90],
        style(color=3, rgbcolor={0,0,255}),
        string="Cxenon"),
      Text(
        extent=[-136, -38; -136, -50],
        style(color=3, rgbcolor={0,0,255}),
        string="Cbore"),
      Text(
        extent=[-136, 2; -136, -10],
        style(color=3, rgbcolor={0,0,255}),
        string="T_CoreAv"),
      Text(
        extent=[-136, 42; -136, 30],
        style(color=3, rgbcolor={0,0,255}),
        string="T_fuel"),
      Text(
        extent=[-136, 82; -136, 70],
        style(color=3, rgbcolor={0,0,255}),
        string="PosG"),
      Text(
        extent=[136, 102; 136, 90],
        style(color=3, rgbcolor={0,0,255}),
        string="Reac"),
      Text(
        extent=[136, -60; 136, -72],
        style(color=3, rgbcolor={0,0,255}),
        string="ReacX"),
      Text(
        extent=[136, -20; 136, -32],
        style(color=3, rgbcolor={0,0,255}),
        string="ReacM"),
      Text(
        extent=[136, 20; 136, 8],
        style(color=3, rgbcolor={0,0,255}),
        string="ReacD"),
      Text(
        extent=[136, 60; 136, 48],
        style(color=3, rgbcolor={0,0,255}),
        string="ReacB"),
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
        extent=[-82, 102; 82, -98],
        style(color=3, rgbcolor={0,0,255}),
        string="%name")), Diagram(
      coordinateSystem(extent={{-140,-160},{140,160}}),
      graphics={
        Ellipse(
          extent={{-140,160},{140,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,128,0}),
        Ellipse(
          extent={{-140,-10},{140,-160}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,128,0}),
        Rectangle(
          extent={{-140,80},{140,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,128,0}),
        Text(
          extent={{-72,92},{86,-108}},
          textColor={0,0,255},
          textString="Reactivity Feedback"),
        Text(
          extent={{-190,156},{-190,144}},
          textColor={0,0,255},
          textString="RodsSpeeds"),
        Text(
          extent={{-176,128},{-176,116}},
          textColor={0,0,255},
          textString=
               "T_fuel"),
        Text(
          extent={{-180,96},{-180,84}},
          textColor={0,0,255},
          textString=
               "T_CoreAv"),
        Text(
          extent={{-172,64},{-172,52}},
          textColor={0,0,255},
          textString=
               "Cbore"),
        Text(
          extent={{-174,34},{-174,22}},
          textColor={0,0,255},
          textString="Cpois"),
        Text(
          extent={{160,22},{160,10}},
          textColor={0,0,255},
          textString=
               "Reac"),
        Text(
          extent={{-174,-24},{-174,-36}},
          textColor={0,0,255},
          textString="alfa_dop"),
        Text(
          extent={{-176,4},{-176,-8}},
          textColor={0,0,255},
          textString="alfa_mod"),
        Text(
          extent={{-176,-52},{-176,-64}},
          textColor={0,0,255},
          textString="ReacGd"),
        Text(
          extent={{-180,-86},{-180,-98}},
          textColor={0,0,255},
          textString="RodWorth"),
        Text(
          extent={{-190,-114},{-190,-126}},
          textColor={0,0,255},
          textString="deltaReacFuel")},
      Ellipse(extent=[-100, 102; 100, -18], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=3,
          fillColor=45,
          rgbfillColor={255,128,0})),
      Ellipse(extent=[-100, 22; 100, -98], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=3,
          fillColor=45,
          rgbfillColor={255,128,0})),
      Rectangle(extent=[-100, 42; 100, -40], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=45,
          rgbfillColor={255,128,0})),
      Text(
        extent=[-76, 104; 82, -96],
        style(color=3, rgbcolor={0,0,255}),
        string="AntiReac"),
      Text(
        extent=[-112, 124; -112, 112],
        style(color=3, rgbcolor={0,0,255}),
        string="PosR"),
      Text(
        extent=[-114, 84; -114, 72],
        style(color=3, rgbcolor={0,0,255}),
        string="PosG"),
      Text(
        extent=[-116, 44; -116, 32],
        style(color=3, rgbcolor={0,0,255}),
        string="T_fuel"),
      Text(
        extent=[-114, 4; -114, -8],
        style(color=3, rgbcolor={0,0,255}),
        string="T_CoreAv"),
      Text(
        extent=[-114, -36; -114, -48],
        style(color=3, rgbcolor={0,0,255}),
        string="Cbore"),
      Text(
        extent=[-114, -76; -114, -88],
        style(color=3, rgbcolor={0,0,255}),
        string="Cxenon"),
      Text(
        extent=[116, 104; 116, 92],
        style(color=3, rgbcolor={0,0,255}),
        string="Reac"),
      Text(
        extent=[116, -58; 116, -70],
        style(color=3, rgbcolor={0,0,255}),
        string="ReacX"),
      Text(
        extent=[116, -18; 116, -30],
        style(color=3, rgbcolor={0,0,255}),
        string="ReacM"),
      Text(
        extent=[116, 22; 116, 10],
        style(color=3, rgbcolor={0,0,255}),
        string="ReacD"),
      Text(
        extent=[116, 62; 116, 50],
        style(color=3, rgbcolor={0,0,255}),
        string="ReacB")),
    Documentation(info="# Reactivity feedbacks

The *ReactivityFeedbacks* model calculates the total reactivity by combining the principal neutronic feedback mechanisms. The model accounts for:
- Control rod reactivity
- Fuel temperature (Doppler) feedback 
- Moderator temperature feedback
- Soluble boron concentration
- Neutronic poisons from fission products feedback
- Burnable absorber (e.g., gadolinium) reactivity contribution

The total reactivity is expressed in pcm and is obtained as the sum of the individual contributions. 
The model supports multiple poison species (\\\\(N_p \\\\)) and multiple control rod banks (\\\\(n_{rods} \\\\)) . 
Control rod worth can be represented either by a constant differential worth or by user-defined rod-worth tables.


## Nomenclature

| Symbol              | Description                     | Unit                                    | Definition                                                     | Modelica name       |
|:------:|-------------|:----:|------------|--------------|
| \\\\(N_p\\\\)             | Number of poison species        | -                                       | Number of neutron poisons considered                           | `Np`                |
| \\\\(k_{p,i}\\\\)         | Poison coefficient              | \\\\(\\mathrm{pcm/nuclides}\\\\) | Converts poison concentration into reactivity                  | `kp[i]`             |
| \\\\(k_B\\\\)             | Boron coefficient               | \\\\(\\mathrm{pcm/ppm}\\\\)                    | Soluble boron reactivity coefficient                           | `kB`                |
| \\\\(T_{ref,f}\\\\)       | Reference fuel temperature      | \\\\(\\mathrm{K}\\\\)                       | Fuel temperature corresponding to zero Doppler feedback        | `Tref_fuel`         |
| \\\\(T_{ref,m}\\\\)       | Reference moderator temperature | \\\\(\\mathrm{K}\\\\)                         | Moderator temperature corresponding to zero moderator feedback | `Tref_mod`          |
| \\\\(n_{rods}\\\\)             | Number of control rod groups    | -                                       | Number of independently controlled rod banks                   | `n_rods`            |
| \\\\(S_i\\\\)             | Rod stroke                      | variable                                | Maximum insertion depth of rod group \\\\(i\\\\)                      | `rod_stroke[i]`     |
| \\\\(Z_{0,i}\\\\)         | Initial rod position            | variable                                | Initial position of rod group \\\\(i\\\\)                           | `RodsPos0[i]`       |
| \\\\(W_i\\\\)            | Differential rod worth          | \\\\(\\mathrm{pcm}\\\\) per position unit      | Constant rod worth coefficient                                 | `rodWorth[i]`       |
| \\\\(Z_{node,i,j}\\\\)    | Rod-worth table coordinate      | position unit                           | Position associated with rod-worth table node                  | `Z_rodNodes[i,j]`   |
| \\\\(RW_{i,j}\\\\)       | Differential rod worth table    | \\\\(\\mathrm{pcm}\\\\) per position unit      | Differential rod worth versus insertion depth                  | `rodWorth_tab[i,j]` |
| \\\\(CRW_{i,j}\\\\)       | Cumulative rod worth table      | \\\\(\\mathrm{pcm}\\\\)                        | Integrated rod worth table                                     | `cumRodWorth[i,j]`  |
| \\\\(\\rho_{fuel,ref}\\\\) | Reference fuel reactivity       | \\\\(\\mathrm{pcm}\\\\)                        | Base reactivity offset                                         | `ReacFuel`          |
| \\\\(T_f\\\\)       | Fuel temperature             | \\\\(\\mathrm{K}\\\\)    | Effective fuel temperature                        | `EntreeT_fuel.signal`   |
| \\\\(T_m\\\\)       | Moderator temperature        | \\\\(\\mathrm{K}\\\\)    | Core-average moderator temperature                | `EntreeT_CoreAv.signal` |
| \\\\(C_B\\\\)       | Boron concentration          | \\\\(\\mathrm{ppm}\\\\)   | Soluble boron concentration                       | `EntreeCbore.signal`    |
| \\\\(C_{p,i}\\\\)   | Poison concentration         | nuclides | Poison concentration of species \\\\(i\\\\)             | `EntreeCpois.signal[i]` |
| \\\\(\\alpha_m\\\\)  | Moderator coefficient        | \\\\(\\mathrm{pcm/K}\\\\) | Moderator temperature coefficient                 | `alfa_mod.signal`       |
| \\\\(\\alpha_D\\\\)  | Doppler coefficient          | \\\\(\\mathrm{pcm/K}\\\\) | Fuel Doppler coefficient                          | `alfa_dop.signal`       |
| \\\\(\\rho_{Gd}\\\\) | Burnable absorber reactivity | \\\\(\\mathrm{pcm}\\\\)   | Reactivity contribution from gadolinium depletion | `ReacGd.signal`         |
| \\\\(V_i\\\\)       | Rod insertion velocity       | position unit/min  | Control rod motion speed                          | `RodsSpeeds.signal[i]`  |
| \\\\(Z_i\\\\)       | Rod position                   | position unit    | Current insertion depth of rod group \\\\(i\\\\) | `RodsPos[i]`  |
| \\\\(k_i\\\\)       | Effective rod position         | position unit    | Position used in rod-worth calculations    | `k[i]`        |
| \\\\(\\rho_B\\\\)     | Rod-bank reactivity            | \\\\(\\mathrm{pcm}\\\\) | Total control-rod contribution             | `ReacB`       |
| \\\\(\\rho_{B,i}\\\\) | Rod-bank contribution          | \\\\(\\mathrm{pcm}\\\\) | Contribution of rod group \\\\(i\\\\)            | `ReacBi[i]`   |
| \\\\(\\rho_{SP}\\\\)  | Soluble poison reactivity      | \\\\(\\mathrm{pcm}\\\\) | Boron reactivity contribution              | `ReacSP`      |
| \\\\(\\rho_D\\\\)     | Doppler reactivity             | \\\\(\\mathrm{pcm}\\\\) | Fuel temperature effect                    | `ReacD`       |
| \\\\(\\rho_M\\\\)     | Moderator reactivity           | \\\\(\\mathrm{pcm}\\\\) | Moderator temperature effect               | `ReacM`       |
| \\\\(\\rho_P\\\\)     | Poison reactivity              | \\\\(\\mathrm{pcm}\\\\) | Total poison contribution                  | `ReacP`       |
| \\\\(\\rho_{P,i}\\\\) | Individual poison contribution | \\\\(\\mathrm{pcm}\\\\) | Contribution of poison species \\\\(i\\\\)       | `ReacPi[i]`   |
| \\\\(\\rho\\\\)       | Total reactivity               | \\\\(\\mathrm{pcm}\\\\) | Sum of all reactivity contributions        | `Reac`        |


## Governing equations

### Control rod insertion
The user can specify via an external input the control rod insertion speed \\\\( V_i \\\\). This can be used to compute the effective control rod position \\\\( k_i \\\\), which is constrained by the 
stroke of the control rod group. Morever, via the dedicated flag `continuousInsertion`, it can be specified whether continuos or integer insertion steps should be considered.

Two different models can be selected to compute the control rod insertion. Activating the `constant_rodWorth` option, the rod worth \\\\( W_i \\\\) is specified externally, e.g., to capture the burnup dependency.
In contrast, a variable rod worth (dependending on the axial position) can be defined when `constant_rodWorth = false`.

### Temperature feedbacks
The reactivity insertion related to temperature feedbacks is computed in the form of

$$  \\rho = \\alpha (T - T_{ref}) $$

where \\\\( \\alpha \\\\) are the feedback coefficients, specified externally to account for the burnup effect. For the Doppler effect, the temperature refers to the effective fuel temperature computed
with [Rowland's model](modelica://ThermoSysPro.NuclearCore.Modules.FuelThermalPower), whereas the moderator feedback is calculated considering the average coolant temperature.

### Neutron poisons

The contribution of three different kinds of neutron poisons is considered in the model, arising namely from fission products (e.g., xenon, samarium) and from the external injection of 
soluble poisons (e.g., boron). The reactivity contributions are assumed to be proportional to the concentration of the species:

$$  \\rho = k_P C_P $$

Lastly, the user can specify the reactivity contributions of burnable poisons in the fuel (e.g., gadolinium).


### Total reactivity

Overall, in critical conditions the fuel reactivity needs to compensate the reactivity contributions of tha aforementioned effects. The total reactivity is obtained by summing all contributions:

$$  \\rho = \\rho_{fuel,ref} + \\sum_{i=1}^{n_{rods}} \\rho_{B,i} + \\rho_D + \\rho_M + \\sum_{i=1}^{N_p} \\rho_{P,i}+ \\rho_{SP} + \\rho_{Gd}  $$



## Copyright © EDF 2002 - 2026  


## ThermoSysPro Version 4.2  "));
end ReactivityFeedbacks;
