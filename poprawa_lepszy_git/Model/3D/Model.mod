'# MWS Version: Version 2024.1 - Oct 16 2023 - ACIS 33.0.1 -

'# length = mm
'# frequency = MHz
'# time = ns
'# frequency range: fmin = 800 fmax = 2700
'# created = '[VERSION]2024.1|33.0.1|20231016[/VERSION]


'@ use template: Antenna - Wire_2.cfg

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
'set the units
With Units
    .SetUnit "Length", "mm"
    .SetUnit "Frequency", "MHz"
    .SetUnit "Voltage", "V"
    .SetUnit "Resistance", "Ohm"
    .SetUnit "Inductance", "nH"
    .SetUnit "Temperature",  "degC"
    .SetUnit "Time", "ns"
    .SetUnit "Current", "A"
    .SetUnit "Conductance", "S"
    .SetUnit "Capacitance", "pF"
End With

ThermalSolver.AmbientTemperature "0"

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "2000", "2700"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

Mesh.FPBAAvoidNonRegUnite "True"
Mesh.ConsiderSpaceForLowerMeshLimit "False"
Mesh.MinimumStepNumber "5"
Mesh.RatioLimit "20"
Mesh.AutomeshRefineAtPecLines "True", "10"

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "10"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With MeshSettings
     .SetMeshType "Srf"
     .Set "Version", 1
End With
IESolver.SetCFIEAlpha "1.000000"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "2000;2100;2350;2650;2700"
Dim sDefineAtName As String
sDefineAtName = "2000;2100;2350;2650;2700"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ define material: Aluminum

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Material
     .Reset
     .Name "Aluminum"
     .Folder ""
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "3.56e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "Kelvin"
     .Mu "1.0"
     .Sigma "3.56e+007"
     .Rho "2700.0"
     .ThermalType "Normal"
     .ThermalConductivity "237.0"
     .SpecificHeat "900", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "69"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "23"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ new component: component1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Component.New "component1"

'@ define brick: component1:boom#1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Brick
     .Reset 
     .Name "boom#1" 
     .Component "component1" 
     .Material "Aluminum" 
     .Xrange "-d/2", "d/2" 
     .Yrange "-d/2", "d/2" 
     .Zrange "0", "L" 
     .Create
End With

'@ pick face

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickFaceFromId "component1:boom#1", "1"

'@ pick face

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickFaceFromId "component1:boom#1", "2"

'@ shell object: component1:boom#1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.ShellAdvanced "component1:boom#1", "Centered", "1", "True"

'@ define cylinder: component1:#1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#1" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "(d/2)+l1" 
     .Ycenter "0" 
     .Zcenter "d1" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#2

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#2" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "(-d/2)-l2" 
     .Ycenter "0" 
     .Zcenter "d2" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#3

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#3" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "(d/2)+l3" 
     .Ycenter "0" 
     .Zcenter "d3" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#4

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#4" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "(-d/2)-l4" 
     .Ycenter "0" 
     .Zcenter "d4" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#5

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#5" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "(d/2)+l5" 
     .Ycenter "0" 
     .Zcenter "d5" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#6

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#6" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "(-d/2)", "(-d/2)-l6" 
     .Ycenter "0" 
     .Zcenter "d6" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#7

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#7" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "(d/2)+l7" 
     .Ycenter "0" 
     .Zcenter "d7" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#8

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#8" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "(-d/2)", "(-d/2)-l8" 
     .Ycenter "0" 
     .Zcenter "d8" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#9

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#9" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "(d/2)", "(d/2)+l9" 
     .Ycenter "0" 
     .Zcenter "d9" 
     .Segments "0" 
     .Create 
End With

'@ boolean add shapes: component1:#1, component1:#2

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#1", "component1:#2"

'@ boolean add shapes: component1:#3, component1:#4

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#3", "component1:#4"

'@ boolean add shapes: component1:#5, component1:#6

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#5", "component1:#6"

