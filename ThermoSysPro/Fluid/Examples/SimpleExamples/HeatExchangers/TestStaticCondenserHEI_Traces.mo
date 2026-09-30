within ThermoSysPro.Fluid.Examples.SimpleExamples.HeatExchangers;
model TestStaticCondenserHEI_Traces
  extends TestStaticCondenserHEI(
    redeclare package Medium = ThermoSysPro.Properties.Media.WaterSteam(
      extraPropertiesNames={"Trace1", "Trace2"},
      C_nominal={0.1, 2},
      C_default={0.2, 5}),
    sourceP(SubC0={10,20}),
    sourceP1(SubC0={10,20}),
    sourceP2(SubC0={10,20}),
    sourceCooling(SubC0={10,20}),
    condenseur(Cvt(SubC(start={10,20})), Cev(SubC(start={10,20})), Cep(SubC(start={10,20})), Cee(SubC(start={10,20}))));
  annotation (experiment(StopTime=1000), Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestStaticCondenserHEI_Traces;
