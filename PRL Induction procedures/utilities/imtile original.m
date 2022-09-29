function out = imtile(varargin)
%IMTILE Combine multiple image frames into one rectangular tiled image.
%
%   OUT = IMTILE(FILENAMES) returns a tiled image of the images specified
%   in FILENAMES. FILENAMES is a character vector or an N-by-1 or 1-by-N
%   string array or a cell array of character vectors. If the files are not
%   in the current directory or in a directory on the MATLAB path, specify
%   the full pathname. (See the IMREAD command for more information.)
%   IMTILE converts any indexed image into its corresponding RGB version
%   using the internal colormap present in the file. The images need not be
%   of the same size and type. IMTILE combines the images horizontally
%   across columns.
%
%   OUT = IMTILE(I) returns a tiled image of all the frames of a multiframe
%   image array I. I can be a sequence of binary, grayscale, or truecolor
%   images. A binary or grayscale image sequence must be an M-by-N-by-K or
%   an M-by-N-by-1-by-K array. A truecolor image sequence must be an
%   M-by-N-by-3-by-K array.
%
%   OUT = IMTILE(IMAGES) returns a tiled image of the images specified in
%   the cell array IMAGES. Elements of the cell array are either numeric
%   matrices of size MxN or MxNx3. An empty cell element will be displayed
%   as a blank tile.
%
%   OUT = IMTILE(IMDS) returns a tiled image of the images specified in the
%   imagedatastore object IMDS.
%
%   OUT = IMTILE(X,MAP) treats all grayscale images in X as indexed
%   images and applies the specified colormap MAP. X can either be a
%   grayscale image (M-by-N-by-1-by-K), a string of filenames or a cell
%   array of character vectors with the filenames. If X represents
%   filenames, MAP overrides any internal colormap present in image files.
%
%   OUT = IMTILE(..., NAME1, VALUE1, NAME2, VALUE2, ...) returns a
%   customized tiled image, depending on the values of the optional
%   parameter name/value pairs. See Parameters below. Parameter names can
%   be abbreviated, and case does not matter.
%
%   Parameters
%   ----------
%   'GridSize'        A 2-element vector, [NROWS NCOLS], specifying the number
%                     of rows and columns of thumbnails for the final tiled
%                     image. Use NaNs or Infs to have IMTILE calculate the
%                     size in a particular dimension in a way that includes
%                     all the images. For example, if 'GridSize' is [2 NaN],
%                     IMTILE creates a tiled image with 2 rows and the
%                     number of columns necessary to include all of the
%                     images. If both the elements are NaN or Inf, the
%                     default value is used. When there is a mismatch
%                     between GridSize and number of images/frames, the
%                     tiled image is created based on the GridSize.
%
%                     Default: IMTILE calculates the rows and columns so
%                     the images in the tiled image roughly form a square.
%
%   'ThumbnailSize'   A 2-element vector, [TROWS TCOLS], specifying the size
%                     of each individual thumbnail in pixels. The aspect
%                     ratio of the original image will be maintained by
%                     zero-padding the boundary. If one element is NaN or
%                     Inf, the corresponding value is computed automatically
%                     to preserve the aspect ratio of the first image. If
%                     both the elements are NaN or Inf, the default value is
%                     used. ThumbnailSize may be empty ([]), in which case the
%                     full size of the first image is used as the thumbnail
%                     size.
%
%                     Default: IMTILE uses full size of the first image
%                     as the thumbnail size.
%
%   'Frames'          A numeric array or a logical mask that specifies which 
%                     frames IMTILE includes in the tiled image. The values
%                     are interpreted as indices into array I or cell array
%                     FILENAMES.  For example, to create a tiled image
%                     of the first three frames in I, use either of these
%                     syntaxes:
%
%                     out = imtile(I,'Frames',1:3);
%                     out = imtile(I,'Frames',[true true true]);
%
%                     Default: 1:K, where K is the total number of frames
%                     or image files.
%
%   'BackgroundColor' The background color, defined as a MATLAB ColorSpec.
%                     All blank spaces will be filled with this color
%                     including space specified by BorderSize. If a
%                     background color is specified, the output is rendered
%                     as an RGB image.
%
%                     Default: 'black'
%
%   'BorderSize'      A scalar or a 1-by-2 vector, [BROWS BCOLS]
%                     that specifies the amount of pixel padding required
%                     around each thumbnail image. The borders are padded
%                     with the BackgroundColor.
%
%                     Default: [0 0]
%
%
%   Class Support
%   -------------
%   A grayscale image array can be uint8, logical, uint16, int16, single,
%   or double. An indexed image array can be logical, uint8, uint16,
%   single, or double. MAP must be double. A truecolor image array can be
%   uint8, uint16, single, or double. The output is single rectangular
%   tiled image produced by IMTILE. If there is a datatype mismatch
%   between images, all images are rescaled to be double using the
%   im2double function.
%
%   Example 1
%   ---------
%     % Create a tiled image from filenames.
%     out = imtile({'peppers.png', 'ngc6543a.jpg'});
%     imshow(out);
%
%   Example 2
%   ---------
%     % Customize the number of images in the tiled image.
%     load mri
%     out = imtile(D, map);
%     imshow(out);
%
%     % Create a new tiled image containing only the first 8 images with 2 rows and 4 columns.
%     out = imtile(D, map, 'Frames', 1:8, 'GridSize', [2 4]);
%     figure;
%     imshow(out);
%
%   Example 3
%   ---------
%     % Inspect the color planes of an RGB image.
%     imRGB = imread('peppers.png');
%     out = imtile(imRGB);
%     imshow(out)
%
%   Example 4
%   ---------
%     % Create a tiled image from an imageDatastore.
%     fileFolder = fullfile(matlabroot,'toolbox','matlab','imagesci');
%     imds = imageDatastore(fileFolder,'FileExtensions',{'.tif','.png'});
%     out1 = imtile(imds);
%     imshow(out1);
%
%     % Add a blue border in the tiled image.
%     out2 = imtile(imds, 'BorderSize', 10, 'BackgroundColor', 'b');
%     figure;
%     imshow(out2);
%
%   See also MONTAGE, IMAGEBROWSER, IMSHOW, IMREAD.