'@ boolean add shapes: component1:#7, component1:#8

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#7", "component1:#8"

'@ boolean add shapes: component1:#9, component1:boom#1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#9", "component1:boom#1"

'@ boolean add shapes: component1:#1, component1:#3

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#1", "component1:#3"

'@ boolean add shapes: component1:#5, component1:#7

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#5", "component1:#7"

'@ boolean add shapes: component1:#5, component1:#9

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#5", "component1:#9"

'@ boolean add shapes: component1:#1, component1:#5

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#1", "component1:#5"

'@ paste structure data: 1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With SAT 
     .Reset 
     .FileName "*1.cby" 
     .SubProjectScaleFactor "0.001" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With

'@ transform: translate component1:#1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:#1_1" 
     .Vector "0", "-k", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ transform: mirror component1:#1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:#1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "-1", "0", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ delete shape: component1:#1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Delete "component1:#1_1"

'@ paste structure data: 4

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With SAT 
     .Reset 
     .FileName "*4.cby" 
     .SubProjectScaleFactor "0.001" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With

'@ transform: mirror component1:#1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:#1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "-1", "0", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: translate component1:#1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:#1_1" 
     .Vector "0", "-k", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ pick face

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickFaceFromId "component1:#1", "1"

'@ pick face

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickFaceFromId "component1:#1_1", "10"

'@ pick point

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickPointFromCoordinates "0.2150076314163", "-3.1875372291769", "142"

'@ pick point

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickPointFromCoordinates "0.27744329700569", "-5.6490452299812", "142"

'@ define discrete port: 1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "50.0"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "True", "0.2150076314163", "-3.1875372291769", "142"
     .SetP2 "True", "0.27744329700569", "-5.6490452299812", "142"
     .InvertDirection "False"
     .LocalCoordinates "False"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ define time domain solver parameters

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "True"
     .NormingImpedance "50"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ define frequency range

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solver.FrequencyRange "800", "2700"

