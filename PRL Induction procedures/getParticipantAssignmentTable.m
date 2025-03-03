function [tt,site] = getParticipantAssignmentTable(SUBJECT)
% this function takes in the SUBJECT name.  The second character in the
% name gives which site it is run at.  m is an MD subject
% n is for northeastern
% b is for UAB
% r is for UCR
% outputs a struct with that participant's TRL, Eye, etc, as noted in the
% csv file for that study.
% written by kmv; Nov 5, 2024


if SUBJECT(2) == 'm'
    % it's an MD subject, and we have to choose the PRL locations wisely
    % first, load the PRL locations:
    participantAssignmentTable = fullfile(cd, ['..\..\datafolder\MDParticipantAssignmentsUAB.csv']); % this is set for UCR or UAB separately (This is set here so that definesite.m does not have to change)
    site = 3;
elseif SUBJECT(2) =='b'
    participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsUAB_corr.csv']); % uncomment this if running task at UAB
    site = 3;
elseif SUBJECT(2) == 'r'
    participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsUCR_corr.csv']); % this is set for UCR or UAB separately (This is set here so that definesite.m does not have to change)
    site = 3;
elseif SUBJECT(2) =='n'
    participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsNEU_corr.csv']); % uncomment this if running task at UAB
    site = 8;
    
else
    participantAssignmentTable = fullfile(cd, ['..\..\datafolder\ParticipantAssignmentsNEU_corr.csv']); % then it's automatically picking this one up.  for testing.
    'WARNING: YOU ARE RUNNING A TEST PARTICIPANT, NOT FROM A TABLE OF PARTICIPANT INFORMATION'
    site = 8;
end

temp= readtable(participantAssignmentTable);
if site == 8
    temp.Properties.VariableNames{1} = strrep(temp.Properties.VariableNames{1}, 'x___', '');
end
tt = temp(find(contains(temp.participant,SUBJECT)),:); % if computer doesn't have excel it reads as a struct, else it reads as a table
% end load appropriate assignment table % edited by kmv and pd 20241105

