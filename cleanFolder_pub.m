function cleanFolder_pub(pHome)
addpath('/Users/connylin/Dropbox/Code/Matlab/Library/General');

fprintf('cleaning %s/n',pHome);
% pHome = '/Users/connylin/Dropbox/RL/Publication';
[filename,pfile,foldername,pfolder] = dircontent(pHome);

% look for correct format date - name
str = '^20\d{6}\s{1}\w{1,}';
i = regexpcellout(filename,str);
% filename(~i)
pIssue = pfile(~i);
file_issue = filename(~i);

for ifix = 1:numel(file_issue)
    clear name_correct

    pf = pIssue{ifix};
    fn = file_issue{ifix};
    fprintf('file name: %s\n',fn);
    
    %% fixes
    if isempty(regexp(fn,'20\d{2}')) == 1
        % no dates start with 20dd
        name_correct = ['00000000 ',char(fn)];
    else
        % numeric start with 20dd
         
        % 20dddddd (wrong position)
        if isempty(regexp(fn,'20\d{6}')) == 0
            str = '20\d{6}';
            parts_incorrect = regexp(fn,str,'match');
            parts_fixed = {strjoin([regexprep(parts_incorrect,'-','')],'')};
            parts_left = regexp(fn,str,'split');
            parts_left_fixed = strjoin(regexprep(parts_left,'\s\>',''),'');
            name_correct = strjoin([parts_fixed parts_left_fixed],' ');
        
        
        else
            % 20dd-dd-dd full date with dashes
            if isempty(regexp(fn,'20\d{2}-\d{2}-\d{2}')) == 0
                str = '20\d{2}-\d{2}-\d{2}';
                parts_incorrect = regexp(fn,str,'match');
                parts_fixed = regexprep(parts_incorrect,'-','');
                parts_left = regexp(fn,str,'split');
                parts_left_fixed = strjoin(regexprep(parts_left,'\s\>',''),'');
                if isempty(regexp(fn,'^20\d{2}-\d{2}-\d{2}')) == 1
                    name_correct = strjoin([parts_fixed parts_left_fixed],' ');
                else
                    name_correct = strjoin([parts_fixed parts_left_fixed],'');
                end

            % 20dd-dd no date
            elseif isempty(regexp(fn,'20\d{2}-\d{2}')) == 0 ...
                    && isempty(regexp(fn,'20\d{6}')) == 1 ...
                    && isempty(regexp(fn,'20\d{2}-\d{2}-\d{2}')) == 1
                str = '20\d{2}-\d{2}';
                parts_incorrect = regexp(fn,str,'match');
                parts_fixed = {strjoin([regexprep(parts_incorrect,'-',''),'00'],'')};
                parts_left = regexp(fn,str,'split');
                parts_left_fixed = strjoin(regexprep(parts_left,'\s\>',''),'');
                name_correct = strjoin([parts_fixed parts_left_fixed],' ');

            % 20dd (year only)
            elseif isempty(regexp(fn,'20\d{2}')) == 0 ...
                    && isempty(regexp(fn,'20\d{6}')) == 1 ...
                    && isempty(regexp(fn,'20\d{2}-\d{2}-\d{2}')) == 1
                str = '20\d{2}';
                parts_incorrect = regexp(fn,str,'match');
                parts_fixed = {strjoin([regexprep(parts_incorrect,'-',''),'0000'],'')};
                parts_left = regexp(fn,str,'split');
                parts_left_fixed = strjoin(regexprep(parts_left,'\s\>',''),'');
                name_correct = strjoin([parts_fixed parts_left_fixed],' ');
            end
        end
    end 
    
    %% change name
    fprintf('correct name: %s\n',name_correct);
    fprintf('[enter] to continue \n');
    pause;
    ps = pf;
    pd = regexprep(ps,fn,name_correct);
    % check if already duplicated files
    [~,p] = dircontent(pHome);
    if sum(ismember(p,pd)) > 0
        warning('same file name exist, [enter] to continue');
        pause;
    end
    movefile(ps,pd)
end


