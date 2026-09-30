within ThermoSysPro.Fluid.Examples.SimpleExamples.Machines;
model TestCompressor
  extends ThermoSysPro.UsersGuide.Icons.Example;

  replaceable package Medium = ThermoSysPro.Properties.Media.FlueGases;
  parameter Real is_eff_n1(fixed=false, start=0.85) "Nominal isentropic efficiency";

  ThermoSysPro.Fluid.Machines.Compressor Compressor(
    redeclare package Medium = Medium,
    Ps(fixed=false),
    tau_n=16,
    is_eff_n=is_eff_n1,
    Pe(fixed=false, start=100000),
    Ts(fixed=true, start=680)) annotation (Placement(transformation(extent={{-52,-52},{48,52}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourcePQ SourceQ1(
    redeclare package Medium = Medium,
    X0={1 - 0.003 - 0.23,0.23,0.003,0,0},
    Q0=420,
    P0=100000,
    T0=288,
    option_temperature=true) annotation (Placement(transformation(extent={{-104,-10},{-84,10}}, rotation=0)));

  ThermoSysPro.Fluid.BoundaryConditions.SinkP SinkP1(redeclare package Medium = Medium, P0=15.8e5) annotation (Placement(transformation(
        origin={96,0},
        extent={{10,-10},{-10,10}},
        rotation=180)));
equation
  connect(SourceQ1.C, Compressor.Ce) annotation (Line(
      points={{-84,0},{-39.5,0}},
      color={0,0,0},
      thickness=1));
  connect(Compressor.Cs, SinkP1.C) annotation (Line(
      points={{35.5,0},{86,0}},
      color={0,0,0},
      thickness=1));
  annotation (Diagram(graphics), Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2021</b> </p>
<p><b>ThermoSysPro Version 4.0</b> </p>
</html>"));
end TestCompressor;
