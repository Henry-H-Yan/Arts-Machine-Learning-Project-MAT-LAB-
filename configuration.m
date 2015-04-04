addpath('functions')

warning off;

% -- data path settings -- %
path_data.source = 'data_blocks/Ghissi18/';
path_data.enhanced = 'data_enhanced/';
path_data.blocks = 'data_blocks/';
path_data.planes = 'data_colorplanes/';
path_data.target = 'results/';
path_data.final_result = [path_data.target 'final/']; 

% -- general settings -- %
general.max_block_size = 1024;
general.block_overlap = 32;
general.escape_char = '/';
general.filename_color = 'color.tif';
general.filename_gray = 'gray.tif';
general.filename_hsv_h = 'hsv_h.tif';
general.filename_hsv_s = 'hsv_s.tif';
general.filename_hsv_v = 'hsv_v.tif';
general.filename_rgb_r = 'rgb_r.tif';
general.filename_rgb_g = 'rgb_g.tif';
general.filename_rgb_b = 'rgb_b.tif';

% -- anisotropic diffusion -- %
param_aniso.num_iter = 10; 
param_aniso.delta_t = 1/30;
param_aniso.kappa = 80;
param_aniso.option = 2;

% -- elongated filters -- %
param_elongfilt.filtersize = [41 41];
param_elongfilt.filterlength = 3;
param_elongfilt.sigma = [2 2]; 
param_elongfilt.halfcrackwidth = 3; 
param_elongfilt.nsteps = 0:0.1:1;
param_elongfilt.th1 = 30; 
param_elongfilt.th2 = 20;
param_elongfilt.path_result = [path_data.target 'matched/']; 

% -- Top Hat transform -- %
param_tophat.se_size = 3:4;
param_tophat.path_result = [path_data.target 'mscale/']; 

% -- k-SVD -- %
addpath(genpath('/Users/bcorneli/Documents/MATLAB/KSVD/ompbox'));
addpath(genpath('/Users/bcorneli/Documents/MATLAB/KSVD/ksvdbox'));
param_ksvd.blocksize = 16;
param_ksvd.dictsize = 128;
param_ksvd.iternum = 20;
param_ksvd.Tdata = 1;
param_ksvd.trainnum = 50000;
param_ksvd.memusage = 'high';
param_ksvd.verbose = 't';
param_ksvd.th1 = 0.2; 
param_ksvd.th2 = 0.15;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
param_ksvd.thresh = 0.17   %% THRESHOLD!

%%%           - Input Training Graphs    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

param_ksvd.path_training = ['data_ksvdtraining/test20.tif']


%% training from enhanced image
%param_ksvd.path_training = ['data_blocks/21_enhanced/01_enhanced.tif'];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



param_ksvd.path_result = [path_data.target 'ksvd/'];

% -- Postprocessing: kmeans -- %

% Feature vector description
% 1 - density 
% 2-8 - crack colors (rgb,hsv,gray)
% 9-15 - border colors (rgb,hsv,gray)
% 16 - orientation
% 17 - length
% 18 - eccentricity
% 19 - convex area

post_proc.selectedFeatures = [1:12];
% post_proc.selectedFeatures = [1:3];