function [] = plotCorrelation_CI_doubleparameter_ft(tvp,tvp2,plotfname,testfeatNo)


Plot_No1=testfeatNo(1);Plot_No2=testfeatNo(2);





% to remove "NaN" array from calculation in case some exist
tvp(find(isnan(tvp(:,2))),:) = []; tvp2(find(isnan(tvp(:,2))),:) = []; 



%tvp(:,2) predicted variable, tvp(:,1) true varaible
NMAE = mean(abs(tvp(:,2)-tvp(:,1))./tvp(:,1))*100;
RMSE = sqrt(mean((tvp(:,2)-tvp(:,1)).^2))/mean(tvp(:,1));
NRMSE=sqrt(mean((tvp(:,2)-tvp(:,1)).^2))/(max(tvp(:,1))-min(tvp(:,1)));
SDR= sqrt(mean((tvp(:,2)-tvp(:,1)-mean(tvp(:,2))+mean(tvp(:,1))).^2));
R = corrcoef(tvp(:,2),tvp(:,1));
[RHO,PVAL] = corr(tvp(:,2)/max(tvp(:,2)),tvp(:,1)/max(tvp(:,1)),'Type','Spearman');
% IA = 1 - mean((tvp(:,2)-tvp(:,1)).^2)/max(mean((abs(tvp(:,2)-mean(tvp(:,1)))+abs(tvp(:,1)-mean(tvp(:,1)))).^2),eps);
IA = 1 - sum((tvp(:,2)-tvp(:,1)).^2)/sum((abs(tvp(:,2)-mean(tvp(:,1)))+abs(tvp(:,1)-mean(tvp(:,1)))).^2);

% CorrectnessTol=mean((abs(tvp(:,2)-tvp(:,1))<tol)*100);
% Correctness=mean((abs(tvp(:,2)-tvp(:,1))<NMAE)*100);
ExVar=1-var(tvp(:,1)-tvp(:,2),1)/var(tvp(:,1),1);
Rn = corrcoef(tvp(:,2)/max(tvp(:,2)),tvp(:,1)/max(tvp(:,1)));


%tvp(:,2) Estimated variable, tvp(:,1) true varaible
NMAE2 = mean(abs(tvp2(:,2)-tvp2(:,1))./tvp2(:,1))*100;
RMSE2 = sqrt(mean((tvp2(:,2)-tvp2(:,1)).^2))/mean(tvp2(:,1));
SDR2= sqrt(mean((tvp2(:,2)-tvp2(:,1)-mean(tvp2(:,2))+mean(tvp2(:,1))).^2));
R2 = corrcoef(tvp2(:,2),tvp2(:,1));
[RHO2,PVAL2] = corr(tvp2(:,2)/max(tvp2(:,2)),tvp2(:,1)/max(tvp2(:,1)),'Type','Spearman');
IA2 = 1 - mean((tvp2(:,2)-tvp2(:,1)).^2)/max(mean((abs(tvp2(:,2)-mean(tvp2(:,1)))+abs(tvp2(:,1)-mean(tvp2(:,1)))).^2),eps);
% CorrectnessTol=mean((abs(tvp(:,2)-tvp(:,1))<tol)*100);
% Correctness=mean((abs(tvp(:,2)-tvp(:,1))<NMAE)*100);
ExVar2=1-var(tvp2(:,1)-tvp2(:,2),1)/var(tvp2(:,1),1);
Rn2 = corrcoef(tvp2(:,2)/max(tvp2(:,2)),tvp2(:,1)/max(tvp2(:,1)));

nameFolder='Aug_28_Mon_ft_direct';
if (exist(char(nameFolder),'dir') == 0); mkdir(char(nameFolder)); end;
Namepdf = strcat(nameFolder,'/',plotfname,'.pdf');
NameJPG = strcat(nameFolder,'/',plotfname);
Nametxt = strcat(nameFolder,'/',plotfname,'.txt');


% if (exist(char('test'),'dir') == 0); mkdir(char('test')); end;
% Namepdf = strcat('test','/',plotfname,'.pdf');
% NameJPG = strcat('test','/',plotfname);
% Nametxt = strcat('test','/',plotfname,'.txt');


fid = fopen(Nametxt,'w');

fprintf(fid,'Accuracy Performance of first model\n');
fprintf(fid,'\t RSpearman \t NMAE \t RMSE \t SDR \t R \t IA \t Rn \t ExplVarSco \n');
fprintf(fid, '\t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f\t %2.2f \t %2.2f \n',RHO,NMAE,RMSE,SDR,R(2),IA,Rn(2),ExVar) 

