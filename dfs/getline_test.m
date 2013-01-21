function beamLine = getline_test(Kfactor)
%=======================
%get the lattice of testline
%v0.0 13:27 2012-11-29
%======================================================================
q1h={'qu' 'q1h' 0.25 1/Kfactor}';
q2h={'qu' 'q2h' 0.25 -1/Kfactor}';
q3h={'qu' 'q3h' 0.25 1/Kfactor}';
q4h={'qu' 'q4h' 0.25 -1/Kfactor}';
q5h={'qu' 'q5h' 0.25 1/Kfactor}';
q6h={'qu' 'q6h' 0.25 -1/Kfactor}';
q7h={'qu' 'q7h' 0.25 1/Kfactor}';
q8h={'qu' 'q8h' 0.25 -1/Kfactor}';
q9h={'qu' 'q9h' 0.25 1/Kfactor}';
q10h={'qu' '10' 0.25 -1/Kfactor}';
q11h={'qu' '11' 0.25 1/Kfactor}';
q12h={'qu' '12' 0.25 -1/Kfactor}';
q13h={'qu' '13' 0.25 1/Kfactor}';
q14h={'qu' '14' 0.25 -1/Kfactor}';
q15h={'qu' '15' 0.25 1/Kfactor}';
q16h={'qu' '16' 0.25 -1/Kfactor}';
q17h={'qu' '17' 0.25 1/Kfactor}';
q18h={'qu' '18' 0.25 -1/Kfactor}';
q19h={'qu' '19' 0.25 1/Kfactor}';
q20h={'qu' '20' 0.25 -1/Kfactor}';

d1={'dr' '' 1 []}';
m1={'mo' 'm1' 0 []}';
hv={'cr' 'hv' 1e-12 []}';
malin={'dr' '' 0 []}';
%bl: line=(malin,10*(q1h,hv,d1,d1,m1,q2h,q2h,hv,d1,d1,m1,q1h))

test=[malin,...
		d1,d1,q1h,hv,d1,m1,q2h,hv,d1,m1,q3h,hv,d1,m1,q4h,hv,d1,m1,...
		d1,d1,q5h,hv,d1,m1,q6h,hv,d1,m1,q7h,hv,d1,m1,q8h,hv,d1,m1,...
		d1,d1,q9h,hv,d1,m1,q10h,hv,d1,m1,q11h,hv,d1,m1,q12h,hv,d1,m1,...
		d1,d1,q13h,hv,d1,m1,q14h,hv,d1,m1,q15h,hv,d1,m1,q16h,hv,d1,m1,...
		d1,d1,q17h,hv,d1,m1,q18h,hv,d1,m1,q19h,hv,d1,m1,q20h,hv,d1,m1];
beamLine=test;
