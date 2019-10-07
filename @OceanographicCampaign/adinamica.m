function R=adinamica(R,pref);

if isempty(R.vars_index('gpan'))
    R=R.gpan;
end