%   Copyright 2018 The MathWorks, Inc.

[Isrc,cmap,gridSize,indices, thumbnailSize, borderSize, backgroundColor] = ...
    parse_inputs(varargin{:});

% Waitbar should never be used from imtile
waitbarEnabled = false;

out = images.internal.createMontage(Isrc, thumbnailSize,...
    gridSize, borderSize, backgroundColor, indices, cmap, waitbarEnabled);

end

function flag = isStringOrChar(x)
    flag = isstring(x) || ischar(x);
end

function[I,cmap,gridSize,idxs, thumbnailSize, borderSize, backgroundColor] = ...
    parse_inputs(varargin)

narginchk(1, 12);

% Initialize variables
thumbnailSize = [];
cmap = [];
gridSize = [];
borderSize = [0 0];
backgroundColor = [];

I = varargin{1};
if iscell(I)
    nframes = numel(I);

    % Error out for mix and match of filenames and images
    isFileName = isStringOrChar(I{1});

    % If the first value in cell array is file name, all the entries should
    % be filenames else no entries should be filename
    if isFileName
        if ~all(cellfun(@isStringOrChar, I))
            error(message('MATLAB:images:montage:mixedInput'));
        end
    else
        if ~all(~cellfun(@isStringOrChar, I))
            error(message('MATLAB:images:montage:mixedInput'));
        end
    end

elseif isstring(I)
    nframes = numel(I);

elseif ischar(I)
    % If char : imtile('peppers.png'), convert the filename to string
    I = string(I);
    varargin{1} = I;
    nframes = 1;

elseif isa(I,'matlab.io.datastore.ImageDatastore')
    nframes = numel(I.Files);

