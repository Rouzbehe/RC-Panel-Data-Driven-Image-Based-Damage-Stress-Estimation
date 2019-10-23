
function [OUTPUT_try]=FeatureExtraction_comx(filename,range,option,Nosample)


struct=load(filename,'-mat');
images=getfield(struct, filename);

 OUTPUT_try=[];

for jj=1:length(images);
    
    I=images{jj,1};
   [m, n] = size(I);

   
     % Better way to remove small objects in segmented images
%      BW = bwareaopen(BW, MIN_OBJECT_SIZE);

%           BW=bwmorph(BW,'fill');
          
   j=1 ;
  while  j<=Nosample
      
      
    if option==1
        scacle=range/100;
        tetha=0;
    elseif option==2
         scacle=randi(range,1,1)/100;
         tetha=0;
    elseif option==3
        
         scacle=range/100;
         if scacle>0.94
         tetha=0;
         else
         tetha=randi(90);
         end
         
    elseif option==4
             scacle=randi(range,1,1)/100;
%              tetha=randi([ceil((j-1)*180/Nosample),ceil(j*180/Nosample)]);
             aa=randperm(90);
             tetha=aa(1);
%          if scacle>0.94
%          tetha=0;
%          else
%          tetha=randi([ceil((j-1)*180/Nosample),ceil(j*180/Nosample)]);
%          end
    end
    
%     scacle=randi(range,1,1)/100;
   for mm=1:10000
  
    a=m*scacle;
    A1x=randi([1 m],1,1);
    A1y=randi([1 n],1,1);
%      tetha=randi([0 90],1,1);
%     tetha=0;

    A2x=A1x+a*cosd(tetha);    A3x=A1x+a*cosd(tetha)-a*sind(tetha); A4x=A1x-a*sind(tetha); 
    A2y=A1y+a*sind(tetha);    A3y=A1y+a*sind(tetha)+a*cosd(tetha); A4y=A1y+a*cosd(tetha);
    
    if max([A1x, A2x,A3x ,A4x,A1y, A2y,A3y ,A4y])<max(m,n) && min([A1x, A2x,A3x ,A4x,A1y, A2y,A3y ,A4y])>1

            x=[A1x, A2x,A3x ,A4x ,A1x];  y=[A1y, A2y,A3y ,A4y,A1y];    
            binaryImage = poly2mask(x, y,m,n);    
            resampled=I.*binaryImage; 
% %             

             % not to select pure black areas
             if sum(resampled(:))>20
%              Widden_fname = strcat('sampled_Resized_',name,'/',num2str(kk),'.png');
% 
%            figure 
%            J = insertShape(resampled, 'Polygon',[A1x A1y A2x A2y A3x A3y A4x A4y]);
%            imshow(J);

                        
                     BW=bwmorph(resampled,'fill');

                     % used for distance trasform and ave distance
                     % calculationd
                     xmin=min([A1x,A2x,A3x,A4x]);ymin=min([A1y,A2y,A3y,A4y]);
                     xmax=max([A1x,A2x,A3x,A4x]);ymax=max([A1y,A2y,A3y,A4y]);

                     BWD=imcrop(BW,[xmin ymin ymax-ymin xmax-xmin]); 
                     
                     BWD=imrotate(BWD,-tetha,'crop','bilinear');
                     a_1=ymax-ymin;
                     a_2=a_1/sind(tetha);
                     BWD=imcrop(BWD,[(a_1-a_2)/2 (a_1-a_2)/2 a_2 a_2]); 
   
                      

                          [numrowSBW, numcolSBW] = size(BWD);
 
                    % % moment oif inertia calculations
                    y = ( 1:numcolSBW ); x = ( 1:numrowSBW ).'; %'
                    x = x - mean(x); y = y - mean(y);ppower=2;qpower=2;
                    %     % central moment of an image. 
                  Mpq = sum( reshape( bsxfun( @times, bsxfun( @times, BWD, x.^ppower ), y.^1 ), [], 1 ) ); %// computing the p-q moment

            %    First moment of area about strong axis
                %             Mpq = sum( reshape( bsxfun( @times, SBW, x.^4 ), [], 1 ) );

                  % moment of Inertia about major axis
                   Mx = sum( reshape( bsxfun( @times, BWD, x.^ppower ), [], 1 ) );
                   % moment of Inertia about week axis
                       My = sum( reshape( bsxfun( @times, BWD, y.^ppower ), [], 1 ) );  
                  % polar moment of Inertia
                    Mp=Mx+My;
          
                    
                    C=bwconncomp(BW,8); %use 8-connectivity
                    p=regionprops(C,'Area', 'Perimeter', 'MajorAxisLength', 'MinorAxisLength','Orientation', ...
                     'Image');  
                    
                  if length(p)==0
                         compactness=0;aspectRatio=0;perimeter=0;majorAxis=0;
                  else
        
                     for ii=1:length(p)
                            compactness(ii)=p(ii).Perimeter/p(ii).Area;
                            aspectRatio(ii)=p(ii).MajorAxisLength/p(ii).MinorAxisLength;
                            perimeter(ii)=p(ii).Perimeter;
                            majorAxis(ii)=p(ii).MajorAxisLength;
                            
                            Areas(ii)=p(ii).Area;
                            Thetas(ii)=p(ii).Orientation.*p(ii).Area;
                            theta(ii)=p(ii).Orientation;
                            Tans(ii)=tand(p(ii).Orientation).*p(ii).Area;
                            
                            
                     end
    
    
                  end
                  
