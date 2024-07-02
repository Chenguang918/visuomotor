function [filt_sig,tmavg] = tma_filter(sig,wl,pct)
%
% [filt_sig,tmavg] = tma_filter(sig,wl,pct)
%
% Applies the trimmed moving average filter to a signal 'sig'.
%
% Required Parameters:
%
% sig
%       A Nx1 vector of data.
% wl
%       The window length of the filter.
% pct
%       The percentage of extrema inside a data window which will be
%       excluded (trimming percentage).
%
%
%
% Written by Marcus Vollmer, 2014
% Last Modified: 29 June 2016
% Version 0.2
%
%endOfHelp


    if rem(wl,2)~=1
        wl=wl+1;
    end

    ts = NaN(size(sig,1)+wl-1,wl);
    for j=1:wl
        ts(j:end-wl+j,j) = sig;
    end
    
    ts = sort(ts((wl+1)/2:end-(wl-1)/2,:),2);
    
    % trimmed moving average
    tmavg = HRV__nanmean(ts(:,1+round(wl*pct/2):end-round(wl*(1-pct)/2)),2);
    filt_sig = sig-tmavg;    
 
end


function m = HRV__nanmean(x, varargin)
    if (nargin < 2) % check input
        dim = find(size(x)>1,1);
        if isempty(dim)
            dim = 1;
        end
    else
        dim = varargin{1};
    end

    % determine number of regular (not nan) data points
    n = sum(not(isnan(x)),dim);

    % replace nans with zeros and compute mean value(s)
    x(isnan(x)) = 0;
    n(n==0) = nan;
    m = sum(x,dim)./n;
end
