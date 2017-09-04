function [LayerCentroid, LayerPixel] = layer_write_mode(fig,LayerCentroid, LayerPixel, numFrame)

newLayer1=false;

label=input('Write the number of the wrongly marked label: ');

layerOld=input('Write the old layer: ');
layerNew=input('Write the new layer: ');

x1=LayerCentroid{layerOld,1}(label,2);
y1=LayerCentroid{layerOld,1}(label,3);
Pixel = [round(x1),round(y1)];%x1=round(x1);y1=round(y1);
Centroids=[x1,y1];


%Se trata la capa antigua para elimitar ese centroide de esa capa
for numCentroidLayer=1:size(LayerCentroid{layerOld,1},1)  
    if LayerCentroid{layerOld,1}(numCentroidLayer,:)== horzcat(numFrame,Centroids)
        LayerCentroid{layerOld,1}(numCentroidLayer,:)=[];
        LayerPixel{layerOld,1}(numCentroidLayer,:)=[];
        break
    end
end


%Se trata la capa nueva para incluir ese centroide en esa capa
if layerNew > size(LayerCentroid, 1) %Si no hay capa creada 
    LayerCentroid{layerNew, 1} = horzcat(numFrame, Centroids);
    LayerPixel{layerNew, 1} = horzcat(numFrame, Pixel);
    newLayer1=true;
    
else %Hay capa creada
    LayerCentroid{layerNew,1}= vertcat(LayerCentroid{layerNew,1}, horzcat(numFrame,Centroids));
    LayerPixel{layerNew,1}= vertcat(LayerPixel{layerNew,1}, horzcat(numFrame,Pixel));
end

end