%                   BW_rotated=imrotate(BW,-tetha); %-tetha
%                   
% %                   figure
% %                   imshow(BW_rotated)
% %                   BW_rotated=bwmorph(BW_rotated,'fill');
% 
%                   C_rotated=bwconncomp(BW_rotated,8); %use 8-connectivity
%                   p_rotated=regionprops(C_rotated,'Area','Orientation');
%                                                       
%                   for ii=1:length(p_rotated)
%                       Areas(ii)=p_rotated(ii).Area;
%                       Thetas(ii)=p_rotated(ii).Orientation.*p_rotated(ii).Area;
%                       theta(ii)=p_rotated(ii).Orientation;
%                       Tans(ii)=tand(p_rotated(ii).Orientation).*p_rotated(ii).Area;
%                   end
                  
                  
                  idx=find(theta>=mean(theta)-std(theta) & theta<=mean(theta)+std(theta));
                  
%                      Theta=sum(Thetas)/sum(Areas);

                   Theta=sum(Thetas(idx))/sum(Areas(idx));
%                    Tan=sum(Tans(idx))/sum(Areas(idx));
%                    Theta=atand(Tan);



                   if Theta<0
                       Theta=-Theta;
                   else
                       Theta=180-Theta;
                   end
                  
                   Theta=Theta+tetha;
                   
                   
                   
                   % random tehta between 0-180
                      if Theta>180;
                            Theta=Theta-180;
                      end
   
                      
                   % find the average distance between cracks
                   dist_map = bwdist(BW);

                   %find points furthest from lines
                   lines = watershed(dist_map); 
                   lines = ~(lines > 0);

                   %keep only the intensities that correspond to furthest points between lines
                   avg_distance_map = dist_map ;  
                   avg_distance_map(~lines) = 0; 

                   %consider the values just in the range of resampled
                   %block
                   avg_distance_map=avg_distance_map.*binaryImage; 
                   
                   %calculate stats
                      avg_distance_intensity = double(sum(sum(avg_distance_map))) ; %add up all the kept intensities
                      avg_distance_area = double(sum(sum(logical(avg_distance_map)))) ;  %number of pixels that contribute to intensity
    
                      list_ave_dist=avg_distance_map(avg_distance_map~=0);
                      
%                    figure
%                         [n1,ctr1] = hist(list_ave_dist,20)
%                         bar(ctr1,n1,1);
%                         axis([0 max(list_ave_dist) 0 max(n1)]);
                    
%                   idx=find(list_ave_dist>=mean(list_ave_dist)-2*std(list_ave_dist) & list_ave_dist<=mean(list_ave_dist)+2*std(list_ave_dist));
                    
                  ave_dist=double(mean(list_ave_dist(:)));


