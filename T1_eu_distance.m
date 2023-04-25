clear
clc

    load marital.txt
    AAl = y_Read('aal.nii');
    path = 'D:\couple_similar\structure\T1\T1_co';
    mask = AAl;
    data_path = dir(path);
    data_path(1:2) = [];
    number = 90;%
    
    for i=1:length(data_path)
        sub_path = [path,'\',data_path(i).name];
        sub_pathpath  = dir(sub_path);
        sub_pathpath(1:2) = [];
        subsub_pathpath = [sub_path,'\',sub_pathpath(3).name];
        mri_path = dir(subsub_pathpath);
        sub = [subsub_pathpath,'\',mri_path(5).name];
        [data,header] = y_Read(sub);
        for j = 1:number   %
            index = find(mask==j);
            for k = 1:length(index)
                sub_T1_area(k) = data(index(k)); 
            end
            T1_AAl(i,j) = sum(sub_T1_area);
        end
    end
    T1_AAl = T1_AAl';
    Y = T1_AAl;
    [m,n] = size(Y');
    Y = Y';
load All_TIV.mat
load all_covariable.txt
TIV = All_TIV(:,1);


all_covariable(:,3) = TIV;


%
for i = 1:n
[r_eu(:,i),b,stats] = regress_out(Y(:,i),all_covariable);
end
%% 

 k=1;
for i = 1:2:m-1
    Eu_D(k) = pdist2(r_eu(i,:),r_eu(i+1,:));
    k=k+1;
end

Eu_D = Eu_D';

[r_eu,p_eu]=corr(Eu_D,marital);

[m_sati] = find(marital > 60);
[m_unsati] = find(marital < 60);
Eu_D_mati = Eu_D(m_sati,:);
mean_Eu_mati = mean(Eu_D_mati);
mean_Eu_mati = mean_Eu_mati';
Eu_D_unmati = Eu_D(m_unsati,:);
mean_Eu_unmati = mean(Eu_D_unmati);
mean_Eu_unmati = mean_Eu_unmati';

[h,p] = ttest2(Eu_D_mati,Eu_D_unmati);
%% 

k=1;
for i = 1:2:m-1
    for j = 1 : number %
       Eu_D(k,j) = pdist2(r_eu(i,j),r_eu(i+1,j));
       
    end
    k=k+1;
end

for i = 1:number
[rr_eu(i),p_eu(i)]=corr(Eu_D(:,i),marital);
end

rr_eu = rr_eu';


[m_sati] = find(marital > 60);
[m_unsati] = find(marital < 60);
Eu_D_mati = Eu_D(m_sati,:);
mean_Eu_mati = mean(Eu_D_mati);
mean_Eu_mati = mean_Eu_mati';
Eu_D_unmati = Eu_D(m_unsati,:);
mean_Eu_unmati = mean(Eu_D_unmati);
mean_Eu_unmati = mean_Eu_unmati';

for i = 1:number
[h(i),p(i)] = ttest2(Eu_D_mati(:,i),Eu_D_unmati(:,i));
end

%%

% 
k = 1;
for i = 1:2:n-1
    for j = 1:m
        value(j,k) = abs(r_eu(j,i) - r_eu(j,i+1));
    
    end
    k = k+1;
end
for i = 1:m
    [r_chazhi(i),p_chazhi(i)] = corr(value(i,:)',marital);
end



%
sati = value(:,m_sati);
unsati = value(:,m_unsati);


m=90;
for i = 1:m
   [h(i),p(i)] = ttest2(sati(i,:),unsati(i,:));
end