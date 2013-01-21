function [isX, isY, names] = bba_corrIsXY(static)

names=[static.corrList static.corrList]';
isX=strncmp(static.corrList,'X',1);
isY=strncmp(static.corrList,'Y',1);
if ~any(isY), isY=isX;names(2,:)=strrep(names(1,:),'X','Y');end