%                     rounded_ave_dist=round(list_ave_dist(idx));
%                     Mode=mode(rounded_ave_dist)
                   
                   if avg_distance_intensity==0
                        average_distance=a;
                   else
                         average_distance = avg_distance_intensity / avg_distance_area ; 
                     end

                    p(1).Compactness=mean(compactness);
                    p(1).AspectRatio=mean(aspectRatio);
                    %R=I(P(ii).SubarrayIdx{:});
                    R=BW;
                    [BWR,threshOut] = edge(BW);
                    EulerNumb=bweuler(BW);
                    p(1).ThreshOut=threshOut;
                    G=graycomatrix(R);
                    Gprops=graycoprops(G);
                    p(1).Entropy=entropy(R);
                    
                    
%                             p(1).angle2=sind(Theta); % 1
%                             p(1).angle3=cosd(Theta);  % 2
%                             p(1).angle4=cosd(2*Theta);  % 3
%                             p(1).angle5=sind(2*Theta);  %  4

                    
                    
                    p(1).Contrast=Gprops.Contrast;
                    p(1).Correlation=Gprops.Correlation;
                    p(1).Energy=Gprops.Energy;
                    p(1).Homogeneity=Gprops.Homogeneity;
                    p(1).Variance=mean2(stdfilt(R));
                    p(1).Are=sum(BWD(:))/a^2;
                    p(1).PeriAverage=mean(perimeter)/a;
                    p(1).TotalPerimeter=sum(perimeter(:))/a;
                    p(1).MajorAxis=sum(majorAxis(:))/a^2;
                    p(1).MajorAxisAverage=mean(majorAxis)/a;
                    p(1).Euler=EulerNumb;
                    % std2 reshape all columns and do std        
                            StandardDev1=std2(BW);
                    %         StandardDev2=std(reshape(SBW',numrowSBW*numcolSBW,1));
                    %         StandardDev3=std(mean(SBW));
                    %         StandardDev=corr2(SBW,ones(numrowSBW,numcolSBW));

                    %         p(1).std=StandardDev1;
                            p(1).angle=Theta; % feat number 16
                            p(1).Momentpq=Mpq; 
                            p(1).Scale=scacle; % feat number 18
%                             p(1).MomentX=Mx ;
                            p(1).MomentY=My ;
                            p(1).MomentPolar=Mp/a^4 ;

                            p(1).Nocracks=length(p)/a^1.5; % /a
                    %         p(1).Nocracks=C.NumObjects; %same as above

%                             p(1).Totalwidth=avg_distance_intensity;
                            p(1).randomtheta=tetha;   % it's not a feature no#22 % tetha
                            p(1).averagewidth=ave_dist ; % 23  average_distance


                        O=struct2cell(p(1));

                        if isempty(O)==0;
                            F=cell2mat(O(7:29,:))';    % 1-6 are 'Area', 'Perimeter', 'MajorAxisLength', 'MinorAxisLength','Orientation', ... defined in imageproperties
                                                       % 27: Nocracks 28.. 29...

                            %store feature vectors in a cell array along with the image filename, the
                            %binary image filename, and a copy of the image object from CComp. This is
                            %used for the tagging application to be implemented later.
%                             INFO=cell(size(F,1),1);
                            
%                             for ii=1:size(F,1)
%                                  INFO{ii,1}=F(ii,:);
%                             end
%                              OUTPUT=[OUTPUT;INFO];
                            OUTPUT_try=[OUTPUT_try;F];
                        end
                      
                        
                        
%                         for i=1:size(OUTPUT,1);
%                             OUTPUT(i,:)=OUTPUT{i,1};
%                         end
                        

                 
                
%             imwrite(resampled,Widden_fname);

%             percent30_5sampled_segm_f_M_fiber{kk,1}=resampled;
            j=j+1;
            
                %mm
                break
             end
    end 

    
    
      

      
     
    end 

  end 
    % x=[floor((sqrt(2)-1)/2*m), floor((sqrt(2)+1)/2*m),floor((sqrt(2)+1)/2*m) ,floor((sqrt(2)-1)/2*m) ];  y=[floor((sqrt(2)-1)/2*n) ,floor((sqrt(2)-1)/2*n) , floor((sqrt(2)+1)/2*n), floor((sqrt(2)+1)/2*n)];    

clear n m I
end


end

