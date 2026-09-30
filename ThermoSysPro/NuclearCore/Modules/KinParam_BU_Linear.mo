within ThermoSysPro.NuclearCore.Modules;
model KinParam_BU_Linear
  extends ThermoSysPro.NuclearCore.Interfaces.KineticParametersInterface;

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table=[0,-30,-3,0,2e-05,0.0124,
        0.0305,0.111,0.301,1.14,3.01,0.00021,0.00142,0.00128,0.00257,0.00075,0.00027,
        0,-10,0,0; 1,-30,-3,0,2e-05,0.0124,0.0305,0.111,0.301,1.14,3.01,0.00021,
        0.00142,0.00128,0.00257,0.00075,0.00027,0,-10,0,0])
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(BUinput.Burnup, combiTable1Ds.u) annotation (Line(points={{-100,0},{
          -12,0}}, color={0,140,72}), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(combiTable1Ds.y, adaptorModelicaTSP.u)
    annotation (Line(points={{11,0},{44,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
                                    Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="# Kinetic Parameters - Linear burnup dependence

This model is a specific implementation of the generic [KineticParametersInterface](modelica://ThermoSysPro.NuclearCore.Interfaces.KineticParametersInterface) 
interface in which all neutronic and reactivity parameters are evaluated from the fuel burnup using linear interpolation of tabulated values."));
end KinParam_BU_Linear;
