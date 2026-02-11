function cqiTable = nrCQITables_Manual(tableID,verbose)
% nrCQITables  NR CQI Tables with derived SNR thresholds
% Based on 3GPP TS 38.214
%
% tableID:
%   1 -> Table 5.2.2.1-2 (até 64QAM)
%   2 -> Table 5.2.2.1-3 (inclui 256QAM)
%
% SNR thresholds computed via Shannon approximation

if nargin < 1
    tableID = 1;
end

CQI = (0:15).';

% ================================
% CQI 1–15 values (OFICIAIS)
% ================================

Qm_15 = [ ...
    2 2 2 2 2 2 ...
    4 4 4 4 ...
    6 6 6 6 6];

R1024_15 = [ ...
     78 193 449 378 490 616 ...
    466 567 666 772 ...
    873 948 711 797 885];

switch tableID
    
    case 1
        Qm_15(end) = 6; % 64QAM
        
    case 2
        Qm_15(end) = 8; % 256QAM
        
    otherwise
        error('Use tableID = 1 or 2');
end

% Add CQI 0
Qm    = [0 Qm_15].';
R1024 = [0 R1024_15].';

R  = R1024 / 1024;
SE = Qm .* R;

% ==========================================
% Derive SNR thresholds (Shannon-based)
% ==========================================

SNR_linear = zeros(size(SE));
SNR_dB     = zeros(size(SE));

for i = 1:length(SE)
    
    if SE(i) == 0
        SNR_linear(i) = 0;
        SNR_dB(i)     = -Inf;
    else
        SNR_linear(i) = 2^(SE(i)) - 1;
        SNR_dB(i)     = 10*log10(SNR_linear(i));
    end
end

% Modulation names
Modulation = strings(16,1);
for i = 1:16
    switch Qm(i)
        case 0
            Modulation(i) = "None";
        case 2
            Modulation(i) = "QPSK";
        case 4
            Modulation(i) = "16QAM";
        case 6
            Modulation(i) = "64QAM";
        case 8
            Modulation(i) = "256QAM";
    end
end

% Output struct
cqiTable = struct();
cqiTable.CQI                = CQI;
cqiTable.Modulation         = Modulation;
cqiTable.Modulation_Order_Qm= Qm;
cqiTable.Target_CodeRate    = R;
cqiTable.Target_CodeRate_x1024 = R1024;
cqiTable.Spectral_Efficiency_bits_per_Hz = SE;
cqiTable.SNR_Threshold_linear = SNR_linear;
cqiTable.SNR_Threshold_dB     = SNR_dB;



if verbose
T = table( ...
    cqiTable.CQI, ...
    cqiTable.Modulation, ...
    cqiTable.Modulation_Order_Qm, ...
    cqiTable.Target_CodeRate, ...
    cqiTable.Spectral_Efficiency_bits_per_Hz, ...
    cqiTable.SNR_Threshold_dB, ...
    'VariableNames',{ ...
    'CQI_Index', ...
    'Modulation', ...
    'Qm', ...
    'CodeRate', ...
    'SpectralEfficiency', ...
    'SNR_Threshold_dB'});

disp(T)
end

end
