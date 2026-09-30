

# Tests 

![Fig1](fig1.png)

# With DTLM (PbHE_V2.TEstHE2_Test_HE_Multiple_DTLM)



## In the log errors occurs :

### For exemple : 

Warning: The following was detected at time: 0
  Low DT1 or DT2, instable calculation, consider using NUT method
  Failed condition: abs(staticExchangerKS_Multiple2.DT1) > 0.1 and abs(staticExchangerKS_Multiple2.DT2) > 0.1

Error: The following error was detected at time: 0
Water_Ph: Incorrect region number (-1)
The stack of functions is:
ThermoSysPro.Properties.Fluid.Temperature_Ph(staticExchangerKS_Multiple4.Sf.P, staticExchangerKS_Multiple4.Sf.h, 1, 0, 0, 0, 0, 0)

Warning: The following was detected at time: 19.1134592389789
  Low DT1 or DT2, instable calculation, consider using NUT method
  Failed condition: abs(staticExchangerKS_Multiple3.DT1) > 0.1 and abs(staticExchangerKS_Multiple3.DT2) > 0.1

Error: The following error was detected at time: 19.93
Model error - Modelica.Math.log (abs(staticExchangerKS_Multiple3.DT1/staticExchangerKS_Multiple3.DT2)) = Modelica.Math.log (0)

Warning: The following was detected at time: 40.49561053196798
  Low DT1 or DT2, instable calculation, consider using NUT method
  Failed condition: abs(staticExchangerKS_Multiple4.DT1) > 0.1 and abs(staticExchangerKS_Multiple4.DT2) > 0.1

Warning: Nonlinear solver accepted imprecise solution (within integrator tolerance) when solving
  Tag: simulation.nonlinear[2] during event iteration at time 60.
  Disallow imprecise solutions by setting Advanced.Simulation.NonlinearImpreciseSolution = false.

Error: The following error was detected at time: 60.00001
Model error - Modelica.Math.log (abs(staticExchangerKS_Multiple3.DT1/staticExchangerKS_Multiple3.DT2)) = Modelica.Math.log (0)

## HE1 (Multiple1) - Same Flow rate: 
Results OK 

## HE2 (Multiple2) - Same inlet T°c: 
Results OK but warning low DT1 or DT2

## HE3 (Multiple3) - Low flow rate: 
Numerous Errors messages and unrealistic temperature when low flow rate 
![Fig2](fig2.png)

## HE4 (Multiple4) - changing side temperature : 
Results OK but warning low DT1 or DT2


# With NUT method (PbHE_V2.TEstHE2_Test_HE_Multiple_NUT)
Everything is fine : log is empty
## HE3 (Multiple3) - Low flow rate: 
![Fig3](fig3.png)