fprintf(fid,'Accuracy Performance of second model\n');
fprintf(fid,'\t RSpearman \t NMAE \t RMSE \t SDR \t R \t IA \t Rn \t ExplVarSco \n');
fprintf(fid, '\t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f \t %2.2f\t %2.2f \t %2.2f \n',RHO2,NMAE2,RMSE2,SDR2,R2(2),IA2,Rn2(2),ExVar2) 

close(ancestor(fid, 'figure'))









%set plot limits
xmin = min(tvp(:,1));
xmax = max(tvp(:,1));
ymin = min(tvp(:,2));
ymax = max(tvp(:,2));
 plotmin = min(xmin,ymin); % 
%  plotmin=0;

plotmax = max(xmax,ymax);
% plotmax =2.5;




%find limits for linear fit (equation forced through origin)
A=tvp(:,1); % id=find(A>0); A=A(id) %A=A-xmin%
B=tvp(:,2); %B=B(id) %B=B-ymin%



m=sum(A.*B)/sum(A.^2);
mx = [plotmin,plotmax]; % 
% mx = [0,plotmax];
my = [plotmin*m,plotmax*m]; %
% my = [0,plotmax*m];




%plot scatter and trendlines (and 45 degree correlation) d
% plot(tvp(:,1),tvp(:,2),'k*','markers',7).
c=abs(tvp2(:,1)-tvp2(:,2));
% c=abs(B-A);

scatter(tvp(:,1),tvp(:,2),60,c,'filled')
% scatter(A,B,60,c,'filled')

hcb=colorbar
colorTitleHandle = get(hcb,'Title');

% colormap(flipud(hot))
hold on
plot(mx,my,'k')
hold on 
plot([plotmin,plotmax],[plotmin,plotmax],'--k')  % plot([0,plotmax],[0,plotmax],'--k')
% plot([0,plotmax],[0,plotmax],'--k')
hold on 



xlim([plotmin plotmax]);
ylim([plotmin plotmax]);
% ylim([0 1.31]);

% set(gca,'XTick',plotmin:tol:plotmax)
% set(gca,'YTick',plotmin:tol:plotmax)
size=17;

if Plot_No1==24
  xlabel('True shear Stress (Mpa)','fontsize',size);
  ylabel('Estimated shear Stress (Mpa)','fontsize',size);
  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval','deflection ratio');
elseif Plot_No1==25
   xlabel('True shear strain (1e-3)','fontsize',size);
  ylabel('Estimated shear strain (1e-3)','fontsize',size);  
  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval','shearforce(kN)');


elseif Plot_No1==27
   xlabel('True failure ratio (shear stress/ultimate shear stress)','fontsize',size);
  ylabel('Estimated failure ratio (shear stress/ultimate shear stress)','fontsize',size);    
   NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval','failure');
   
elseif Plot_No1==28
   xlabel('True failure ratio (shear strain/ultimate shear strain)','fontsize',size);
  ylabel('Estimated failure ratio (shear strain/ultimate shear strain)','fontsize',size);    
   NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval','failure');
 
   elseif Plot_No1==29
  xlabel('True scaled shear stress   (\tau_{xy}/f_t) ','fontsize',size);
  ylabel('Estimated scaled shear stress (\tau_{xy}/f_t) ','fontsize',size);  

  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval');
  
     elseif Plot_No1==30
  xlabel('True maximum shear stress   (\tau_{max}) (MPa) ','fontsize',size);
  ylabel('Estimated maximum shear stress (\tau_{max}) (Mpa) ','fontsize',size);  
  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval');
  
     elseif Plot_No1==31
  xlabel('True principal  stress   (\sigma_{1}) (MPa) ','fontsize',size);
  ylabel('Estimated principal  stress (\sigma_{1}) (Mpa) ','fontsize',size);  
  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval');
  
     elseif Plot_No1==32
  xlabel('True principal  stress   (|\sigma_{2}|) (MPa) ','fontsize',size);
  ylabel('Estimated principal  stress (|\sigma_{2}|) (Mpa) ','fontsize',size);  
  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval');  
  
       elseif Plot_No1==33
  xlabel('True principal  stress   (|\sigma_{x}|) (MPa) ','fontsize',size);
  ylabel('Estimated principal  stress (|\sigma_{x}|) (Mpa) ','fontsize',size);  
  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval');  
  
      elseif Plot_No1==34
  xlabel('True scaled maximum shear stress   (\tau_{max}/f_t)  ','fontsize',size);
  ylabel('Estimated scaled maximum shear stress (\tau_{max}/f_t)  ','fontsize',size);  

  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval'); 
  
  
     elseif Plot_No1==35
  xlabel('True scaled principal  stress   (\sigma_{1}/f_t) ','fontsize',size);
  ylabel('Estimated scaled principal  stress (\sigma_{1}/f_t) ','fontsize',size);  
  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval');
  
     elseif Plot_No1==36
  xlabel('True scaled principal  stress   (\sigma_{2}/f_t) ','fontsize',size);
  ylabel('Estimated scaled principal  stress (\sigma_{2}/f_t) ','fontsize',size);  

  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval');
  
     elseif Plot_No1==37
  xlabel('True scaled stress (-\sigma_{xx}/f_t) ','fontsize',size);
  ylabel('Estimated scaled stress (-\sigma_{xx}/f_t) ','fontsize',size);  