''@ delete shape: component1:#1_1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Solid.Delete "component1:#1_1_1"
'
''@ delete shape: component1:#1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Solid.Delete "component1:#1_1"
'
''@ paste structure data: 3
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With SAT 
'     .Reset 
'     .FileName "*3.cby" 
'     .SubProjectScaleFactor "0.001" 
'     .ImportToActiveCoordinateSystem "True" 
'     .ScaleToUnit "True" 
'     .Curves "False" 
'     .Read 
'End With
'
''@ transform: translate component1:#1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:#1_1" 
'     .Vector "0", "-k", "0" 
'     .UsePickedPoints "False" 
'     .InvertPickedPoints "False" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Translate" 
'End With
'
''@ transform: mirror component1:#1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:#1_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .PlaneNormal "-1", "0", "0" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Mirror" 
'End With
'
''@ delete port: port1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Port.Delete "1"
'
''@ pick face
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickFaceFromId "component1:#1", "1"
'
''@ pick face
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickFaceFromId "component1:#1_1", "10"
'
''@ pick point
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickPointFromCoordinates "0.48050240710327", "-8.585", "142"
'
''@ pick point
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickPointFromCoordinates "0.97135869387638", "-2.7464018325594", "142"
'
''@ define discrete port: 1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With DiscretePort 
'     .Reset 
'     .PortNumber "1" 
'     .Type "SParameter"
'     .Label ""
'     .Folder ""
'     .Impedance "50.0"
'     .Voltage "1.0"
'     .Current "1.0"
'     .Monitor "True"
'     .Radius "0.0"
'     .SetP1 "True", "0.48050240710327", "-8.585", "142"
'     .SetP2 "True", "0.97135869387638", "-2.7464018325594", "142"
'     .InvertDirection "False"
'     .LocalCoordinates "False"
'     .Wire ""
'     .Position "end1"
'     .Create 
'End With
'
''@ transform: translate component1:#1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:#1_1" 
'     .Vector "0", "-k", "0" 
'     .UsePickedPoints "False" 
'     .InvertPickedPoints "False" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Translate" 
'End With
'
''@ transform: mirror component1:#1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:#1_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .PlaneNormal "-1", "0", "0" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Mirror" 
'End With
'
''@ pick face
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickFaceFromId "component1:#1_1", "10"
'
''@ pick face
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickFaceFromId "component1:#1", "1"
'
''@ pick point
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickPointFromCoordinates "-0.15229332851368", "-7.7003508570253", "140"
'
''@ pick point
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickPointFromCoordinates "-0.045465450921941", "-2.8185425167156", "140"
'
''@ define discrete port: 1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With DiscretePort 
'     .Reset 
'     .PortNumber "1" 
'     .Type "SParameter"
'     .Label ""
'     .Folder ""
'     .Impedance "50.0"
'     .Voltage "1.0"
'     .Current "1.0"
'     .Monitor "True"
'     .Radius "0.0"
'     .SetP1 "True", "-0.15229332851368", "-7.7003508570253", "140"
'     .SetP2 "True", "-0.045465450921941", "-2.8185425167156", "140"
'     .InvertDirection "False"
'     .LocalCoordinates "False"
'     .Wire ""
'     .Position "end1"
'     .Create 
'End With
'
''@ define time domain solver parameters
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Mesh.SetCreator "High Frequency" 
'
'With Solver 
'     .Method "Hexahedral"
'     .CalculationType "TD-S"
'     .StimulationPort "All"
'     .StimulationMode "All"
'     .SteadyStateLimit "-40"
'     .MeshAdaption "False"
'     .AutoNormImpedance "True"
'     .NormingImpedance "50"
'     .CalculateModesOnly "False"
'     .SParaSymmetry "False"
'     .StoreTDResultsInCache  "False"
'     .RunDiscretizerOnly "False"
'     .FullDeembedding "False"
'     .SuperimposePLWExcitation "False"
'     .UseSensitivityAnalysis "False"
'End With
'
''@ define brick: component1:solid1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With Brick
'     .Reset 
'     .Name "solid1" 
'     .Component "component1" 
'     .Material "Aluminum" 
'     .Xrange "d/2", "-d/2" 
'     .Yrange "-d/2-10.25", "d/2" 
'     .Zrange "0", "-10" 
'     .Create
'End With
'
''@ delete shape: component1:#1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Solid.Delete "component1:#1_1"
'
''@ paste structure data: 2
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With SAT 
'     .Reset 
'     .FileName "*2.cby" 
'     .SubProjectScaleFactor "0.001" 
'     .ImportToActiveCoordinateSystem "True" 
'     .ScaleToUnit "True" 
'     .Curves "False" 
'     .Read 
'End With
'
''@ transform: translate component1:#1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:#1_1" 
'     .Vector "0", "-10.25", "0" 
'     .UsePickedPoints "False" 
'     .InvertPickedPoints "False" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Translate" 
'End With
'
''@ delete port: port1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Port.Delete "1"
'
''@ pick face
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickFaceFromId "component1:#1", "1"
'
''@ pick face
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickFaceFromId "component1:#1_1", "10"
'
''@ transform: translate component1:#1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:#1_1" 
'     .Vector "-1", "0", "0" 
'     .UsePickedPoints "False" 
'     .InvertPickedPoints "False" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Translate" 
'End With
'
''@ transform: translate component1:#1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:#1_1" 
'     .Vector "1", "0", "0" 
'     .UsePickedPoints "False" 
'     .InvertPickedPoints "False" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Translate" 
'End With
'
''@ transform: mirror component1:#1_1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With Transform 
'     .Reset 
'     .Name "component1:#1_1" 
'     .Origin "Free" 
'     .Center "0", "0", "0" 
'     .PlaneNormal "-1", "0", "0" 
'     .MultipleObjects "False" 
'     .GroupObjects "False" 
'     .Repetitions "1" 
'     .MultipleSelection "False" 
'     .AutoDestination "True" 
'     .Transform "Shape", "Mirror" 
'End With
'
''@ pick face
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickFaceFromId "component1:#1", "1"
'
''@ pick face
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickFaceFromId "component1:#1_1", "10"
'
''@ pick point
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickPointFromCoordinates "0.090739504790383", "-3.0827853550885", "142"
'
''@ pick point
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'Pick.PickPointFromCoordinates "0.19034967717961", "-6.835", "142"
'
''@ define discrete port: 1
'
''[VERSION]2024.1|33.0.1|20231016[/VERSION]
'With DiscretePort 
'     .Reset 
'     .PortNumber "1" 
'     .Type "SParameter"
'     .Label ""
'     .Folder ""
'     .Impedance "50.0"
'     .Voltage "1.0"
'     .Current "1.0"
'     .Monitor "True"
'     .Radius "0.0"
'     .SetP1 "True", "0.090739504790383", "-3.0827853550885", "142"
'     .SetP2 "True", "0.19034967717961", "-6.835", "142"
'     .InvertDirection "False"
'     .LocalCoordinates "False"
'     .Wire ""
'     .Position "end1"
'     .Create 
'End With
'
'@ delete shape: component1:#1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Delete "component1:#1_1"

