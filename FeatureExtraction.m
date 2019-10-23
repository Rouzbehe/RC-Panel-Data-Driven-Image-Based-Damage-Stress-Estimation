function [OUTPUT]=FeatureExtraction(filename)

OUTPUT=cell(0);

a=600;
scacle=1;
tetha=0;
% [OUTPUT_Training]=FeatureExtraction('segmented_f_M')

struct=load(filename,'-mat');
images=getfield(struct, filename);

% MIN_OBJECT_SIZE = 10;  % 

%uploading crack shields from "Island_Scaled_segmented.mat" 54 data sets
for jj=1:length(images)
    
    BW=images{jj,1};
   [numrow, numcol] = size(BW);

   
     % Better way to remove small objects in segmented images
%      BW = bwareaopen(BW, MIN_OBJECT_SIZE);

          BW=bwmorph(BW,'fill');


   
    C=bwconncomp(BW,8); %use 8-connectivity
    p=regionprops(C,'Area', 'Perimeter', 'MajorAxisLength', 'MinorAxisLength','Orientation', ...
       'Image');

%     % to remove small objects in segmented images
%         Areas = regionprops(C, 'Area');
%         IdxList = regionprops(CC, 'PixelIdxList');
%         toosmallIDX = [];
%         for i=1:length(Areas)
%                  obj = Areas(i);
%                 if obj.Area < MIN_OBJECT_SIZE
%                 toosmallIDX = [toosmallIDX,i];
%                 end
%         end
%         IdxList(toosmallIDX) = []; 
    
%     for ii=length(P):-1:1   
%        
%            CrackArea(ii)=P(ii).Area;
%     end
%     
%     % to sort according the Area
%      [sorted_cracksArea Idx1] = sort(CrackArea,'descend');
% 

        Tetha= regionprops(C, 'Orientation');
        IdxList = regionprops(C, 'PixelIdxList');
        toosmallIDX = [];
        

    
    

    [numrowSBW, numcolSBW] = size(BW);
 
% % moment oif inertia calculations
    y = ( 1:numcolSBW ); x = ( 1:numrowSBW ).'; %'
    x = x - mean(x); y = y - mean(y);ppower=2;qpower=2;
%     % central moment of an image. 
    Mpq = sum( reshape( bsxfun( @times, bsxfun( @times, BW, x.^ppower ), y.^1 ), [], 1 ) ); %// computing the p-q moment

%    First moment of area about strong axis
%     Mpq = sum( reshape( bsxfun( @times, SBW, x.^4 ), [], 1 ) );

    % moment of Inertia about major axis
    Mx = sum( reshape( bsxfun( @times, BW, x.^ppower ), [], 1 ) );
    % moment of Inertia about week axis
    My = sum( reshape( bsxfun( @times, BW, y.^ppower ), [], 1 ) );  
    % polar moment of Inertia
    Mp=Mx+My;
          
    
                  if length(p)==0
                         compactness=0;aspectRatio=0;perimeter=0;majorAxis=0;
                  else
        
                     for ii=1:length(p)
                            compactness(ii)=p(ii).Perimeter/p(ii).Area;
                            aspectRatio(ii)=p(ii).MajorAxisLength/p(ii).MinorAxisLength;
                            perimeter(ii)=p(ii).Perimeter;
                            majorAxis(ii)=p(ii).MajorAxisLength;
                     end
    
    
                  end
                  
                  BW_rotated=imrotate(BW,0);
                  C_rotated=bwconncomp(BW_rotated,8); %use 8-connectivity
                  p_rotated=regionprops(C_rotated,'Area','Orientation');
                                                       
                  for ii=1:length(p_rotated)
                      Areas(ii)=p_rotated(ii).Area;
                   end
                    for ii=1:length(p_rotated)
                        Theta(ii)=p_rotated(ii).Orientation*p_rotated(ii).Area/sum(Areas);
                   end       
                  
                  
                     % find the average distance between cracks
                      dist_map = bwdist(BW);

                   %find points furthest from lines
                   lines = watershed(dist_map); 
                   lines = ~(lines > 0);

                   %keep only the intensities that correspond to furthest points between lines
                   avg_distance_map = dist_map ;  
                   avg_distance_map(~lines) = 0; 

                   %calculate stats
                      avg_distance_intensity = double(sum(sum(avg_distance_map))) ; %add up all the kept intensities
                      avg_distance_area = double(sum(sum(logical(avg_distance_map)))) ;  %number of pixels that contribute to intensity
    
                   if avg_distance_intensity==0
                        average_distance=300;
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
                    p(1).Contrast=Gprops.Contrast;
                    p(1).Correlation=Gprops.Correlation;
                    p(1).Energy=Gprops.Energy;
                    p(1).Homogeneity=Gprops.Homogeneity;
                    p(1).Variance=mean2(stdfilt(R));
                    p(1).Are=sum(BW(:))/a;
                    p(1).PeriAverage=mean(perimeter)/a;
                    p(1).TotalPerimeter=sum(perimeter(:))/a;
                    p(1).MajorAxis=sum(majorAxis(:))/a;
                    p(1).MajorAxisAverage=mean(majorAxis)/a;
                    p(1).Euler=EulerNumb;
                    % std2 reshape all columns and do std        
                            StandardDev1=std2(BW);
                    %         StandardDev2=std(reshape(SBW',numrowSBW*numcolSBW,1));
                    %         StandardDev3=std(mean(SBW));
                    %         StandardDev=corr2(SBW,ones(numrowSBW,numcolSBW));

                    %         p(1).std=StandardDev1;
                            p(1).angle=mean(Theta); % feat number 16
                            p(1).Momentpq=Mpq; 
                            p(1).Scale=scacle; % feat number 18
%                             p(1).MomentX=Mx ;
                            p(1).MomentY=My ;
                            p(1).MomentPolar=Mp/a^2 ;

                            p(1).Nocracks=length(p)/a;
                    %         p(1).Nocracks=C.NumObjects; %same as above

%                             p(1).Totalwidth=avg_distance_intensity;
                            p(1).randomtheta=tetha;   % it's not a feature no#22
                            p(1).averagewidth=average_distance;
    
   
    O=struct2cell(p(1));

    if isempty(O)==0;
        F=cell2mat(O(7:29,:))';    % 1-6 are 'Area', 'Perimeter', 'MajorAxisLength', 'MinorAxisLength','Orientation', ... defined in imageproperties
                                   % 27: Nocracks 28.. 29...

        %store feature vectors in a cell array along with the image filename, the
        %binary image filename, and a copy of the image object from CComp. This is
        %used for the tagging application to be implemented later.
        INFO=cell(size(F,1),1);
        for ii=1:size(F,1)
            INFO{ii,1}=F(ii,:);
        end
        OUTPUT=[OUTPUT;INFO];
    end
     
     clear I  C P p Idx1 CrackArea DensityFile densityFile toosmallIDX compactness aspectRatio perimeter majorAxis Theta;
 
     clear I BW P p Idx1 idx1 CrackArea DensityFile densityFile;
%     end
end


end