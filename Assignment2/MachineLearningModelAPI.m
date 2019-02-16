clc;
clear;
[PCG_abnormal, fs] = audioread('unknown.wav');
p_abnormal = audioplayer(PCG_abnormal, fs);
play(p_abnormal, [1 (get(p_abnormal, 'SampleRate') * 3)]);
% Plot the sound waveform
plot(PCG_abnormal(1:fs*3))
signalAnalyzer(PCG_abnormal)
training_fds = fileDatastore(fullfile(pwd, 'Data', 'new'), 'ReadFcn', @importAudioFile, 'FileExtensions', '.wav', 'IncludeSubfolders', 1);
data_dir = fullfile(pwd, 'Data', 'new');
folder_list = dir([data_dir filesep 'new*']);
reference_table = table();
for ifolder = 1:length(folder_list)
    disp(['Processing files from folder: ' folder_list(ifolder).name])
    current_folder = [data_dir filesep folder_list(ifolder).name];
    
    % Import ground truth labels (1, -1) from reference. 1 = Normal, -1 = Abnormal
    reference_table = [reference_table; importReferencefile([current_folder filesep 'REFERENCE.csv'])];
end

if ~exist('FeatureTable.mat')%#ok 
    % Window length for feature extraction in seconds
    win_len = 5;
    
    % Specify the overlap between adjacent windows for feature extraction in percentage
    win_overlap = 0;
    
    % Initialize feature table to accumulate observations
    feature_table = table();
    
    % Use Parallel Computing Toobox to speed up feature extraction by distributing computation across available processors
    
    % Create partitions of the fileDatastore object based on the number of processors
    n_parts = numpartitions(training_fds, gcp);
    
    % Distribute computation across available processors by using parfor
    parfor ipart = 1:n_parts
        % Get partition ipart of the datastore.
        subds = partition(training_fds, n_parts, ipart);
        
        % Extract features for the sub datastore
        feature_table = [feature_table; extractFeatures(subds, win_len, win_overlap, reference_table)];
        
        % Display progress
        disp(['Part ' num2str(ipart) ' done.'])
    end
    save('FeatureTable', 'feature_table');
else % simply load the precomputed features
    load('FeatureTable.mat');
end
% Take a look at the feature table
disp(feature_table(1:5,:))

rng(1)
% Use 30% of data for training and remaining for testing
split_training_testing = cvpartition(feature_table.class, 'Holdout', 0.3       );
% Create a training set
training_set = feature_table(split_training_testing.training, :);
% Create a test set (won't be used until much later)
testing_set = feature_table(split_training_testing.test, :);
grpstats_training = grpstats(training_set, 'class', 'mean');
disp(grpstats_training(:,'GroupCount'))

% Assign higher cost for misclassification of abnormal heart sounds
C = [0, 20; 1, 0];
% Create a random sub sample (to speed up training) from the training set
%subsample = randi([1 height(training_set)], round(height(training_set)/4), 1);
subsample = 1:height(training_set);
rng(1);
% Create a 5-fold cross-validation set from training data
cvp = cvpartition(length(subsample),'KFold',5);
if ~exist('TrainedEnsembleModel.mat')%#ok
    % perform training only if we don't find a saved model
    % train ensemble of decision trees (random forest)
    disp("Training Ensemble classifier...")
    
    % bayesian optimization parameters (stop after 15 iterations)
    opts = struct('Optimizer','bayesopt','ShowPlots',true,'CVPartition',cvp,...
            'AcquisitionFunctionName','expected-improvement-plus','MaxObjectiveEvaluations',15);    
    trained_model = fitcensemble(training_set(subsample,:),'class','Cost',C,...
        'OptimizeHyperparameters',{'Method','NumLearningCycles','LearnRate'},...
        'HyperparameterOptimizationOptions',opts)
    save('TrainedEnsembleModel', 'trained_model');
else
    % load previously saved model
    load('TrainedEnsembleModel.mat')
end
% Predict class labels for the validation set using trained model
% NOTE: if training ensemble without optimization, need to use trained_model.Trained{idx} to predict
predicted_class = predict(trained_model, testing_set);
conf_mat = confusionmat(testing_set.class, predicted_class);
conf_mat_per = conf_mat*100./sum(conf_mat, 2);
% Visualize model performance in heatmap
labels = {'Music', 'Normal'};
heatmap(labels, labels, conf_mat_per, 'Colormap', winter, 'ColorbarVisible','off');