'@ define brick: component1:boom#2

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Brick
     .Reset 
     .Name "boom#2" 
     .Component "component1" 
     .Material "Aluminum" 
     .Xrange "-d/2", "d/2" 
     .Yrange "-d/2-k", "d/2-k" 
     .Zrange "0", "L" 
     .Create
End With

'@ pick face

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickFaceFromId "component1:boom#2", "1"

'@ pick face

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickFaceFromId "component1:boom#2", "2"

'@ shell object: component1:boom#2

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.ShellAdvanced "component1:boom#2", "Centered", "1", "True"

'@ pick face

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickFaceFromId "component1:boom#2", "1"

'@ delete port: port1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Port.Delete "1"

'@ pick face

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickFaceFromId "component1:#1", "1"

'@ pick point

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickPointFromCoordinates "-0.31157406939345", "-5.8435709839956", "142"

'@ pick point

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickPointFromCoordinates "-0.10432067905166", "-3.1386914905102", "142"

'@ define cylinder: component1:#1dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#1dol" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l1" 
     .Ycenter "0-k" 
     .Zcenter "d1" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#2dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#2dol" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l2" 
     .Ycenter "0-k" 
     .Zcenter "d2" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#3 dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#3 dol" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l3" 
     .Ycenter "0-k" 
     .Zcenter "d3" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#4 dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#4 dol" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l4" 
     .Ycenter "0-k" 
     .Zcenter "d4" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#5

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#5" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l5" 
     .Ycenter "0-k" 
     .Zcenter "d5" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#6 dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#6 dol" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l6" 
     .Ycenter "0-k" 
     .Zcenter "d6" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#7dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#7dol" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l7" 
     .Ycenter "0-k" 
     .Zcenter "d7" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#8 dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#8 dol" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l8" 
     .Ycenter "0-k" 
     .Zcenter "d8" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#9 dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#9 dol" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l9" 
     .Ycenter "0-k" 
     .Zcenter "d9" 
     .Segments "0" 
     .Create 
End With

'@ boolean add shapes: component1:#1dol, component1:#2dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#1dol", "component1:#2dol"

'@ boolean add shapes: component1:#3 dol, component1:#4 dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#3 dol", "component1:#4 dol"

'@ boolean add shapes: component1:#5, component1:#6 dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#5", "component1:#6 dol"

'@ boolean add shapes: component1:#7dol, component1:#8 dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#7dol", "component1:#8 dol"

'@ boolean add shapes: component1:#9 dol, component1:boom#2

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#9 dol", "component1:boom#2"