%   xlabel('True scaled stress (|\sigma_{x}/\surd{f_t}|) ','fontsize',size);
%   ylabel('Estimated scaled stress (|\sigma_{x}/\surd{f_t}|) ','fontsize',size);    

  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval');  
  
     elseif Plot_No1==40
  xlabel('True principal stress theta (\theta_{p}) ','fontsize',size);
  ylabel('Estimated principal stress theta (\theta_{p}) ','fontsize',size);  
%   xlabel('True scaled stress (|\sigma_{x}/\surd{f_t}|) ','fontsize',size);
%   ylabel('Estimated scaled stress (|\sigma_{x}/\surd{f_t}|) ','fontsize',size);    

  NameJPG2 = strcat(nameFolder,'/',plotfname,'ConfidenceInterval');    
  
  
end

if Plot_No2==37
    
    titleString = 'Err |\sigma_{xx}/f_t| estimation';
    set(colorTitleHandle ,'String',titleString,'fontsize',size);
    
elseif   Plot_No2==29
    
        titleString = 'Err |\tau_{xy}/f_t| estimation';
    set(colorTitleHandle ,'String',titleString,'fontsize',size);
    
elseif Plot_No2==36
        titleString = 'Err |\sigma_{2}/f_t| estimation';
    set(colorTitleHandle ,'String',titleString,'fontsize',size);

end


alpha=[0.01:0.01:0.1];
[p,S] = polyfitZero(tvp(:,1),tvp(:,2),1);
[Y,DELTA] = polyconf(p,tvp(:,1),S,'alpha',alpha(5));

% hconf = plot(tvp(:,1),Y+DELTA,'-b<','MarkerFaceColor',[.49 1 .63]);

hconf = plot(tvp(:,1),Y+DELTA,'b','LineWidth',2.2);
plot(tvp(:,1),Y-DELTA,'b','LineWidth',2.2);

LEG=legend('prediction', 'prediction trend', 'ideal trend', '95 % prediction intervals','Location','northwest')
set(LEG,'fontsize',size);
set(gca,'fontsize',size)
h = gcf;
% print('-dpdf',char(Namepdf),'-r300')
print(char(NameJPG),'-dpng', '-r300');
% saveas(h, char(NameJPG),'-r300');
% hold off

for ii=1:length(alpha)
[Y,Delta(ii,:)] = polyconf(p,tvp(:,1),S,'alpha',alpha(ii)) ;   

delta(ii)=mean(Delta(ii,:));
end



figure 
plot((1-alpha)*100,delta,'b-','LineWidth',1.5)
grid on
xlim([ min((1-alpha)*100) max((1-alpha)*100)]);

xlabel('Prediction Interval (%)','fontsize',size);
ylabel('Average margin of error','fontsize',size);  
set(gca,'fontsize',size)
% print('-dpdf',char(Namepdf),'-r300')
print(char(NameJPG2),'-dpng', '-r300');




% figure 
% 
% NameJPG3 = strcat(NameJPG2,'Distribution');
% 
% % for ii=1:length(alpha)
% for ii=5
% plot(tvp(:,1),Delta(ii,:),'b*')
% hold on
% plot([min(tvp(:,1)),max(tvp(:,1))],[mean(Delta(ii,:)),mean(Delta(ii,:))],'k--','LineWidth',1.5);
% end
% xlabel(Xlabel,'fontsize',size);
% ylabel('Margin of error (95 % prediction intervals)','fontsize',size);  
% set(gca,'fontsize',size)
% LEG=legend('Margin of error distribution', 'Average margin of error','Location','northwest')
% set(LEG,'fontsize',size);
% print(char(NameJPG3),'-dpng', '-r300');

end