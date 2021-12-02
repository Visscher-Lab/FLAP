function [bf10,pValue,CI,stats] = ttest(X,varargin)
%TTEST Bayes Factors for one-sample and paired t-tests.
% function [bf10,p,CI,stats] = ttest(X,varargin)    - one sample
% function [bf10,p,CI,stats] = ttest(X,M,varargin)   -one sample,non-zero mean
% function [bf10,p,CI,stats] = ttest(X,Y,varargin)   -paired samples
%
% function [bf10,p,CI,stats] = ttest('T',T,'df',df)   - calculate BF based
% on regular ttest output
%
% INPUT 
% X = single sample observations  (a column vector)
% Y = paired observations (column vector) or a scalar mean to compare the samples in X to.
%       [Defaults to 0]
%
% Optional Parm/Value pairs:
% tail - 'both','right', or 'left' for two or one-tailed tests [both]
% scale - Scale of the Cauchy prior on the effect size  [sqrt(2)/2]
% To calculated BF based on the outcome of a T-test, pass T and df as
% parm/value pairs:
% T - The T-value resulting from a standard T-Test output 
% df - the degrees of freedom of the T-test
%
% OUTPUT
% bf10 - The Bayes Factor for the hypothesis that the mean is different
%           from zero. Using JZS priors. 
% p - p value of the frequentist hypothesis test
% CI    - Confidence interval for the true mean of X
% stats - Structure with .tstat, .df,
%
% Based on: Rouder et al. J. Math. Psych. 2012
% 
% BK - Nov 2018

if isnumeric(X)
    if mod(numel(varargin),2)==0
        % Only X specified
        Y = 0;
        parms = varargin;
    else
        % X and Y specified
        if numel(varargin)>1
            parms = varargin(2:end);
        else
            parms = {};
        end
        Y  =varargin{1};
    end
else
    %Neither X nor Y specified (must be a call with 'stats' specified
    parms = cat(2,X,varargin);
    X=[];Y=[];
end
p=inputParser;
p.addParameter('tail','both',@(x) (ischar(x)&& ismember(upper(x),{'BOTH','RIGHT','LEFT'})));
p.addParameter('scale',sqrt(2)/2);
p.addParameter('T',[],@isnumeric);
p.addParameter('df',[],@isnumeric);
p.parse(parms{:});

tail = p.Results.tail;

if isempty(p.Results.T)
    % Calculate frequentist from the X and Y data
    [~,pValue,CI,stats] = ttest(X,Y,'tail',tail);
    T = stats.tstat;
    df = stats.df;
    N = numel(X);
else
    % User specified outcome of frequentist test (the builtin ttest);
    % Calculate BF from T and df.
    
    T = p.Results.T;
    df = p.Results.df;
    
    pValue = tcdf(T,df,'upper'); % Right tailed
        switch upper(tail)
            case 'BOTH'
                pValue = 2*(1-pValue );
            case 'LEFT'
                pValue   =1-pValue ;
            case 'RIGHT'
                % Ok as is
        end
    
    N = p.Results.df+1;     
    CI = [NaN NaN];
    % Create stats struct to return the same output.
    stats.tstat = T;
    stats.df = df;
    stats.sd = NaN;
       
end

% Use the formula from Rouder et al.
% This is the formula in that paper; it does not use the
% scale numerator = (1+T.^2/(N-1)).^(-N/2);
% fun  = @(g) ( ((1+N.*g).^-0.5) .* (1+T.^2./((1+N.*g).*(N-1))).^(-N/2) .* (2*pi).^(-1/2) .* g.^(-3/2).*exp(-1./(2*g))  );
% Here we use the scale  (Checked against Morey's R package )
r = p.Results.scale;
numerator = (1+T.^2/df).^(-(df+1)/2);
fun  = @(g) ( ((1+N.*g.*r.^2).^-0.5) .* (1+T.^2./((1+N.*g.*r.^2).*df)).^(-(df+1)/2) .* (2*pi).^(-1/2) .* g.^(-3/2).*exp(-1./(2*g))  );

% Integrate over g
bf01 = numerator/integral(fun,0,inf);
% Return BF10
bf10 = 1./bf01;

switch (tail)
    case 'both'
        % Nothing to do
    case {'left','right'}
        % Adjust the BF using the p-value as an estimate for the posterior
        % (Morey & Wagenmakers, Stats and Prob Letts. 92 (2014):121-124.
        bf10 = 2*(1-pValue)*bf10;
end
end

