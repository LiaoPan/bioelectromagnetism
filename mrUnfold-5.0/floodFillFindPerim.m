function [insideNodes,insideNodeStruct]=floodFillFindPerim(mesh,perimDist,startNode,busyHandle)
%
% [insideNodes,insideNodeStruct]=floodFillFindPerim(mesh,perimDist,startNode)
%
% AUTHOR:  Wade
% DATE : 020701 last modified
% Here's something new.... a flood-fill way to find the perimeter of a mesh. 
% Find expanding rings connected to the start node. 
% Stop when all the members of the ring are >perimDist from the startNode
% But cleverer than this :)
% Also stores the average distance of each new set and its offset - 
% May be useful for tacking down points later
% This can break quite easily - for example when the floodfill runs around all sides of a bump. But we can fix this later..
 

allWithinDist=1;
insideNodes=[startNode];
currentNodes=startNode;
counter=0;
insideNodeStruct.offset=0;
insideNodeStruct.avDist=0;
nVerts=length(mesh.connectionMatrix);

while ((allWithinDist) & (counter<10000)) % Hope we don't generate more that 10000 rings....
   
   % What nodes are connected to the current ones?
   [newRows connected]=find(mesh.connectionMatrix(currentNodes,:));
 
   if (~isempty(connected))

      connected=unique(connected(:));   
      insideNodes=[insideNodes;connected];
      
      currentNodes=connected;
	  notCnodes=setdiff(1:nVerts,currentNodes);
	  
	  % This is a cute way of zeroing columns in a sparse matrix. Much faster than foo(:,currentNodes)=0; 
	  diagMat=sparse(notCnodes,notCnodes,ones(length(notCnodes),1),nVerts,nVerts);
	  mesh.connectionMatrix=(mesh.connectionMatrix)*(diagMat);
   
	  nodeDists=mesh.dist(currentNodes);
      f=find(nodeDists<perimDist);     
      allWithinDist=(sum(f(:)));
      
      % Average distance
      insideNodeStruct.avDist=[insideNodeStruct.avDist;mean(nodeDists(:))];
      
      % Offset to the list of current rings
      insideNodeStruct.offset=[insideNodeStruct.offset;length(connected)];
    
      
   else
         allWithinDist=0;
   end   
   
   counter=counter+1;
   if (busyHandle)
	   updateBusybar(busyHandle,counter);
   end
   
   
   
end

insideNodes=unique(insideNodes);
return;
