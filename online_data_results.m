clearvars; clc;
selected_frequencies = (4:2:48)';
channel_labels  = {'Fz', 'FC3', 'FC1', 'FCz', 'FC2', 'FC4', 'C3', 'C1', 'Cz', 'C2', 'C4', 'CP3', 'CP1', 'CPz', 'CP2', 'CP4'};
patients = find_patients('data');
classifiers_fold_root = '../classifiers/';
results_fold_root = '../online-results/';

out_filename = 'patients_online_results.xlsx';

NAMES = {};
SSA = [];
SSA_BF = [];
SSA_BH = [];

% Moving average
P_ACT_MOV = [];
P_REJ_MOV = [];
P_ACT_MOV_TEST = [];
P_REJ_MOV_TEST = [];
ALPHA_MOV = [];
T_BH_MOV = [];
T_BF_MOV = [];

% Exponential Smoothing
P_ACT_EXP = [];
P_REJ_EXP = [];
P_ACT_EXP_TEST = [];
P_REJ_EXP_TEST = [];
ALPHA_EXP = [];
T_BH_EXP = [];
T_BF_EXP = [];

% Dynamic force
P_ACT_DYN = [];
P_REJ_DYN = [];
P_ACT_DYN_TEST = [];
P_REJ_DYN_TEST = [];
ALPHA_DYN = [];
BETA_DYN = [];
AMP_DYN = [];
W_DYN = [];
T_BH_DYN = [];
T_BF_DYN = [];

for p = 1:length(patients)
    patient = patients{p}.name;
    NAMES{p, 1} = patient;
    SSA(p, 1) = load(strcat(results_fold_root, patient, '_single_sample')).accuracy;    
    SSA_BF(p, 1) = load(strcat(results_fold_root, patient, '_single_sample')).accuracy_per_class(1);
    SSA_BH(p, 1) = load(strcat(results_fold_root, patient, '_single_sample')).accuracy_per_class(2);
    
    % Load accuracy and params
    load(strcat(results_fold_root, patient, '_online_tuning_ev_acc'));
    load(strcat(results_fold_root, patient, '_online_tuning_params'));
    
    % Load parameters
    P_ACT_MOV(p, 1) = perf_active_mov;
    P_REJ_MOV(p, 1) = perf_active_rej_mov;
    ALPHA_MOV(p, 1) = mov_param.alpha;
    T_BH_MOV(p, 1) = mov_param.up_threshold;
    T_BF_MOV(p, 1) = mov_param.down_threshold;

    % Exponential Smoothing
    P_ACT_EXP(p, 1) = perf_active_ex;
    P_REJ_EXP(p, 1) = perf_active_rej_ex;
    ALPHA_EXP(p, 1) = exp_param.alpha;
    T_BH_EXP(p, 1) = exp_param.up_threshold;
    T_BF_EXP(p, 1) = exp_param.down_threshold;

    % Dynamic force
    P_ACT_DYN(p, 1) = perf_active_dyn;
    P_REJ_DYN(p, 1) = perf_active_rej_dyn;
    ALPHA_DYN(p, 1) = dyn_param.alpha;
    BETA_DYN(p, 1) = dyn_param.beta;
    AMP_DYN(p, 1) = dyn_param.amp;
    W_DYN(p, 1) = dyn_param.w;
    T_BH_DYN(p, 1) = dyn_param.up_threshold;
    T_BF_DYN(p, 1) = dyn_param.down_threshold;
    
    load(strcat(results_fold_root, patient, '_online_tuning_test_ev_acc'));
    
    P_ACT_MOV_TEST(p, 1) = perf_active_mov;
    P_REJ_MOV_TEST(p, 1) = perf_active_rej_mov;
    P_ACT_EXP_TEST(p, 1) = perf_active_ex;
    P_REJ_EXP_TEST(p, 1) = perf_active_rej_ex;
    P_ACT_DYN_TEST(p, 1) = perf_active_dyn;
    P_REJ_DYN_TEST(p, 1) = perf_active_rej_dyn;
