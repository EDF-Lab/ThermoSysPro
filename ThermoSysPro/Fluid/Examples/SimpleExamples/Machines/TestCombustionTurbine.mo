within ThermoSysPro.Fluid.Examples.SimpleExamples.Machines;
model TestCombustionTurbine
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.FlueGases;
  parameter Real is_eff_n1(fixed=false, start=0.85) "Nominal isentropic efficiency";
  parameter Real Qred1(fixed=false, start=0.01) "Reduced mass flow rate";

  Fluid.Machines.CombustionTurbine CombustionTurbine(
    redeclare package Medium = Medium,
    tau_n=0.065,
    is_eff_n=is_eff_n1,
    Qred=Qred1,
    Pe(fixed=true, start=1500000),
    Ts(fixed=true, start=830),
    Hs(start=769796.2+Medium.h_offset))           annotation (Placement(transformation(extent={{-42,-42},{36,42}}, rotation=0)));
  Fluid.BoundaryConditions.SourceQ SourceQ1(
    redeclare package Medium = Medium,
    option_temperature=true,
    X0={1-0.14-0.06-0.06,0.14,0.06,0.06,0},
    Q0=430,
    T0=1500) annotation (Placement(transformation(extent={{-106,-10},{-86,10}}, rotation=0)));
  Fluid.BoundaryConditions.SinkP SinkP1(redeclare package Medium = Medium,
    P0=100000,
    T0=830)                                                                        annotation (Placement(transformation(
        origin={94,0},
        extent={{10,-10},{-10,10}},
        rotation=180)));
  InstrumentationAndControl.Blocks.Sources.Constante Wc1(k=-1.8e8) annotation (Placement(transformation(extent={{-100,-42},{-80,-22}}, rotation=0)));
equation
  connect(SourceQ1.C, CombustionTurbine.Ce) annotation (Line(
      points={{-86,0},{-42,0}},
      color={0,0,0},
      thickness=1));
  connect(CombustionTurbine.Cs, SinkP1.C) annotation (Line(
      points={{36,0},{84,0}},
      color={0,0,0},
      thickness=1));
  connect(Wc1.y, CombustionTurbine.CompressorPower) annotation (Line(points={{-79,-32},{-45.9,-32},{-45.9,-16.8}}));
  annotation (Diagram(graphics), Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2024 </p>
<p><b>ThermoSysPro Version 4.1 </p>
<p>This model is documented in Sect. 11.4.5 of the <a href=\"https://www.springer.com/us/book/9783030051044\">ThermoSysPro book</a>.</h4>
<p>The results reported in the ThermoSysPro book were computed using Dymola.</h4>
</html>"));
end TestCombustionTurbine;
