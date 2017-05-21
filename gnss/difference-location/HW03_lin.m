% �I��G GF01
% �էO�G E
% �m�W�G

close all
%% ���J�[���ɤξɯ��� %%
 load('CKSVtoGF01')
 refxyz = [-2956619.164	5075902.221	2476625.544];   % �ۦ��J�Ѧү����Яu��
 usrxyz = [-2956298.724	5075995.153	2476764.627];     % �ۦ��J�ݴ������Яu��
 ref_ant_h =0 ;                                                                      % �ۦ��J�Ѧү��ѽu��
 usr_ant_h =1.375 ;                                                                      % �ۦ��J�ݴ����ѽu��

refplh = xyz2llh(refxyz);
refplh(3)=refplh(3)+ref_ant_h;
refxyz=llh2xyz(refplh);
usrplh = xyz2llh(usrxyz);
usrplh(3)=usrplh(3)+usr_ant_h;
usrxyz=llh2xyz(usrplh);
%% �i��۹�w�� %%
disp(' Performing Double Difference Positioning ... ')
for ep = 1:size(La{1,1}.NSAT(:))
   if La{1,1}.NSAT(ep) >= 4,
       ns = La{1,1}.NSAT(ep);
       for u = 1:ns,
           prn = La{1,1}.IDMAT(ep,u+2);
           svenu = xyz2enu(La{1,1}.SVMAT(u,:,ep)-usrxyz,usrplh);
           el(prn) = (180/pi)*atan(svenu(3)/norm(svenu(1:2)));
           obs(u,:) = [La{1,1}.CODE(u,1,ep),La{1,1}.CODE(u,2,ep)];
           svids(u,:) = [prn,prn];
       end             
       [ddPR,ddprns] = build2d(ns,svids,obs,el);    %ddPR���G���t���᪺�����Z���[���q
       clear svmat drho newo
       for v = 1:length(ddprns),
           prn = ddprns(v);
           if v==1,
               rhoik = norm(La{1,1}.SVMAT(v,:,ep) - refxyz);    %�D�ìP�ܰѦү����Z��
               svmat(1,:) = La{1,1}.SVMAT(v,:,ep);
           else
               rhoil = norm(La{1,1}.SVMAT(v,:,ep) - refxyz);    %�l�ìP�ܰѦү����Z��
               drho(v-1) = rhoik-rhoil;
               svmat(v,:) = La{1,1}.SVMAT(v,:,ep);
           end
       end
        newo = ddPR-drho;
       if length(newo) >= 3,
           estusr = usrxyz;
           nd = length(newo);               %�[���qnewo���Ӽ�
           svref = svmat(1,:);                  %�D�ìP��m
           svdif = svmat(2:end,:);          %�l�ìP��m
           maxiter=10;
           iter=0;
           clear A P y           
            Q=eye(nd);
            W=ones(nd,1);
            k=[W, -Q, -W, Q];
            p=k*k';
            P = inv(p);
           while (iter < maxiter && (iter == 0 || norm(x) > 1e-3)),
                for u = 1:nd,
                    d0k = svref(1,:)-estusr;
                    d0l = svdif(u,:)-estusr;
                    rho0k = norm(d0k);
                    rho0l = norm(d0l);
                     y(u,1) =newo(1,u)-(-rho0k(1,1)+rho0l(1,1)) ;
                     A(u,:) = [d0k/rho0k-d0l/rho0l];
                end,
                 x =inv(A'*P*A)*A'*P*y ;
                estusr = estusr + x';      
                iter = iter + 1;
           end
       end
       enuerr(ep,:) = xyz2enu(estusr(1:3)-usrxyz,usrplh);   
   end
end
%% ---------- �w���׵��� : ����ڻ~�t(RMSE) ------ %%
de = norm(enuerr(:,1));
dn = norm(enuerr(:,2));                     
dh = norm(enuerr(:,3));                    
rmse = sqrt( de*de/ep)
rmsn = sqrt( dn*dn/ep)
rmsu = sqrt( dh*dh/ep)
%% ---------- �w��~�tø�� ------------------- %%
figure(1);
subplot(2,2,1)
plot(enuerr(:,1),enuerr(:,2),'.'),grid
axis('square');axis('equal')
axis([-2 2 -2 2])
title(' DGPS Positioning Error ')
ylabel('dn (m)')
xlabel('de (m)')

subplot(2,2,2)
plot(1:ep,enuerr(:,3),'.'),grid
axis([1 ep -5 5])
title(' DGPS Positioning Error')
ylabel('du (m)')
xlabel('epochs')

subplot(2,2,3)
plot(1:ep,enuerr(:,1),'.'),grid
axis([1 ep -2 2])
title(' DGPS Positioning Error')
ylabel('de (m)')
xlabel('epochs')

subplot(2,2,4)
plot(1:ep,enuerr(:,2),'.'),grid
axis([1 ep -2 2 ])
title(' DGPS Positioning Error')
ylabel('dn (m)')
xlabel('epochs')
%% ----------------- end --------------------- %%