else
    validateattributes(I, {'uint8' 'double' 'uint16' 'logical' 'single' 'int16'}, {}, ...
        mfilename, 'I, BW, or RGB', 1);
    if ndims(I)==4 % MxNx{1,3}xP
        if size(I,3)~=1 && size(I,3)~=3
            error(message('MATLAB:images:montage:notVolume'));
        end
        nframes = size(I,4);
    elseif ndims(I)>4
            error(message('MATLAB:images:montage:notVolume'));
    else
        nframes = size(I,3);
    end
end

varargin(2:end) = stringToChar(varargin(2:end));
charStart = find(cellfun('isclass', varargin, 'char'),1,'first');

idxs = [];

if isempty(charStart) && nargin==2 || isequal(charStart,3)
    % IMTILE(X,MAP)
    % IMTILE(X,MAP,Param1,Value1,...)
    cmap = varargin{2};
end

if isempty(charStart) && (nargin > 2)
    error(message('MATLAB:images:montage:nonCharParam'))
end


paramStrings = {'GridSize', 'Frames', 'ThumbnailSize', 'BorderSize', 'BackgroundColor'};
for k = charStart:2:nargin
    param = lower(varargin{k});
    inputStr = validatestring(param, paramStrings, mfilename, 'PARAM', k);
    valueIdx = k + 1;
    if valueIdx > nargin
        error(message('MATLAB:images:montage:missingParameterValue', inputStr));
    end
    
    switch (inputStr)
        case 'GridSize'
            gridSize = varargin{valueIdx};
            validateattributes(gridSize,{'numeric'},...
                {'vector','positive','numel',2}, ...
                mfilename, 'GridSize', valueIdx);
            if all(~isfinite(gridSize))
                gridSize = [];
            else
                gridSize = double(gridSize);
                t = gridSize;
                t(~isfinite(t)) = 0;
                validateattributes(t,{'numeric'},...
                    {'vector','integer','numel',2}, ...
                    mfilename, 'GridSize', valueIdx);
            end
            
        case 'ThumbnailSize'
            thumbnailSize = varargin{valueIdx};
            if ~isempty(thumbnailSize)
                validateattributes(thumbnailSize,{'numeric'},...
                    {'vector','positive','numel',2}, ...
                    mfilename, 'ThumbnailSize', valueIdx);
                if all(~isfinite(thumbnailSize))
                    thumbnailSize = [];
                else
                    thumbnailSize = double(thumbnailSize);
                    t = thumbnailSize;
                    t(~isfinite(t))=0;
                    validateattributes(t,{'numeric'},...
                        {'vector','integer','numel',2}, ...
                        mfilename, 'ThumbnailSize', valueIdx);
                end
            end
            
        case 'Frames'
            validateattributes(varargin{valueIdx}, {'numeric','logical'},...
                {'integer','nonnan'}, ...
                mfilename, 'Frames', valueIdx);
            idxs = varargin{valueIdx};
            idxs = idxs(:);
            if islogical(idxs)
                if numel(idxs) > nframes
                    error(message('MATLAB:images:montage:logicalArrayLarger'));
                end

                % Convert logical array mask to Indices
                idxs = find(idxs);
            end

            invalidIdxs = ~isempty(idxs) && any(idxs < 1) || any(idxs > nframes);
            if invalidIdxs
                error(message('MATLAB:images:montage:invalidFrames'));
            end
            idxs = double(idxs(:));

            if isempty(idxs)
                % Empty image if idxs was explicitly set to []
                I = [];
            end

        case 'BorderSize'
            borderSize = varargin{valueIdx};
            if isscalar(borderSize)
                borderSize = [borderSize, borderSize]; %#ok<AGROW>
            end
            validateattributes(borderSize, {'numeric', 'logical'},...
                {'integer', '>=',0 , 'numel', 2, 'nrows', 1}, ...
                mfilename, 'BorderSize', valueIdx);
            borderSize = double(borderSize);
            
        case 'BackgroundColor'
            backgroundColor = varargin{valueIdx};
            backgroundColor = convertColorSpec(images.internal.ColorSpecToRGBConverter,backgroundColor);
            backgroundColor = images.internal.touint8(backgroundColor);
            backgroundColor = reshape(backgroundColor, [1 1 3]);
    end
end

end
