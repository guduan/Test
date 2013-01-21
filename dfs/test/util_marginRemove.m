function util_marginRemove(fig)

if nargin < 1, fig=gcf;end

ax=get(fig,'Children');
if isempty(ax), return, end

pos=get(ax,'Position');
ti=get(ax,'TightInset');
if numel(ax) > 1
    pos=cell2mat(pos);
    ti=cell2mat(ti);
end

x1=min(pos(:,1:2));xn=max(pos(:,1:2)+pos(:,3:4));
t1=max(ti(:,1:2))+.01;tn=max(ti(:,3:4))+.03;tn(1)=tn(1)-.0;
s=([1. 1]-tn-t1)./(xn-x1);%s=min(s);
x0=t1-s.*x1;
posNew=[pos(:,1:2)*diag(s)+repmat(x0,numel(ax),1) pos(:,3:4)*diag(s)];
set(ax,{'Position'},num2cell(posNew,2));
