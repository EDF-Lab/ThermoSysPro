within ThermoSysPro.NuclearCore.Modules;
block FuelProperties "Nuclear Fuel Material Properties"
  input ThermoSysPro.Units.SI.Temperature T "Fuel Temperature";
  parameter Real porosity=0.05 "Fuel porosity";
  parameter Boolean MOX=false "Whether fuel is MOX or not";
  parameter Real pu_mFraction=0.085 "PuO2 Mass Fraction";
  parameter Real oxy_on_metal=2 "Oxyde on Metal Ratio";

  output ThermoSysPro.Units.SI.SpecificHeatCapacity cp "Fuel Specific Heat Capacity";
  output ThermoSysPro.Units.SI.ThermalConductivity k "Fuel Thermal Conductivity";

protected
  ThermoSysPro.Units.SI.SpecificHeatCapacity uo2_cp "Intermediary cp (UO2)";
  ThermoSysPro.Units.SI.SpecificHeatCapacity puo2_cp "Intermediary cp (PuO2)";
  Real T_C "Fuel Temperature in °C";
  Real p_coef "Porosity Coefficient";
equation

  T_C = T - 273.15;

  uo2_cp = 296.7*535.285^2*exp(535.285/T)/(T^2*(exp(535.285/T)-1)^2)+2.43e-2*T+oxy_on_metal/2*8.745e7*1.577e5/(8.3143*T^2)*exp(-1.577e5/(8.3143*T));

  //Matpro correlations
  if MOX then
    p_coef = 1.43;
    k = 100 * (max(33.0/(375+T_C),0.0171)+1.540e-4*exp(1.710e-3*T_C)) * (1-p_coef*porosity)/(1-p_coef*0.04)*(1-porosity)/0.96;
    puo2_cp = 347.4*571.000^2*exp(571.000/T)/(T^2*(exp(571.000/T)-1)^2)+3.95e-2*T+oxy_on_metal/2*3.86e7*1.967e5/(8.3143*T^2)*exp(-1.967e5/(8.3143*T));
    cp = puo2_cp*pu_mFraction + uo2_cp*(1-pu_mFraction);
  else
    p_coef = 2.58 - 0.58e-3*T_C;
    k = 100 * (max(40.4/(464+T_C),0.0191)+1.216e-4*exp(1.867e-3*T_C)) * (1-p_coef*porosity)/(1-p_coef*0.05);
    cp = uo2_cp;
    puo2_cp = 375; //Not used
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-82,42},{-26,-56},{82,-22}},
          color={0,0,0},
          smooth=Smooth.Bezier,
          thickness=1),
        Ellipse(
          extent={{-76,14},{-66,4}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-82,52},{-72,42}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-62,-12},{-52,-22}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,-54},{-8,-64}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,-24},{10,-34}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{38,-38},{48,-48}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{52,-12},{62,-22}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{88,-24},{98,-34}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-42,-12},{-32,-22}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,100},{-100,-100},{100,-100}},
          color={0,0,0},
          thickness=1),
        Polygon(
          points={{78,-92},{100,-100},{78,-108},{78,-92}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-11,8},{11,0},{-11,-8},{-11,8}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-99,90},
          rotation=90)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="# Property Model for Nuclear Fuel Material
Correlations, for thermal conductivity \\\\(k\\\\) and specific heat capacity \\\\(cp\\\\), are taken from:
1. N.E. Todreas, M. S. Kazimi, Nuclear System I, Thermal Hydraulics Fundamentals. Taylor&Francis, 1798.
2. MATPRO VERSION 11, A HANDBOOK OF MATERIALS PROPERTIES FOR USE IN THE ANALYSIS OF LIGHT WATER REACTOR FUEL ROD BEHAVIOR. NUREG/CR-0497 TREE-1280, 1979.

They apply for both \\\\(UO_2\\\\) and \\\\(MOX\\\\) fuels. The effect of porosity is taken into account. However, other effects such as burnup or others still need to be taken into account.
"));
end FuelProperties;
