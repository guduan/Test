% clear all;clc;

a1=importdata('E:\test121130\test.mat1');
a2=importdata('E:\test121130\test1.mat1');
 b1=a1.data;
 b2=a2.data;

 for i=1:122
     for j=1:6
         for k=1:6
             Tmat1(j,k,i)=b1(i,(j-1)*6+k);
         end
     end
 end

  for i=1:122
     for j=1:6
         for k=1:6
             Tmat2(j,k,i)=b2(i,(j-1)*6+k);
         end
     end
  end
 
 
r1=eye(6);
for i=5:30
    r1=TALL1(:,:,i)*r1;
end

r2=eye(6);
for i=5:30
    r2=TALL2(:,:,i)*r2;
end

