%%%%%%%%%%%%%%
% This file will take a look at active data
% It will count how many times the participant answered each of the
% questionnaires
%%%%%%%%%%%%%%

%% Pre-face material

clear; clc; close all;
format long;

%% Import Data
path = '/Users/binhnguyen/Downloads/Participant Data/';

subjects = cell (1,8);
subjects{1} = 'U0099725385';
subjects{2} = 'U0571781825';
subjects{3} = 'U1320514293';
subjects{4} = 'U1431916954';
subjects{5} = 'U3354287398';
subjects{6} = 'U6404631153';
subjects{7} = 'U7529931256';
subjects{8} = 'U7835074301';
subjects{8} = 'U7835074301';
subjects{9} = 'U8509049816';
subjects{10}= 'U8920175053';

subject = 1;

filename = strcat (path, subjects{subject},'/result_event.json');


%% Load the file
fid = fopen(filename); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 

active_data = jsondecode(str);

%% Preprocessing
% Re-order timestamps in sensor
% sensor_data = sortrows(sensor_data,'timestamp');

% Saving active data timestamps to file
n_len = length (active_data);

active_timestamp = zeros (1,n_len);
active_activity = cell (1,n_len);
for i = 1:n_len
    active_timestamp (i) = active_data(i).timestamp;
    active_activity {i} = active_data(i).activity;
end

% Questionnaire legend 
q_legend = questionnaire_legend ();


% Find index of different questionnaires
q_indicies = cell (10,1);
for i = 1:10
    q_indicies{i} = find(contains(active_activity,q_legend{i,1}));
end


%% Display the table

fprintf('Subject %s \n', subjects{subject})

% Q indicies
for i = 1:length (q_indicies)
   Questionnaire_Answered (i) =  length (q_indicies{i});
end

% Legend
Legend  = [string(q_legend (1,2))]
for i = 2:length (q_indicies)
   Legend = [Legend;string(q_legend (i,2))]; 
end

% Summing
Legend = [Legend; "Total"]
Questionnaire_Answered(end +1) = sum(Questionnaire_Answered(1:end))

table_analysis = table(Legend,transpose (Questionnaire_Answered));


%% Display everything

fprintf('Subject %s \n', subjects{subject})
table_analysis
