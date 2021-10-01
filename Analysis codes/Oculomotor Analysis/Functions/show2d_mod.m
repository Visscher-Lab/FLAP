function show2d_mod(m, C,symbs,sdwidth, npts, axh)

if ~exist('sdwidth', 'var'), sdwidth = 1; end
if ~exist('npts', 'var'), npts = []; end
if ~exist('axh', 'var'), axh = gca; end

if numel(m) ~= length(m), 
    error('M must be a vector'); 
end
if ~( all(numel(m) == size(C)) )
    error('Dimensionality of M and C must match');
end
if ~(isscalar(axh) && ishandle(axh) && strcmp(get(axh,'type'), 'axes'))
    error('Invalid axes handle');
end

set(axh, 'nextplot', 'add');


if nargout==0,
    clear h;
end
 


% plot the gaussian fits
tt=linspace(0,2*pi,npts)';
x = cos(tt); y=sin(tt);
ap = [x(:) y(:)]';
[v,d]=eig(C); 
d = sdwidth * sqrt(d); % convert variance to sdwidth*sd
bp = (v*d*ap) + repmat(m, 1, size(ap,2)); 
%h = plot(bp(1,:), bp(2,:), '-', 'parent', axh);
h = plot(bp(1,:), bp(2,:), '-', symbs, axh);
end