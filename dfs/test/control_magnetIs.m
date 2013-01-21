function is = control_magnetIs(name)

hsta=control_magnetGet(name,'HSTA');
is.trim=~bitand(max(0,min(ceil(hsta),2^16-1)),bin2dec('10000010100'));
