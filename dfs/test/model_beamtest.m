function beamLine = getline_test()
%=======================
%get the lattice of testline
%v0.0 13:27 2012-11-29
%======================================================================

q1h={'qu' 'q1h' 0.25 1}';
q2h={'qu' 'q2h' 0.25 -1}';
d1={'dr' '' 1 []}';
m1={'mo' 'm1' 0 []}';
hv={'mo' 'hv' 1e-12 []}';

%bl: line=(malin,10*(q1h,hv,d1,d1,m1,q2h,q2h,hv,d1,d1,m1,q1h))
repmat(AC1o6L3_4,1,6),

cell=[q1h,hv,d1,d1,m1,q2h,q2h,hv,d1,d1,m1,q1h];
test=repmat(cell,1,10)
%test=[hv,d1,q1h,m1];
beamLine=test';
