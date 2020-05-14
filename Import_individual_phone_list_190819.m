
p = '/Users/connylin/Dropbox/CA CPC Jay Shin 2019/Analysis';
p = fullfile(p,'individual phone.csv');
filename = p;

% prepare format string
% need 120 %s
clear a
a(1:120,1) = {'%s'};
a = a';
a = strjoin(a','');
a = [a,'%[^\n\r]'];
formatStr = a;

%% import files
% get data
fid = fopen(filename,'r');
% formatStr = '%s%s%d%d%f%f%s%[^\n\r]';
dataArray = textscan(fid, formatStr, 'Delimiter', ',', ...
            'HeaderLines', 2-1, 'ReturnOnError', false);
fclose(fid); % Close the text file.
dataArray(end) = [];   
% find which colum is which format
i = regexp(formatStr,'[%]');
formatcode = formatStr(i+1);
formatcode(end) = [];
formatcode = formatcode';

%% import header
fid = fopen(filename,'r');
% dataHeader = textscan(fid, formatStrH, 1, 'Delimiter', '\t', 'ReturnOnError', false);
dataHeader = textscan(fid, formatStr, 1, 'Delimiter', '\t', 'ReturnOnError', false);
fclose(fid); % Close the text file.

%% process header
dataHeader = dataHeader{1}; % take it out of the nested cell
a = dataHeader;
a = regexprep(a,'"','');
a = regexprep(a,'[,]','$');
a = regexprep(a,'[^a-zA-Z_0-9_$]','');
a = regexprep(a,'[$]',',');
dataHeader = a;
str = a;
delimiter = ',';
dataHeader = split(str,delimiter);

%% error catch
if numel(dataArray) ~= numel(dataHeader)
   error('size of data array and header do not match') 
end

%%
dataHeader

%% put int table
T = table;
for fi = 1:numel(dataHeader)
   T.(dataHeader{fi}) = dataArray{fi};
end

b = cellfun(@numel,dataArray)';
c = repmat(8250,size(b));
sum(b-c)

%%


return







