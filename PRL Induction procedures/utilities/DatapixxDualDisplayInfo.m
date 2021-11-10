function DatapixxDualDisplayInfo()
% DatapixxDualDisplayInfo()
%
% Describes implementation of dual synchronized displays using Datapixx.
%
% Also see: DatapixxStereoDemo
%
% History:
%
% Oct 1, 2009  paa     Written

fprintf('\n');
fprintf('The Datapixx has two VGA (analog video) outputs.\n');
fprintf('These outputs operate in either \"mirrored\" or \"split screen\" mode.\n');
fprintf('\n');
fprintf('The default operating mode is \"mirrored\". In this mode, the two VGA outputs\n');
fprintf('show the same image. One application might be to send one image to a subject\n');
fprintf('and send the second image to the operator station, for monitoring the test.\n');
fprintf('\n');
fprintf('The second operating mode is \"split screen\". In this mode, VGA OUT 1 shows\n');
fprintf('the left half of the image, and VGA OUT 2 shows the right half of the image.\n');
fprintf('Because the two VGA outputs are generated from a single DVI source image,\n');
fprintf('the two outputs are guaranteed to remain perfectly synchronized at all times.\n');
fprintf('Using this strategy, the image generation software only needs to maintain one\n');
fprintf('window/imaging context, with a single \"flip\" command, for generating dual\n');
fprintf('synchronized displays such as those used in Haploscopes.\n');
fprintf('\n');
fprintf('The Datapixx automatically switches between mirrored and split screen mode,\n');
fprintf('depending on the horizontal and vertical resolution of the DVI video input.\n');
fprintf('If the horizontal resolution is less than 2x the vertical resolution, then\n');
fprintf('the VGA outputs operate in mirrored mode. If the horizontal resolution is\n');
fprintf('2x the vertical resolution, or greater, then split screen mode is used.\n');
fprintf('For example, if the DVI generates a 2560 x 1024 image, then the Datapixx will\n');
fprintf('split it into two 1280 x 1024 displays. This default behaviour can be overridden\n');
fprintf('using the Datapixx SetVideoHorizontalSplit command.\n');
fprintf('\n');
fprintf('The utilities used to generate unusual DVI resolutions (like 2560 x 1024) depend\n');
fprintf('on the host operating system.  For example:\n');
fprintf('  -OS X users could download SwitchResX at http://www.madrau.com/indexSRX4.html\n');
fprintf('  -Windows could use PowerStrip from http://www.entechtaiwan.com/util/ps.shtm\n');
fprintf('  -Linux users are often able to write their own video driver \"mode lines\"\n');
fprintf('\n');
