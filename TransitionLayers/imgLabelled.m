% load('neighbours_layer2.mat');
% load('E:\Tina\Epithelia3D\Zebrafish\Results\Sample2\trackingLayer2.mat');
% load('transition_layers2.mat')
% load('E:\Tina\pseudostratifiedEpithelia\LayerAnalysis\imgVoronoi2D_16-Oct-2017.mat');

initialFrame=6;
maxFrame=71;
folderNumber=1;

neighs_real=table2array(neigh_real);
basicInfos=table2array(basicInfo);
basicInfos=cell2mat(basicInfos);
outputDir=['E:\Tina\Epithelia3D\Zebrafish\Results\Sample' sprintf('%d',folderNumber) '\Labelled\Labelled' sprintf('%d',folderNumber) '\'];

%Representation of actual images with layered labels
for numLayer=1:3%size(transition_layer,1)
    for numFrame=initialFrame:maxFrame
        FileName=['E:\Tina\Epithelia3D\Zebrafish\50epib_' sprintf('%d',folderNumber) '\50epib_'  sprintf('%d',folderNumber) '_z' sprintf('%03d', numFrame) '_c001.tif'];
        f=figure('Visible','on');
        imshow(FileName)
        for numCentroid=1:size(finalCentroid)
            coordenates{numCentroid,1}(:,1)=finalCentroid{numCentroid,2}(1:2);
            coordenates{numCentroid,2}=finalCentroid{numCentroid,2}(3);
            
            if coordenates{numCentroid,2}(1,1)==numFrame && finalCentroid{numCentroid,3}(1,1)==numLayer
                hold on
                label=text(coordenates{numCentroid,1}(1,1), coordenates{numCentroid,1}(2,1),sprintf('%d',finalCentroid{numCentroid,1}(1,1)),'HorizontalAlignment','center','VerticalAlignment','middle','Color','white','FontSize',9);
            end
        end
        % Save images to return
%         framePhoto=['E:\Tina\Epithelia3D\Zebrafish\Results\Sample_' sprintf('%d',folderNumber) '\Labelled\Labelled' sprintf('%d',folderNumber) '\50epib_'  sprintf('%d',numLayer) '_z' sprintf('%03d', numFrame) '_c001.bmp'];
%         set(gcf,'InvertHardCopy','off');
%         print('-dtiff',framePhoto);
        
        set(gcf,'InvertHardCopy','off');
        framePhoto=['50epib_'  sprintf('%d',numLayer) '_z' sprintf('%03d', numFrame) '_c001.bmp'];
        saveas(gcf,strcat(outputDir,framePhoto)); 
        
        
        

    end
end


%Representation of 2D voronoi images with tags
for numZ = 1:size(Img, 2)
    centroides=regionprops(Img{numZ}, 'Centroid');
    centroid=vertcat(centroides.Centroid);
    f=figure('Visible','on');
    imshow(Img{numZ})
    
    for numCentroid=1:size(centroides,1)
        hold on
        label=text(centroid(numCentroid,1), centroid(numCentroid,2),sprintf('%d',numCentroid),'HorizontalAlignment','center','VerticalAlignment','middle','Color','red','FontSize',9);   
    end
    FileName=['E:\Tina\results\LayerAnalysis\Layer_all' sprintf('%d',folderNumber) '\Labelled\imgLabelled_z_' sprintf('%d',numZ) '.bmp'];
    print('-dtiff',FileName);
end


