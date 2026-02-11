function cqiTable = nrCQITables_Manual(tableID, verbose)
% nrCQITables
% Retorna as tabelas oficiais de CQI da 3GPP TS 38.214
%
% tableID:
%   1 → Table 5.2.2.1-1 (até 64QAM)
%   2 → Table 5.2.2.1-2 (até 256QAM – eMBB)
%   3 → Table 5.2.2.1-3 (até 256QAM – robusta)
%
% verbose:
%   true  → imprime tabela formatada
%   false → não imprime

if nargin < 2
    verbose = false;
end

CQI = (0:15)';

switch tableID

    % ==============================================================
    case 1
        % 3GPP TS 38.214 - Table 5.2.2.1-1
        % Cenário: até 64QAM (configuração padrão)

        Qm = [0;2;2;2;4;4;4;6;6;6;6;6;6;6;6;6];
        R1024 = [0;78;193;449;378;490;616;466;567;666;772;873;948;948;948;948];

    % ==============================================================
    case 2
        % 3GPP TS 38.214 - Table 5.2.2.1-2
        % Cenário: 256QAM habilitado (eMBB alta taxa)

        Qm = [0;2;2;2;4;4;4;6;6;6;6;6;8;8;8;8];
        R1024 = [0;78;193;449;378;490;616;466;567;666;772;873;711;797;885;948];

    % ==============================================================
    case 3
        % 3GPP TS 38.214 - Table 5.2.2.1-3
        % Cenário: perfil mais robusto

        Qm = [0;2;2;2;2;4;4;4;6;6;6;6;6;8;8;8];
        R1024 = [0;78;120;193;308;449;602;378;490;616;466;567;666;772;873;948];

    otherwise
        error('tableID deve ser 1, 2 ou 3');
end

% ==============================================================
% Cálculos
% ==============================================================

CodeRate = R1024 / 1024;
SpectralEfficiency = Qm .* CodeRate;

% SNR aproximado via Shannon
SNR_linear = 2.^SpectralEfficiency - 1;
SNR_dB = 10*log10(SNR_linear);
SNR_dB(1) = -Inf; % CQI 0

% Nome da modulação
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

% ==============================================================
% Tabela final
% ==============================================================

cqiTable = table( ...
    CQI, ...
    Modulation, ...
    Qm, ...
    CodeRate, ...
    R1024, ...
    SpectralEfficiency, ...
    SNR_dB, ...
    'VariableNames', { ...
    'CQI', ...
    'Modulation', ...
    'Modulation_Order_Qm', ...
    'Target_CodeRate', ...
    'Target_CodeRate_x1024', ...
    'Spectral_Efficiency_bits_per_Hz', ...
    'SNR_Threshold_dB'});

% ==============================================================
% Impressão controlada por verbose
% ==============================================================

if verbose
    disp(cqiTable)
end

end
