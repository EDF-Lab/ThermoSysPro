# Contribution and Development Guidelines

## First Things First: open an issue
To report a bug, request a new feature, propose a development or for any question, please open an [issue](https://github.com/EDF-Lab/ThermoSysPro/issues/new/choose) on the GitHub repository.

If you do not have a GitHub account, you can [mail us](mailto:contact-thermosyspro@edf.fr) your issue so that we can open it on your behalf. 

## Development Committee
Regular monthly meeting are run by the EDF R&D team responsible for the development of ThermoSysPro. 
This Committee has the following objectives:
- Review new issues, discuss the potential solution, assign them to a developer.
- Approve developments and pull requests.
- Discuss the development roadmap (library main orientations for the future).

Partners or issue reporter may be invited to participate to this meeting.

## Code Development

### Repository structure
The [`master`](https://github.com/EDF-Lab/ThermoSysPro/tree/master) branch contains only official releases. This is the *default* branch of the repository. A *tag* is associated to each release. No development is made directly in this branch (which is *protected*).

The [`develop`](https://github.com/EDF-Lab/ThermoSysPro/tree/develop) branch is the receptacle of all developments. This branch is also *protected*, meaning that developments can only be done through  `feature`/`fix`/... branches and associated *pull requests*; these branches originate from the `develop` branch and merge later into it. The `develop` branch merges into `master` to originate new official releases. 

```mermaid
%%{init: {'gitGraph': {'showCommitLabel': false, 'mainBranchName':'master'}} }%%
gitGraph
commit type: HIGHLIGHT tag: "3.2"
commit type: HIGHLIGHT tag: "4.0"
branch develop
branch feature_newPipe
commit
commit
checkout develop
merge feature_newPipe
branch feature_newMedia
commit
checkout develop
branch feature_newVolume
commit
checkout develop
merge feature_newVolume
checkout master
merge develop type: HIGHLIGHT tag: "4.1"
checkout feature_newMedia
commit
commit
checkout develop
merge feature_newMedia
checkout master
merge develop type: HIGHLIGHT tag: "5.0"

```
#### Notable exceptions
Developments which are not related to the actual code (for example, files for CI/CD pipelines, readmes, minor documentation modification, graphics...) can be developed on `minor` branches that originate directly on `master` and are directly merged on it.

Such developments do not generate new official releases (no tag). This allows to make useful slight modifications (which do not affect the behavior of the models) quickly available.

Another exception concerns *quick* bug correction. `hotFix` branches should originates directly from `master` (instead of `develop`as common `feature` branches). Once merged back into `master`, they give place to a **patch version tag**. Then, `develop` has to be rebased on the new version of `master` with the following command:

```
git rebase master develop
```
This allows develop (and child-branches, once also rebased on `develop`) to inherit the bug correction. 


```mermaid
%%{init: {'gitGraph': {'showCommitLabel': true, 'mainBranchName':'master'}} }%%
gitGraph
commit id: "   " type: HIGHLIGHT tag: "4.1"
branch hotFix_typo order: 1
commit id: "Coef fix"
checkout master
merge hotFix_typo type: HIGHLIGHT tag: "4.1.1"
branch develop order: 3
commit id:"    "
branch feature_newCorrelation order: 4
commit id:"  "
checkout master
branch pipeline order: 2
commit id: "Pipeline test"
commit id: "Pipeline final"
checkout master
merge pipeline
checkout feature_newCorrelation
commit id:" "
```

**Important Remarks**: 
- The `rebase` command restructures the git history: it makes the `develop` commits appear as if they were realized after the last state of `master` (the merge of `hotFix_typo` in the example) even if that is not the case. This clears the history and makes future merges less susceptible to conflicts. 
- It is **strongly recommended** to periodically rebase each development branch on the `develop` one, to reduce divergencies and conflicts later on; to be done by each developer. For example, looking at the 1st graph, `feature_newMedia` should be rebased on develop after the merge of `feature_newVolume`.

#### Branch naming
Development branches have to be named according to the following rule: `type/issue_description`, where:
- `type` is one among:
  - `feature`: development of new feature.
  - `fix`: bug correction.
  - `hotfix`: urgent bug correction, directly applied on `master`.
  - `misc`: development non related with the Modelica code; it may directly be applied on `master`.
- `issue` is the number of the issue the branch is devoted to.
- `description` is a short description of the development, more "solution oriented" rather than "issue oriented" (multiple solutions can be developed in different branches for the same issue). The description can be in `CamelCase` or with words separated by `-` (no whitespace). 

### Workflow
Here follows a synthetic view of the workflow for contribution:
1. Reporter: open an issue.

    &rarr; The issue will be reviewed by the Development Committee in the periodic meeting. Discussion on how to solve the issue can take place there and the issue will be commented accordingly. This first review should not delay the reporter from developing a solution by himself/herself following the next steps of the workflow. A developer from the Development Committee can also be designated to solve the issue.

    If developments are required (the issue is not a question, not *refused*...): 

1. Reporter/Developer: create a new `feature` branch from `develop`. *Hint: the branch can be created from the issue itself (to link the future developments to the issue)*. 

    It is recommended to directly create a *draft* Pull Request for that branch, and to use the appropriate label depending on the advances:
    - `WIP`: Work In Progress (draft pull request).
    - `reviewToMerge`: to be reviewed or ongoing review.
    - `readyToMerge`: waiting the final approval from the DevCom. 
1. Reporter/Developer: realize the necessary developments in as many *atomic* commits as needed. *Hint: cite the issue `#ID` in commit messages to link commits and issue*.
1. Reporter/Developer: create a pull request (or mark the draft pull request as *ready for review*). 

    &rarr; The pull request will be reviewed by the Development Committee in their periodic meeting. 

1. If necessary, comments are added to the pull requests and some additional developments/iterations are requested.
1. DevCom action: The pull request is accepted and the `feature` branch is merged in the `develop` branch.


```mermaid
flowchart
issue[Open issue] -.-> DC1([DevCom Issue Review])
DC2([DevCom Merge Review])
issue --> branch[feature branch]
branch --> Developments
Developments --> mergeR[Pull Request]
DC2 -.-> Merge[Merge to develop]
mergeR --> Merge 

```

### Non-Regression Tests

Every pull request targeting `develop` or `master`, and every push to these branches, runs the following actions (*CI/CD pipeline*):

- Non-regression tests with OpenModelica ([GitHub Actions](https://github.com/EDF-Lab/ThermoSysPro/actions/workflows/openmodelica-tests.yml)):
    - Check, translation and simulation of the models of the `Examples` package of ThermoSysPro.
    - Comparison with the target branch of the pull request (`master` for a push to `develop`): fixed models, regressions, changed results.
    - Report in the run summary, and HTML/CSV reports and OpenModelica logs as artifacts of the run.
- Non-regression tests with Dymola, on an internal EDF runner (GitLab mirror of the repository).
- Generation of the [documentation](https://edf-lab.github.io/ThermoSysPro/) from the Modelica annotations ([GitHub Actions](https://github.com/EDF-Lab/ThermoSysPro/actions/workflows/documentation.yml)), published on GitHub Pages from `master`.

The *test models* are the models of the `Examples` package of ThermoSysPro and an additional library of *private* models. Please [mail](mailto:contact-thermosyspro@edf.fr) us if you want to include some of your model in the test suite.
