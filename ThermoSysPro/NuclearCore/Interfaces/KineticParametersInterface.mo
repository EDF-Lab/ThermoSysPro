within ThermoSysPro.NuclearCore.Interfaces;
partial model KineticParametersInterface
  parameter Integer Nrods = 3;
  ThermoSysPro.NuclearCore.Interfaces.KineticParametersInput BUinput
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  InstrumentationAndControl.AdaptorForFMU.AdaptorModelicaTSP adaptorModelicaTSP[17 +
    Nrods] annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  InstrumentationAndControl.Connectors.OutputReal outputReal[17 + Nrods]
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
equation
  connect(adaptorModelicaTSP.outputReal,outputReal)
    annotation (Line(points={{67,0},{104,0}}, color={0,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-90,94},{98,-96}},
          textColor={28,108,200},
          textString="Kinetic
Parameters")}),                    Diagram(coordinateSystem(preserveAspectRatio
          =false), graphics={                   Text(
          extent={{4,4},{108,-132}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="1. alfa_mod
2. alfa_dop
3. RhoGd
4. Tlife
5-10. Lambda
11-16. Beta
17. deltaReacFuel
18-(18+Nrods). RodsWorth")}),
    Documentation(info="# Kinetic parameters

The `KineticParametersInterface` component provides the kinetic and reactivity coefficients required by the reactor core model. 
Its purpose is to supply the neutronic parameters used by the [NeutronKinetics](modelica://ThermoSysPro.NuclearCore.Modules.NeutronKinetics) and [ReactivityFeedbacks](modelica://ThermoSysPro.NuclearCore.Modules.ReactivityFeedbacks) modules without prescribing how these parameters should be calculated.
In particular, the following variables are computed:

|         Symbol        | Description                                               |                               Unit                              | 
| :-------------------: | --------------------------------------------------------- | :-------------------------------------------------------------: | 
| \\\\( \\alpha\\_{mod} \\\\) | Moderator temperature coefficient                         |                   \\\\( \\mathrm{pcm/K} \\\\)                   | 
| \\\\( \\alpha\\_{dop} \\\\) | Doppler coefficient                                       |                   \\\\( \\mathrm{pcm/K} \\\\)                   |
|   \\\\( \\rho\\_{Gd} \\\\)  | Burnable absorber reactivity                              |                       \\\\( \\mathrm{pcm} \\\\)                      |
|       \\\\( l \\\\)       | Prompt neutron lifetime                                   |                        \\\\( \\mathrm{s} \\\\)                       |
|   \\\\( \\lambda\\_i \\\\)  | Delayed neutron precursor decay constant of group \\\\(i\\\\) |                     \\\\( \\mathrm{s^{-1}} \\\\)                     | 
|    \\\\( \\beta\\_i \\\\)   | Delayed neutron fraction of group \\\\(i\\\\)                 |                                -                                | 
|   \\\\( W\\_{rod,i} \\\\)  | Control rod worth of rod group \\\\(i\\\\)                    | \\\\( \\mathrm{pcm}/\\mathrm{position} \\\\) |





The component is designed as a base class that can be extended by users to implement their own correlations, interpolations, tabulated data, or reduced-order models. 
An expandable connector is used to receive arbitrary input variables, allowing the kinetic parameters to depend on quantities such as burnup level, temperatures, power, etc.

By extending this model, users can implement plant-specific or reactor-specific formulations for evaluating kinetic parameters while preserving a common interface with the core model.



## Copyright © EDF 2002 - 2026  


## ThermoSysPro Version 4.2  

"));
end KineticParametersInterface;
