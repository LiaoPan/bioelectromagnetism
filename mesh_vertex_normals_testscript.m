
clear

FV = sphere_tri('ico',2);

facecolor = [.7 .7 .7];
figure
Hp = patch('faces',FV.faces,'vertices',FV.vertices,...
           'facecolor',facecolor,...
           'facealpha',1,...
           'edgecolor',[.8 .8 .8]); 
camlight('headlight','infinite');
daspect([1 1 1]);
axis vis3d;
axis off
material dull;
rotate3d
hold on

f = 25;
vi1 = FV.faces(f,1);
vi2 = FV.faces(f,2);
vi3 = FV.faces(f,3);
vertex1 = FV.vertices(vi1,:);
vertex2 = FV.vertices(vi2,:);
vertex3 = FV.vertices(vi3,:);

plot3(vertex1(1),vertex1(2),vertex1(3),'ro')
plot3(vertex2(1),vertex2(2),vertex2(3),'go')
plot3(vertex3(1),vertex3(2),vertex3(3),'bo')

vertNormals = get(Hp,'vertexnormals');
quiver3(vertex1(1),...
        vertex1(2),...
        vertex1(3),...
        vertNormals(vi1,1),...
        vertNormals(vi1,2),...
        vertNormals(vi1,3),0);

[faceNormals,faceNormalsUnit,faceCentroids,faceArea] = mesh_face_normals(FV);
quiver3(faceCentroids(f,1),...
        faceCentroids(f,2),...
        faceCentroids(f,3),...
        faceNormals(f,1),...
        faceNormals(f,2),...
        faceNormals(f,3),0);

[MYvertNormals,MYvertNormalsUnit] = mesh_vertex_normals(FV);
MYvertNormalsMag = vector_magnitude(MYvertNormals);
quiver3(vertex1(1),...
        vertex1(2),...
        vertex1(3),...
        MYvertNormals(vi1,1),...
        MYvertNormals(vi1,2),...
        MYvertNormals(vi1,3),0);

view(3)
rotate3d


vertNormalsMag = vector_magnitude(vertNormals);
vertNormalsUnit = vertNormals ./ repmat(vertNormalsMag,1,3);


% these comparisons are accurate to within 10^-12 or less, not sure why
% there is even these very small differences.
for v = 1:size(FV.vertices,1),
  dotprod(v,1) = dot( vertNormalsUnit(v,:), MYvertNormalsUnit(v,:) );
end

for v = 1:size(FV.vertices,1),
  crossprod(v,:) = cross( vertNormalsUnit(v,:), MYvertNormalsUnit(v,:) );
end
