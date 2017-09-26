%load('..\..\docs\LayersCentroids7.mat')
load('E:\Tina\Epithelia3D\Zebrafish\Code\LayersCentroids1.mat')

seeds = round(vertcat(LayerCentroid{:}));

img3D = zeros(max(seeds) + 1);

for numSeed = 1:size(seeds, 1)
    actualSeed = seeds(numSeed, :);
    img3D(actualSeed(1), actualSeed(2), actualSeed(3)) = 1;
end

regionOfCell = {};
imgDist = bwdist(img3D);

img3DActual = zeros(max(seeds) + 1);

img3DLabelled = zeros(max(seeds) + 1);
colours = colorcube(size(seeds, 1));
figure;
for numSeed = 1:size(seeds, 1)
    numSeed
    actualSeed = seeds(numSeed, :);
    img3DActual(actualSeed(1), actualSeed(2), actualSeed(3)) = 1;
    imgDistPerSeed = bwdist(img3DActual);
    regionActual = imgDistPerSeed == imgDist;
    regionOfCell(numSeed) = {(regionActual) * numSeed};
    img3DLabelled(regionActual) = numSeed; 
    img3DActual(actualSeed(1), actualSeed(2), actualSeed(3)) = 0;
    
    [x, y, z] = findND(img3DLabelled);
%     cellFigure = alphaShape(x, y , z);
%     plot(cellFigure, 'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7);
    cellFigure = boundary(x, y , z);
    trisurf(cellFigure,'FaceColor', colours(numSeed, :), 'EdgeColor', 'none', 'AmbientStrength', 0.3, 'FaceAlpha', 0.7)
    hold on;
end
% figure;
% isosurface(imgDist, 10)