'@ boolean add shapes: component1:#1dol, component1:#3 dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#1dol", "component1:#3 dol"

'@ boolean add shapes: component1:#5, component1:#7dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#5", "component1:#7dol"

'@ boolean add shapes: component1:#5, component1:#9 dol

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#5", "component1:#9 dol"

'@ boolean add shapes: component1:#1dol, component1:#5

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Solid.Add "component1:#1dol", "component1:#5"

'@ pick face

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickFaceFromId "component1:#1", "1"

'@ pick face

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickFaceFromId "component1:#1dol", "1"

'@ pick point

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickPointFromCoordinates "0.3132423414648", "-3.1241045578745", "142"

'@ pick point

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickPointFromCoordinates "0.19790803818496", "-5.5960963521922", "142"

'@ define discrete port: 1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "50.0"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "True", "0.3132423414648", "-3.1241045578745", "142"
     .SetP2 "True", "0.19790803818496", "-5.5960963521922", "142"
     .InvertDirection "False"
     .LocalCoordinates "False"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ farfield plot options

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With FarfieldPlot 
     .Plottype "3D" 
     .Vary "angle1" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "-1" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "True" 
     .ShowStructureProfile "True" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "True" 
     .AspectRatio "Free" 
     .ShowGridlines "True" 
     .InvertAxes "False", "False" 
     .SetSpecials "enablepolarextralines" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
     .IncludeUnitCellSidewalls "True" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .SetLogNorm "0" 
     .DBUnit "0" 
     .SetMaxReferenceMode "abs" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .SetInverseAxialRatio "False" 
     .SetAxesType "user" 
     .SetAntennaType "directional_linear" 
     .Phistart "1.000000e+00", "0.000000e+00", "0.000000e+00" 
     .Thetastart "0.000000e+00", "0.000000e+00", "1.000000e+00" 
     .PolarizationVector "0.000000e+00", "1.000000e+00", "0.000000e+00" 
     .SetCoordinateSystemType "ludwig3" 
     .SetAutomaticCoordinateSystem "True" 
     .SetPolarizationType "Slant" 
     .SlantAngle 0.000000e+00 
     .Origin "bbox" 
     .Userorigin "0.000000e+00", "0.000000e+00", "0.000000e+00" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+00" 
     .LossyGround "False" 
     .GroundEpsilon "1" 
     .GroundKappa "0" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "3.000000e+01" 
     .SetPhaseCenterComponent "boresight" 
     .SetPhaseCenterPlane "both" 
     .ShowPhaseCenter "True" 
     .ClearCuts 
     .AddCut "lateral", "0", "1"  
     .AddCut "lateral", "90", "1"  
     .AddCut "polar", "90", "1"  

     .StoreSettings
End With

'@ define monitor: e-field (f=1800)

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=1800)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "1750" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-41", "41", "-13", "3.5", "0", "152" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: h-field (f=1800)

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=1800)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "1800" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-41", "41", "-13", "3.5", "0", "152" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: e-field (f=1800)

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=1800)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "1800" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-41", "41", "-13", "3.5", "0", "152" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define farfield monitor: farfield (f=1800)

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (f=1800)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .MonitorValue "1800" 
     .ExportFarfieldSource "False" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-41", "41", "-13", "3.5", "0", "152" 
     .SetSubvolumeOffset "10", "10", "10", "10", "10", "10" 
     .SetSubvolumeInflateWithOffset "False" 
     .SetSubvolumeOffsetType "FractionOfWavelength" 
     .EnableNearfieldCalculation "True" 
     .Create 
End With

'@ define farfield monitor: farfield (broadband)

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Monitor 
     .Reset 
     .Name "farfield (broadband)" 
     .Domain "Time" 
     .Accuracy "1e-3" 
     .Samples "21" 
     .FieldType "Farfield" 
     .TransientFarfield "True" 
     .ExportFarfieldSource "False" 
     .Create 
End With

