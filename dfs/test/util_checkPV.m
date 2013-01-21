function isPV = util_checkPV(pvNameList)

pvNameList=reshape(cellstr(pvNameList),[],1);
isPV=~cellfun('isempty',pvNameList);
retry=lcaGetRetryCount;
lcaSetRetryCount(1);
if any(isPV)
    try
        lcaGet(pvNameList(isPV),0,'double');
    catch
        err=lcaLastError;
        if length(err) == length(find(isPV))
            isPV(isPV)=~err;
            if any(isPV)
                lcaGet(pvNameList(isPV),0,'double');
            end
        end
    end
end
lcaSetRetryCount(retry);
