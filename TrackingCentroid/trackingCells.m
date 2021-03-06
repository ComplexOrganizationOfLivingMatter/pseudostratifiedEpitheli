function [LayerCentroid, trackingCentroid, finalCentroid] = trackingCells( pathArchMat, initialFrame, maxFrame, folderNumber)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Variables
load(pathArchMat);
numCell=1;
n=1;

%Labels to each cell
for numFrame=initialFrame:maxFrame
    for numLayer=1:size(LayerCentroid)
        for numCentroidLayer= 1:size(LayerCentroid{numLayer,1})
            if LayerCentroid{numLayer,1}(numCentroidLayer, 1)==numFrame
                LayerCentroid{numLayer,1}(numCentroidLayer, 4)=numCell;
                numCell=numCell+1;             
            end
        end
    end   
end

%Tracking of the same cell
for numFrame=initialFrame+1:maxFrame
    oldCentroid=ismember(round(centroids{numFrame}), pixel{numFrame-1},'rows');
    trackingCentroid{numFrame,1}=zeros(size(centroids{numFrame,1},1),6);
    for numCentroid=1:size(centroids{numFrame,1},1)
        if oldCentroid(numCentroid)==1
            matDis = pdist2(centroids{numFrame,1}(numCentroid, :), centroids{numFrame-1,1});  
            Ind=find(matDis==min(matDis));
            trackingCentroid{numFrame,1}(numCentroid,:)=[centroids{numFrame-1,1}(Ind,:), numFrame-1, centroids{numFrame,1}(numCentroid, :), numFrame];
        end
    end
end

%It is stored in the variable 'finalCentroid', the ID of each cell, the coordinates where they appear and
%the layer to which it belongs.
for numLayer=1:size(LayerCentroid)
    for numCentroidLayer=1:size(LayerCentroid{numLayer,1})
        coord=[LayerCentroid{numLayer,1}(numCentroidLayer,2), LayerCentroid{numLayer,1}(numCentroidLayer,3), LayerCentroid{numLayer,1}(numCentroidLayer,1)];
        finalCentroid{n,1}=LayerCentroid{numLayer,1}(numCentroidLayer,4);
        finalCentroid{n,2}=coord;
        finalCentroid{n,3}=numLayer;
        n=n+1;
    end
end 

for numFrame=initialFrame+1:maxFrame
    for numCentroid=1:size(centroids{numFrame,1},1)
        if trackingCentroid{numFrame,1}(numCentroid,1)~=0
            [cen, index] =ismember(trackingCentroid{numFrame,1}(numCentroid,1:3),vertcat(finalCentroid{:,2}), 'rows');
            if cen==1
                finalCentroid{end+1,1}(1,1)=finalCentroid{index,1}(1,1);
                finalCentroid{end,2}(1,1:3)=trackingCentroid{numFrame,1}(numCentroid,4:6);
                finalCentroid{end,3}(1,1)=finalCentroid{index,3}(1,1);
            end
        end
    end
end

%Sort by labels
finalCentroid=sortrows(finalCentroid, 1);


%Temporarily saved
finalFileName=['trackingCentroids-Prueba-NOW' sprintf('%d',folderNumber) '.mat'];
save(finalFileName, 'finalCentroid')

%Corrects overlapping cells
[finalCentroidTracking] = finalTracking( finalCentroid, initialFrame, maxFrame, folderNumber);


%Correct cells that only appear in a single frame. REPLACED BY THE FUNCTION 'deleUniqueCentroids.m'
%[finalCentroid] = correctTracking(finalCentroid, folderNumber, maxFrame);

%Eliminates centroids from the centroids that only appear in a frame
[finalCentroid] = deleteUniqueCentroids( finalCentroid );

% Save the result to a .mat file
finalFileName=['trackingCentroidPruebafinal' sprintf('%d',folderNumber) '.mat'];
save(finalFileName, 'finalCentroidTracking')

end

