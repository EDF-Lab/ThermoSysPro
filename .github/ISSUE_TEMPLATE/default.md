---
name: Issue
about: Report a bug or ask a question
labels: []
---

<!-- Appropriate labels can also be added, for more information please see [ThermoSysPro workflow](https://github.com/EDF-Lab/ThermoSysPro/blob/master/ContributionsWorkflow.md). -->

# Issue

## Description
Clearly and concisely describe the problem encountered.

### Expected Behavior
Describe what you expected to happen.

### Actual Behavior
Describe what actually happens.

## Environment
- **Operating System**: (Linux/Windows)
- **Modelica Environment Used (and corresponding version)**: (OpenModelica 1.23/Dymola 23x)
- **ThermoSysPro's commit/version used**: dfe1168ad22d0364dfd2b129b2931efb5ab4dcf5/4.0

## Steps to Reproduce
Please provide any material needed to reproduce your output, from a list of steps to reproduce it to a `.mat` file or a `.mos` script.

1. Describe the first step.
2. Describe the second step.
3. ...

Example of .mos file for Dymola :
```modelica
openModel("ThermoSysPro/package.mo", changeDirectory=false);
checkModel("ThermoSysPro.Examples.SimpleExamples.TestBend");
translateModel("ThermoSysPro.Examples.SimpleExamples.TestBend");
simulateModel(problem="ThermoSysPro.Examples.SimpleExamples.TestBend", startTime=0, stopTime=1, method="dassl", tolerance=1e-4);
```

Example of [.mos file for OpenModelica](https://openmodelica.org/doc/OpenModelicaUsersGuide/latest/scripting_api.html) :
```modelica
loadModel(Modelica,{"4.0"}); getErrorString();
loadModel(ThermoSysPro,{"4.0"});getErrorString();
simulate(ThermoSysPro.Examples.SimpleExamples.TestBend); getErrorString();
```

## Logs and Screenshots
Add logs or screenshots if needed.

## Additional Notes
Add any additional information that might be useful.


