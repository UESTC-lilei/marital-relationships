clear
clc
    marital = [];
    marital_all = [];
    AAl = y_Read('aal.nii');
    path_male = 'G:\lab\structure\T1\male';
    path_female = 'G:\lab\structure\T1\female';
    mask = AAl;
    
    data_path_male = dir(path_male);
    data_path_male(1:2) = [];
    for i=1:length(data_path_male)
        sub_path_male = [path_male,'\',data_path_male(i).name];
        sub_pathpath_male  = dir(sub_path_male);
        sub_pathpath_male(1:2) = [];
        subsub_pathpath_male = [sub_path_male,'\',sub_pathpath_male(3).name];
        mri_path_male = dir(subsub_pathpath_male);
        sub_male = [subsub_pathpath_male,'\',mri_path_male(5).name];
        [data_male,header] = y_Read(sub_male);
        for j = 1:90   %
            index = find(mask==j);
            for k = 1:length(index)
                sub_male_T1_area(k) = data_male(index(k)); 
            end
            T1_AAl_male(i,j) = sum(sub_male_T1_area);
        end
    end
    T1_AAl_male = T1_AAl_male';
    
    
    data_path_female = dir(path_female);
    data_path_female(1:2) = [];
    for i=1:length(data_path_female)
        sub_path_female = [path_female,'\',data_path_female(i).name];
        sub_pathpath_female  = dir(sub_path_female);
        sub_pathpath_female(1:2) = [];
        subsub_pathpath_female = [sub_path_female,'\',sub_pathpath_female(3).name];
        mri_path_female = dir(subsub_pathpath_female);
        sub_female = [subsub_pathpath_female,'\',mri_path_female(5).name];
        [data_female,header] = y_Read(sub_female);
        for j = 1:90   %
            index = find(mask==j);
            for k = 1:length(index)
                sub_female_T1_area(k) = data_female(index(k)); 
            end
            T1_AAl_female(i,j) = sum(sub_female_T1_area);
        end
    end
    T1_AAl_female = T1_AAl_female';
    
    load female_TIV.txt
    load male_TIV.txt
    
    
    TIV_male = male_TIV(:,1);
    TIV_female = female_TIV(:,1);
    

    for j = 1:90 %
         [r_male(j,:),b,stats] = regress_out(T1_AAl_male(j,:)',TIV_male);
    end
   
    for j = 1:90 %
         [r_female(j,:),b,stats] = regress_out(T1_AAl_female(j,:)',TIV_female);
    end 
    
    for i = 1:90
       [h,p(i)] = ttest2(r_female(i,:),r_male(i,:));
    end
    [h,p] = ttest2(TIV_female,TIV_male);
p = p'