function [rMat, zPos, lEff] = model_plot(type, sect, varargin)

optsdef=struct( ...
    );

% Use default options if OPTS undefined.
opts=util_parseOptions(varargin{:},optsdef);

colList={ ...
    'WIRE' 'r'; ...
    'QUAD' 'g'; ...
    'OTRS' 'k'; ...
    'BEND' 'b'; ...
    };

hold off
name=model_nameConvert(type,'MAD',sect);
z=model_rMatGet(name,[],[],'Z');
tw=model_twissGet(name,'POS=MID');
use=z ~= 0;
z=z(use);tw=tw(:,:,use);
[z,id]=sort(z);tw=tw(:,:,id);
plot(z,squeeze(tw(2,1,:)),'b',z,squeeze(tw(2,2,:)),'r');
hold on
sc=max(tw(2,:));

for t=cellstr(type)
    name=model_nameConvert(t,'MAD',sect);
    z=model_rMatGet(name,[],[],'Z');
    l=model_rMatGet(name,[],[],'LEFF');
    use=z ~= 0;
    z=z(use);l=l(use);name=name(use);
    col=colList{strcmp(colList(:,1),t),2};
%    plot(z,z*0,'x','Color',col);
    plot(z,z*0-.1*sc,'Color','k');
    for j=1:length(z)
        fill(z(j)+l(j)/2*[-1 -1 1 1],.05*sc*[-1 1 1 -1]-.1*sc,col,'EdgeColor',col);
        text(z(j),-.25*sc-.05*sc*mod(j,3),name(j),'Rotation',90,'Color',col,'HorizontalAlignment','right');
    end
end
set(gca,'YLim',[-.6 1.1]*sc);