end

NAMES{end+1, 1} = 'AVG';
SSA(end+1, 1) = mean(SSA);
SSA_BF(end+1, 1) = mean(SSA_BF);
SSA_BH(end+1, 1) = mean(SSA_BH);

P_ACT_MOV(end+1, 1) = mean(P_ACT_MOV);
P_REJ_MOV(end+1, 1) = mean(P_REJ_MOV);
P_ACT_MOV_TEST(end+1, 1) = mean(P_ACT_MOV_TEST);
P_REJ_MOV_TEST(end+1, 1) = mean(P_REJ_MOV_TEST);
ALPHA_MOV(end+1, 1) = mean(ALPHA_MOV);
T_BH_MOV(end+1, 1) = mean(T_BH_MOV);
T_BF_MOV(end+1, 1) = mean(T_BF_MOV);

P_ACT_EXP(end+1, 1) = mean(P_ACT_EXP);
P_REJ_EXP(end+1, 1) = mean(P_REJ_EXP);
P_ACT_EXP_TEST(end+1, 1) = mean(P_ACT_EXP_TEST);
P_REJ_EXP_TEST(end+1, 1) = mean(P_REJ_EXP_TEST);
ALPHA_EXP(end+1, 1) = mean(ALPHA_EXP);
T_BH_EXP(end+1, 1) = mean(T_BH_EXP);
T_BF_EXP(end+1, 1) = mean(T_BF_EXP);

P_ACT_DYN(end+1, 1) = mean(P_ACT_DYN);
P_REJ_DYN(end+1, 1) = mean(P_REJ_DYN);
P_ACT_DYN_TEST(end+1, 1) = mean(P_ACT_DYN_TEST);
P_REJ_DYN_TEST(end+1, 1) = mean(P_REJ_DYN_TEST);
ALPHA_DYN(end+1, 1) = mean(ALPHA_DYN);
BETA_DYN(end+1, 1) = mean(BETA_DYN);
AMP_DYN(end+1, 1) = mean(AMP_DYN);
W_DYN(end+1, 1) = mean(W_DYN);
T_BH_DYN(end+1, 1) = mean(T_BH_DYN);
T_BF_DYN(end+1, 1) = mean(T_BF_DYN);

T = table(NAMES, SSA, SSA_BF, SSA_BH);
T_MOV = table(NAMES,P_ACT_MOV,P_REJ_MOV,P_ACT_MOV_TEST,P_REJ_MOV_TEST,ALPHA_MOV,T_BH_MOV,T_BF_MOV);
T_EXP = table(NAMES,P_ACT_EXP,P_REJ_EXP,P_ACT_EXP_TEST,P_REJ_EXP_TEST,ALPHA_EXP,T_BH_EXP,T_BF_EXP);
T_DYN = table(NAMES,P_ACT_DYN,P_REJ_DYN,P_ACT_DYN_TEST,P_REJ_DYN_TEST,ALPHA_DYN,BETA_DYN,AMP_DYN,W_DYN,T_BH_DYN,T_BF_DYN);

writetable(table({'Single Sample'}), out_filename, 'Sheet', 1, 'Range', 'A1');
writetable(T, out_filename, 'Sheet', 1, 'Range', 'A2');

writetable(table({'Moving Average'}), out_filename, 'Sheet', 2, 'Range', 'A1');
writetable(T_MOV, out_filename, 'Sheet', 2, 'Range', 'A2');

writetable(table({'Exponential Smoothing'}), out_filename, 'Sheet', 3, 'Range', 'A1');
writetable(T_EXP, out_filename, 'Sheet', 3, 'Range', 'A2');

writetable(table({'Dynamic Force'}), out_filename, 'Sheet', 4, 'Range', 'A1');
writetable(T_DYN, out_filename, 'Sheet', 4, 'Range', 'A2');