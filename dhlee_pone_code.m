load adhd_dat.mat 
addpath /Users/dhlee/projects/NYC/dhlee_code/revision_1st/combat/
batch = floor([rt1])';%[1 1 1 1 1 2 2 2 2 2]; %Batch variable for the scanner id

dat=dmn'; % 1 coupling x 201 subjects 
age = age1;%[82 70 68 66 80 69 72 76 74 80]'; % Continuous variable
sex = sex1;
disease = [ones(1,56) ones(1,70)*2 ones(1,75)*3]';%%[1 2 1 2 1 2 1 2 1 2]'; % Categorical variable
% disease = dummyvar(disease);
mod = [age sex disease];%[age disease(:,2)];
size(mod)
size(dat)
size(batch)

data_harmonized = combat(dat, batch, mod, 0);
data_harmonized=data_harmonized';


ridx=1 %1:coupling 2:SC ge, 3:FC ge
for i=1:max(grp)
    id=find(grp==i);
    if i==1
        cva=data_harmonized(1:56,ridx); ;str='ND vs ADHDC';
    elseif i==2
        cva=data_harmonized(57:126,ridx);str='ND vs ADHDI';
    elseif i==3
        cva=data_harmonized(127:end,ridx); str='ADHDC vs ADHDI';
    end
    fprintf('Coupling:%s, mean=%0.4f�%0.4f\n',str,...
        mean(cva),std(cva)/sqrt(length(cva)));
end

[psf,tablesf,statsf,termssf]=anovan(data_harmonized(:,ridx),{grp1 age1 sex1},'continuous',[2],'varnames',{'grp',  'age','sex'});
[c,m,h,nms] = multcompare(statsf,'display','off');
for i=1:size(c,1), if c(i,6)<0.05, fprintf('[SCFC]RESULT:!!Coupling of %s and %s differs by %f with p=%4.3f\n',nms{c(i,1)},nms{c(i,2)},c(i,4),c(i,6)); end; end
for i=1:size(c,1), if 1, fprintf('[SCFC]RESULT:!!Coupling of %s and %s differs by %f with p=%4.4f\n',nms{c(i,1)},nms{c(i,2)},c(i,4),c(i,6)); end; end


