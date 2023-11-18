function cohx=mcoh2(x,dim)
% function cohx=mcoh(x)
% circular phase coherence
% created by Nai 2009
% updated by yhy 05/10/2021
% usage: x-phase data (radian); dim-index of trials in data

c=nanmean(cos(x),dim);
s=nanmean(sin(x),dim);
cohx=sqrt(s.^2+c.^2);
% cohx=size(x,dim)*(s.^2+c.^2);
