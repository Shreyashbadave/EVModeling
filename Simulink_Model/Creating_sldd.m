%% Create Simulink Data Dictionary for Tata Punch EV

dictName = 'PunchEV_Data.sldd';

%% Check if SLDD exists
if isfile(dictName)
    fprintf('SLDD found: %s\n', dictName);
    dd = Simulink.data.dictionary.open(dictName);
else
    fprintf('SLDD not found. Creating new SLDD...\n');

    % Create new data dictionary
    dd = Simulink.data.dictionary.create(dictName);

    % Create Design Data section explicitly (good practice)
    dData = getSection(dd,'Design Data');

    % Optional: add a placeholder entry so it is not empty
    addEntry(dData,'PunchEV.InitFlag',true);

    % Save immediately
    saveChanges(dd);

    fprintf('SLDD created successfully: %s\n', dictName);
end

% Access Design Data section
dData = getSection(dd, 'Design Data');

%% ------------------------
% Vehicle Parameters
%% ------------------------
PunchEV.Vehicle.Mass_kg        = 1340;     % kg
PunchEV.Vehicle.CG_Front_m     = 1.10;     % m
PunchEV.Vehicle.CG_Rear_m      = 1.35;     % m
PunchEV.Vehicle.CG_Height_m    = 0.50;     % m
PunchEV.Vehicle.FrontalArea_m2 = 2.4;      % m^2
PunchEV.Vehicle.Cd             = 0.32;     % -
PunchEV.Road.AirDensity_kgm3   = 1.225;    % kg/m^3
PunchEV.Constants.g            = 9.81;     % m/s^2

%% ------------------------
% Battery Parameters
%% ------------------------
PunchEV.Battery.NominalVoltage_V = 320;   % assumed nominal pack voltage

% Standard Range
PunchEV.Battery.Standard.Capacity_kWh = 25;
PunchEV.Battery.Standard.Capacity_Ah  = 25e3 / PunchEV.Battery.NominalVoltage_V;
PunchEV.Battery.Standard.InternalResistance_Ohm = 0.05;

% Long Range
PunchEV.Battery.LongRange.Capacity_kWh = 35;
PunchEV.Battery.LongRange.Capacity_Ah  = 35e3 / PunchEV.Battery.NominalVoltage_V;
PunchEV.Battery.LongRange.InternalResistance_Ohm = 0.045;

%% =========================================================
% Tata Punch EV - Motor Parameters (Equivalent DC Motor)
% Used for system-level EV simulation in Simscape
% =========================================================

%% -------- Electrical Parameters --------
PunchEV.Motor.FieldType                 = "PermanentMagnet";   % For documentation
PunchEV.Motor.ModelParamType            = "RatedLoadSpeed";    % Documentation only

PunchEV.Motor.DC_BusVoltage_V           = 320;      % V
PunchEV.Motor.RatedPower_kW             = 75;       % kW (continuous, safe)
% PunchEV.Motor.RatedPower_kW           = 84;       % Optional (aggressive)

PunchEV.Motor.RatedSpeed_rpm            = 3800;     % rpm
PunchEV.Motor.NoLoadSpeed_rpm           = 10000;    % rpm

PunchEV.Motor.ArmatureInductance_H      = 0.5e-3;   % H (0.5 mH)

%% -------- Mechanical Parameters --------
PunchEV.Motor.RotorInertia_gcm2         = 3e5;      % g*cm^2  (~0.03 kg*m^2)
PunchEV.Motor.RotorDamping_Nm_s_rad     = 0.001;    % N*m*s/rad

PunchEV.Motor.InitialSpeed_rpm          = 0;        % rpm

%% -------- Derived / Documentation --------
PunchEV.Motor.PeakTorque_Nm             = 190;      % Nm (Punch.ev LR target)
PunchEV.Motor.PeakPower_kW              = 90;       % kW (marketing peak)

disp('PunchEV Motor parameters loaded');


%% ------------------------
% Road Load Parameters
%% ------------------------
PunchEV.Road.RollingResistanceCoeff = 0.012;
PunchEV.Road.AirDensity_kg_per_m3   = 1.225;

%% ============================================================
%  Tata Punch EV – Tire Parameters (Magic Formula, Longitudinal)
% ============================================================

% -------- Main (Magic Formula Parameterization) --------
PunchEV.Tire.ParameterizationMethod = "PeakForceAndSlip";  % Informational

PunchEV.Tire.RatedVerticalLoad_N    = 3000;    % N
PunchEV.Tire.PeakLongForce_N        = 3500;    % N
PunchEV.Tire.SlipAtPeak_percent     = 10;      % %

% -------- Geometry --------
PunchEV.Tire.RollingRadius_m        = 0.30;    % m (≈ 185/70 R15 under load)

% -------- Rolling Resistance --------
PunchEV.Tire.RollingResistanceEnable = false; % Model rolling resistance OFF
PunchEV.Tire.Crr                     = 0.012; % Used only if enabled

% -------- Dynamics --------
PunchEV.Tire.ComplianceModel        = "NoCompliance"; % HIL-friendly
PunchEV.Tire.InertiaModel           = "NoInertia";    % Simplified wheel

% -------- Advanced / Numerical Stability --------
PunchEV.Tire.VxLowLimit_mps         = 1.0;     % m/s
PunchEV.Tire.VelocityThreshold_mps  = 0.1;     % m/s
PunchEV.Tire.KPUMIN                 = -1.5;    % minimum valid slip
PunchEV.Tire.KPUMAX                 =  1.5;    % maximum valid slip


%% Save and close
saveChanges(dd);
close(dd);

disp('SLDD update complete. MATLAB survived.');