function [d, errmsg] = read_adcp_codas(instclass, file_or_struct, varargin)
% [data, errmsg] = read(C:\Users\Erasmo\Downloads\matlab codas\matlab\rawadcp\rdi\@wh, file_or_struct, varargin)
% instclass: bb
%
% file_or_struct:  
%     file:  typical usage for a one-time call to look at the data
%             file is the relative path to full raw file name, eg:
%                   '../raw/adcp_pings/9602078r.019'
%     struct: specialized usage for repeated calls (as in "load_enr")
%             uses info from a previous read OF THE SAME FILE 
%             (read the top of this file for more details)
% 
% assume varargin is a collection of name, values pairs
% 'vars', {'vel', 'cor', 'amp', 'ts', 'bt', 'pg', 'nav', 'all'}
% i.e. aquisition of single data types  in a cellarray called 'vars'
%     include any or all in the cellarray to turn them on
% -- or -- if there is only one variable, it can be a string 
% 'vars', 'ts' %(gets soundsped, temperature, roll, pitch, heading, xducerdepth)
% -- or --  use the string 'all' to get all variables possible
% 'vars', 'all'
%% 
% 'yearbase', [yearbase]           % optional: default is first year in the file
% 'proc_yearbase'  = [];            %default: cfg.yearbase
%
%  'angle'    [beam angle]           % beam angle from vertical (unnecessary:
%                                    %      only here for compatibility)
%                                  % different ways to specify data extracted:
% 'irange',  [istart istop]        % range of indices to use
% 'ilist', [ index list]           % explicit index list overrides step
% 'step', [step]                   % use only every "step" index
% 'ends', [choose from 0,1,2,4]    % 0 (default - don't do it)
%                                  % 1: get only first profile
%                                  % 2: get first and last profile
%                                  % 3: not implimented
%                                  % 4: get first and last pair of profiles
%                                  % NOTE: use of 'ends' overrides range, step,
%                                  %    and ens_list
% 'back_to_front' [0 or 1]         %   find last good index by reading file
%                                      from back to front (default)
%                                      (otherwise back_to_front = 0 starts
%                                      at the beginning of the file -
%                                      slower but more reliable)
%
%
% 'verbose' [0,1]                  %default is 0; add verbosity
% 'quiet'   [0,1]                  %for consistency with os/read.m (does nothing)
%
%  NOTE on ranges: default is 1:end
%       You may only use one of the following choices.  
%       -  ilist
%       -  irange (step is optional, defaults to 1) - overrides ilist
%       -  ends  - overrides ilist and irange
% 
%  typical one-time usage:
%  rawfile =  '../raw/adcp_pings/nbp2001_091_52596.raw';
%  data = read(bb, rawfile, 'vars', 'amp');
%  data = read(bb, rawfile, 'vars', {'vel', 'ts'});
%  data = read(bb, rawfile, 'yearbase', 2001, 'vars', 'all');
%
%  useful restructuring call:
%  [dd, config] = restruct(bb, data);


%%% ADITIONAL NOTES %%%
%  NOTE a structure called "info" in the outgoing data structure contains
%         - info.fullrawfile        %the whole path to the file
%         - info.rawfilebase        %the base of the file read 
%         - info.ilist              %the index list used to get the data
%                                   % NOTE: must use name, value pair with
%                                   % name 'ilist' to choose the values to
%                                   % be read
%         - info.nbytes             % 
%         - info.config             %
%         - info.last_index         % 
%
%  NOTE file_or_struct - usage with a structure
%          previous call should explicitly output additional info:
%             "d = read(instclass, file_or_strut, 'return_fid', 1, varargin)
%          then call as either
%             "d = read(instclass, d.info , 'return_fid', 1, varargin)
%                                   % does not close raw file upon return
%             "d = read(instclass, d.info , varargin) 
%                                   % closes file upon return
%
%  NOTE ens_num is the raw ensemble value contained in the data.  There could
%       potentially be gaps in ens_num, but it should always increase (with 
%       the single exception of a wrap which occurs at 2^16)
%
% Modificado por Erasmo, ripeado de codas
% uso: c=read_adcp_codas('bb','archivo.lta','vars','all'); %codas

% 00/01/31 EF
% 00/02/22 JH (bb from read_os)
% 00/07/05 JH (fixed ipp bug (here and in read_os))  
%  *** NOTE: fix was insufficient - check read_os and fix the fix
% 01/06/02 JH  add instrument class: modify  to match bb/read.m and 
%        nb/read.m since that is the most recent 
% 02/05/23 JH bug fix: now not overwriting config fields:
%                   soundspeed, bin1distance, tr_pressure


%% undocumented features:
%% 'vars' defaults to none, turn on pieces or 'all' exlicitly
%% range defaults to all; choose specific subsets explicitly

% should make it so all cfg fields are initialized - then use fillstruct(x,x,0)
%    to help with debugging (i.e. fail if a new field is introduced)


errmsg = [];

if (nargin < 2)
   help read 
   error('must set instclass and file_or_struct')
end

id_arg = 0;               % (instclass = os ONLY)
                          % Call with 1 instead of zero to get NB if both NB
                          % and BB are being collected.


%set defaults.  all except field "vars" are present in the original
%  cfg structure; fillstruct will update the values listed
%  Field "vars" will be initialized by fillstruct.  set those chosen to 1
cfg.yearbase  = [];  %default: use first year in the file
cfg.proc_yearbase  = [];  %default: use first year in the file
cfg.verbose     = 0;
cfg.quiet       = 0;
cfg.step        = 1;
cfg.irange    = []; % default all range specifications to [] (see function
cfg.ilist     = []; % default all range specifications to [] test_range_request
cfg.back_to_front = 1;  %find last_index by reading back to front
cfg.ends      = []; % default all range specifications to []
cfg.beamangle     = NaN; % beam angle
cfg.vars =      [];% default variables to []
vars            = {'vel', 'cor', 'amp', 'ts', 'bt', 'pg', 'nav', 'all'};
out.nav         = 0; %initialized "out" as a nonempty structure 


% structure "out" fields from "vars" cellarray initialized as zero
for cii = 1:length(vars)
   out = setfield(out, vars{cii}, 0); 
end


% update cfg.
if (nargin > 2)%   we'll assume the rest is a set of name,value pairs
               %override input structure with name,value pairs
   cfg = fillstruct(cfg, varargin,0 );
end


%now check whether cellarray 'vars' has been added - use the elements of
% cfg.vars (if it exists) to turn on aquisition of the listed fields
% NOTE: cellarray "vars" does not have "nav", whereas cfg.vars could.
if (isfield(cfg, 'vars'))
   if (~isempty(cfg.vars))
      if (ischar(cfg.vars))  %if there is only variable chosen, allow a string
         cfg.vars = {cfg.vars};
      end
      
      for cii = 1:length(cfg.vars)
         out = setfield(out, cfg.vars{cii}, 1); 
      end
      
      % out.all (override individual chosen data types and output everything)
      if ismember({'all'}, cfg.vars)
         %they turned it on so get everything
         for cii = 1:length(vars)
            out = setfield(out, vars{cii}, 1);
         end
      end
      out = rmfield(out, 'all');  %now remove: there shouldn't be an out.all
   end
end


id = instrument_ids(instclass, id_arg);
params.id = id;
params.out = out;

%had to wait for this to get params initialized
if (ischar(file_or_struct))
   file = file_or_struct;
   if (~exist(file, 'file'))
      error(sprintf('file %s does not exist\n', file))
   end
elseif (isstruct(file_or_struct))
   finfo = file_or_struct;
   file       = finfo.fullrawfile;
   nbytes     = finfo.nbytes;
   config     = finfo.config;
   last_index = finfo.last_index;
else
   error('second argument was not an existing file or appropriate structure')
end

%open and close in here
params.yearbase = cfg.yearbase; %but it might be empty
params.proc_yearbase = cfg.proc_yearbase; %but it might be empty
if (~exist('config', 'var')) % file_or_struct was a file
   [nbytes, last_index, config] = get_config(instclass, params, cfg, file);
end

if (nbytes==0) % error in read: config has string
   d=[];
   errmsg = config;
   return   %jump out now.
end

if isempty(config.proc_yearbase)
    config.proc_yearbase = config.yearbase;
end

ilist = get_ilist(cfg, last_index);

if (isempty(ilist))
   d=[];
   errmsg = '"ilist" failed;'
   return
end

%now initialize everything

NP = length(ilist);  %%1 + floor((stop - start) / step);
NC = config.ncells;
NB = config.nbeams_used;


if out.vel, d.vel = zeros(NC, NB, NP); end
if out.cor, d.cor = zeros(NC, NB, NP); end
if out.amp, d.amp = zeros(NC, NB, NP); end
if out.pg,  d.pg  = zeros(NC, NB, NP); end
if out.ts,
   d.heading = zeros(1, NP);
   d.pitch =      d.heading;
   d.roll =       d.heading;
   d.soundspeed = d.heading;
   d.temperature =d.heading;
   d.tr_pressure =d.heading;
end
if out.bt,
   d.bt.vel = zeros(NB, NP);
   d.bt.range = d.bt.vel;
   d.bt.cor =   d.bt.vel;
   d.bt.amp =   d.bt.vel;
   d.bt.pg =    d.bt.vel;
end
if out.nav,
   d.nav.sec_pc_minus_utc = zeros(1, NP);
   d.nav.txy1 = zeros(3, NP);
   d.nav.txy2 = d.nav.txy1;
end

% Always include dday and ens_num.
d.dday = zeros(1, NP);
d.ens_num = zeros(1, NP);
d.num_pings = zeros(1, NP);
d.config = config;
if ~isnan(cfg.beamangle)
   d.config.beamangle = cfg.beamangle;
end

d.depth =  [d.config.bin1distance + (0:(NC-1)) * d.config.cell]';

% now loop through ilist
fid = fopen(file, 'r', 'ieee-le');
for ii = 1:length(ilist)
   if (cfg.verbose) ii, end
   
   fseek(fid, nbytes * (ilist(ii) - 1), 'bof');
   [buf, config] = read_buf(instclass, fid, params, config);
   
   if ischar(buf),
      errmsg = buf;
      d.error = buf;
      break
   end
   d.dday(ii) = buf.dday;
   d.ens_num(ii) = buf.ens_num;
   d.num_pings(ii) = buf.num_pings;
   if out.ts,
      d.heading(ii) = buf.heading;
      d.pitch(ii)   = buf.pitch;
      d.roll(ii)    = buf.roll;
      d.soundspeed(ii)  = buf.soundspeed;
      d.temperature(ii) = buf.temperature;
      d.tr_pressure(ii) = buf.tr_pressure;
   end
   if out.vel, d.vel(:, :, ii) = buf.vel; end
   if out.cor, d.cor(:, :, ii) = buf.cor; end
   if out.amp, d.amp(:, :, ii) = buf.amp; end
   if out.pg,  d.pg(:, :, ii) = buf.pg; end
   if out.bt & d.config.bt_was_on
      d.bt.vel(:, ii) = buf.bt.vel;
      d.bt.range(:, ii) = buf.bt.range;
      d.bt.cor(:, ii) = buf.bt.cor;
      d.bt.amp(:, ii) = buf.bt.amp;
      d.bt.pg(:, ii) = buf.bt.pg;
   end
   if out.nav,
      d.nav.sec_pc_minus_utc(ii) = buf.nav.sec_pc_minus_utc;
      d.nav.txy1(:,ii) = buf.nav.txy1;
      d.nav.txy2(:,ii) = buf.nav.txy2;
   end
end

if out.ts,
   d.heading = 0.01 * d.heading;
   d.pitch = 0.01 * to_signed(d.pitch);
   d.roll = 0.01 * to_signed(d.roll);
   d.temperature = 0.01 * to_signed(d.temperature);
end

if out.vel, d.vel = 0.001 * to_signed(d.vel); end

if out.bt & d.config.bt_was_on
   d.bt.vel = 0.001 * to_signed(d.bt.vel);
   d.bt.range = 0.01 * d.bt.range;  % BAD is 0; leave it.
end

%----------------------------------------
%%%% add things which will make our lives easier later, or perhaps not.


%take out things which are not useful:
d.config = rmfield(d.config, 'offsets');
d.config = rmfield(d.config, 'ids');
d.config = rmfield(d.config, 'vel_multiplier');
d.config = rmfield(d.config, 'ndata');
if out.nav %remove nav structure if if was requested but did not exist
   allnav = [d.nav.sec_pc_minus_utc(:); d.nav.txy1(:); d.nav.txy2(:)];
   if isempty(find(~isnan(allnav)))
      d = rmfield(d, 'nav');
   end
end


%augment d with some useful information
if (isstr(file_or_struct))
   [fpath, rawfilebase, ext] = fileparts(file);
   d.info.rawfilebase = rawfilebase;
   d.info.fullrawfile = file;
else
   d.info.rawfilebase = finfo.rawfilebase;
   d.info.rawfilebase = finfo.fullrawfile;
end

d.info.ilist = ilist;
d.info.nbytes =     nbytes;
d.info.last_index = last_index;
d.info.config =     config;


if cfg.yearbase ~= cfg.proc_yearbase
    newdday = change_yrbase(newdday, cfg.yearbase, cfg.proc_yearbase);
    d.dday = newdday(:)';
end


fclose(fid);
d.error = [];
end
function config = configinit(instclass)
%initialize config structure for raw read

config.yearbase     = NaN;
config.proc_yearbase     = NaN;
config.nbytes       = NaN;
config.nbeams_used  = NaN;
config.ncells       = NaN;
config.num_pings    = NaN;
config.cell         = NaN;
config.blank        = NaN;
config.pulse        = NaN;
config.bin1distance = NaN;
config.head_align   = 0;
config.head_bias    = 0;
config.bt_was_on    = NaN;
config.tr_pressure  = 0;
config.convex       = NaN;
config.orientation  = NaN;
config.beamangle    = NaN;
config.frequency    = NaN;
config.coordsystem  = NaN;


if (isa(instclass, 'bb') | isa(instclass,'os'))
   config.mode       = NaN;
   config.code_reps  = NaN;
   config.EZ         = NaN;
   config.lag        = NaN;
   config.sensornames = {'temp', 'cond', 'roll', 'pitch', 'head', ...
                    'press', 'sspeed'};
   
   if (isa(instclass, 'os'))
      config.pingtype = NaN;
      
   end
end

end
function c = decode_sysconfig(l, m)
% called by @instclass/read_buf.m
  
freqs = [75, 150, 300, 600, 1200, 2400, 38];
freqbits = bitand(l, 7);
c.frequency = freqs(1 + freqbits);
c.up =  bitand(bitshift(l, -7), 1);
c.convex = bitand(bitshift(l, -3), 1);

angles = [15, 20, 30, NaN];
anglebits = bitand(m, 3);
c.angle = angles(1 + anglebits);

end
function [defstruct] = fillstruct(defstruct, newarg, append);
% [nameval_struct] = fillstruct(defstruct, newarg, append);
% takes default structure and updates the fields with values from newargs.
%
% newargs:   can be a structure or a 1-dimensional cellarray 
%                 if newarg is a cellarray, it is used as {name},{value} pairs
% append:     allows creation of new structure elements from newargs
% append = 0 (DEFAULT; add the new name.value pairs to defstruct)
% append = 1 (fail if any newargs fields are not present in defstruct)
%
% useage:
% updated_struct = fillstruct(defstruct, varargin)

%Jules 2000/10/31
%Jules 2003/11/05: changed the 'append' default to FALSE

program_name = 'fillstruct';

% error checking ------------------------------

if ((nargin ~= 2) & (nargin ~= 3))
   help(program_name)
   error('must specify 2 or 3 arguments')
end

if (nargin == 2)
   append = 0;
end

   
if (~isstruct(defstruct))
   help(program_name)
   error('first argument must be the structure of default values')
end

% check second argument: make into a structure ----------

if (isempty(newarg))  %just return the input if no new args
   return
end


if (iscell(newarg)) %make sure it has an even number of elements
   if (rem(length(newarg),2) ~= 0)
      newarg
      error('newarg must have name, value _pairs_')
   end
   %there has to be a better way...    % too bad this doesn't work:
   % struct = cell2struct(cell{1:2:end}, cell{2:2:end},2)
   newargs = struct(newarg{1},newarg(2));
   for num = 3:2:length(newarg)
      newargs = setfield(newargs, newarg{num}, newarg{num+1});
   end
elseif (isstruct(newarg)) %rename it if it is a structure
   newargs = newarg;
else
   error('second argument must be a cellarray or a structure')   
end

% assign or bomb out ------------------------------

def_fnames = sort(fieldnames(defstruct));  %default fieldnames
new_fnames  = sort(fieldnames(newargs));   %new fieldnames

for fni = 1:length(new_fnames)
   if (~isfield(defstruct, new_fnames{fni}) & ~append)
      error(sprintf('field "%s" does not exist in default structure',...
                    new_fnames{fni}))
   end
   %now update it anyway 
   defstruct = setfield(defstruct, new_fnames{fni}, ...
                                   getfield(newargs,new_fnames{fni}));
end

end
function [nbytes, last_index, config] = get_config(instclass,params, cfg, file)
% read by @nb/read.m, @os/read.m and @bb/read.m
% read the file; look for errors
% if read_buf finds an error to abort on, returns config as the error msg string


% the BB and OS processors write little-endian
% the NB processor writes big-endian
if isa(instclass, 'nb')
   fid = fopen(file, 'r', 'ieee-be');  
else  %insclass is 'os' or 'bb'
   fid = fopen(file, 'r', 'ieee-le');  
end

%initialize so there is a return value in case of early exit
nbytes = 0;
last_index = [];
config = [];

[buf, config] = read_buf(instclass, fid, params);  % First time: read config.

%otherwise, continue.   
if ischar(buf)
   config = buf;
   return;
end


fseek(fid, 0, 'eof');
len_file = ftell(fid);      % total number of bytes                            
nbytes = config.nbytes + 2; % bytes remaining in record up to but not including
                            %    the checksum, plus  2 for the checksum        
last_index = floor(len_file / nbytes);  %%% This is a bug?? used to be      
fclose(fid);                                %%% floor(len_file / nbytes) - 1


if (~cfg.back_to_front)    %start at the front

   % the BB and OS processors write little-endian
   % the NB processor writes big-endian
   if isa(instclass, 'nb')
      fid = fopen(file, 'r', 'ieee-be');  
   else
      fid = fopen(file, 'r', 'ieee-le');  
   end

   % ok to keep reading, since it's the same direction   
   fseek(fid, 0, 'bof');
   keepreading = 1;
   
   last_good_index = 0;
   while keepreading
      buf = [];
      fseek(fid, nbytes * (last_good_index), 'bof'); %use ilist
      try
         [buf] = read_buf(instclass, fid, params, config);
      catch
         if (cfg.verbose)
            fprintf('exited read early: last good index is %d \n', last_index)
         end
         break
      end 
      
      if (isstr(buf))
         if (cfg.verbose)
            fprintf('buf returns %s\n',buf)
         end
         break
      end
      last_good_index = last_good_index + 1;
      if (last_good_index == last_index)
         break
      end
   end
   fclose(fid);
   
else     %  cfg.back_to_front is true 
   % the BB and OS processors write little-endian
   % the NB processor writes big-endian
   if isa(instclass, 'nb')
      fid = fopen(file, 'r', 'ieee-be');  
   else
      fid = fopen(file, 'r', 'ieee-le');  
   end
   
   fseek(fid, 0, 'eof');        % total number of bytes
   len_file = ftell(fid);       % bytes remaining in record up to but not 
   nbytes = config.nbytes + 2;  %  including the checksum, +2 for the checksum
   last_index = floor(len_file / nbytes); %%% This is a bug?? used to be      
                                              %%% floor(len_file / nbytes) - 1
   % revise the last good index
   for last_good_index = last_index:-1:1
      
      buf = [];
      fseek(fid, nbytes * (last_good_index - 1), 'bof'); %use ilist
      if (cfg.verbose), last_good_index, end
      try
         [buf] = read_buf(instclass, fid, params, config);
      catch
         if (cfg.verbose)
            fprintf('exited read early at index %d (out of %d):\n', ...
                    last_good_index,  last_index)
         end
      end 
      if (~isstruct(buf))
         if (cfg.verbose)
            fprintf('buf returns %s\n',buf)
         end
      elseif isstruct(buf)
         break
      else
         warning('buf is not struct or string')
      end
   end
   
   % update these things
   fclose(fid);
end

last_index = last_good_index;
end
function [ilist] = get_ilist(cfg, last_index)
% trap for obvious errors
% [1:step:end] overrides ilist overrides irange overrides ends
% 'step' implimented for irange 
% returns empty if nothing applicable found
% returns a row.

%(1)  look for errors
if (~ismember(cfg.ends, [0 1 2 4]))
   error(' option "ends" must be 0,1,2, or 4')
end


if (diff(cfg.irange)<=0)
   error('irange must increase\n')
end


if (length(cfg.irange) > 2)
   fprintf('---> ''irange'' was a list: ')
   fprintf('using index endpoints [%d %d] for range.\n', ...
           cfg.irange(1), cfg.irange(end))
   cfg.irange = cfg.irange([1 end]);
end


% default
ilist = 1:cfg.step:last_index;

% 'ends' overrides 'ilist' overrides 'irange'
if (~isempty(cfg.ends) & (cfg.ends > 0))
   if (cfg.ends == 4)
      ilist = sort(unique([1, 2, (last_index - 1), last_index]));
      ilist = ilist(find(   (ilist <= last_index) & (ilist >= 1)));
   elseif (cfg.ends == 2)
      ilist = sort(unique([1 last_index]));
   else %it has to be 1 because we checked it before
      ilist = 1;
   end
elseif (~isempty(cfg.ilist))  %this was an explicit index list
   ilist = cfg.ilist;
elseif (~isempty(cfg.irange))
   ilist = [cfg.irange(1) : cfg.step : min(cfg.irange(end), last_index)];
end

% make sure it's a row
ilist=ilist(:)';  % 


%toss out indices that are too small
badi = find(ilist < 1);
if (~isempty(badi))
   ilist(badi)=[];
   if (cfg.verbose)
      fprintf('part of ilist smaller than 1: truncating\n')
   end
end

%toss out indices that are too large
badi = find(ilist > last_index);
if (~isempty(badi))
   ilist(badi)=[];
   if (cfg.verbose)
      fprintf('part of ilist excedes last index: truncating after %d\n',...
              last_index)
   end
end
end



function id = instrument_ids(instclass, incr)
%% get offsets for os or bb
if isa(instclass, 'os')
   id.header     = hex2dec('7f7f');
   id.flead      = 0 + incr;
   id.vlead      = hex2dec('0080') + incr;
   id.vel        = hex2dec('0100') + incr;
   id.cor        = hex2dec('0200') + incr;
   id.amp        = hex2dec('0300') + incr;
   id.pg         = hex2dec('0400') + incr;
   id.status     = hex2dec('0500') + incr; % Useless; ignore it.
   id.bt         = hex2dec('0600') + incr;
   % Added in STA and LTA files:
   id.nav        = hex2dec('2000');           % No separate nav type.
   id.fix_att    = hex2dec('3000');       % Or fixed attitude.
   id.var_att1   = hex2dec('30e0');
   id.var_att2   = hex2dec('30e8');
   id.var_att    = id.var_att1; % default: NP only
                             % other possibilities to be added.
else
   id.header     = hex2dec('7f7f');
   id.flead      = hex2dec('0000');
   id.vlead      = hex2dec('0080');          % 128
   id.vel        = hex2dec('0100');          % 256;
   id.cor        = hex2dec('0200');          % 512;
   id.amp        = 768;
   id.pg         = hex2dec('0400');          % 1024;
   id.bt         = 1536;
   id.nav        = 8192;
end

end
function [buf, config] = read_buf(instclass, fid, params, config)
% read a chunk of BB binary data
%

out = params.out;
id = params.id;

if (nargin == 3)
   config = configinit(instclass);   
end


start = ftell(fid);
[hdr, count] = fread(fid, 2, 'uint16');
if count ~= 2,
   buf = sprintf('error 1, only %d bytes at start of buffer\n', count);
   return
end
if hdr(1) ~= id.header % 2 bytes of 7Fh each
   buf = 'error 2, Header ID/Data Source not found in read_buf'; 
   
   return
end

config.nbytes = hdr(2);  % Total bytes up to, not including, checksum.
fseek(fid, start, 'bof'); %go back to same start location


%read the data into rec
[rec, count] = fread(fid, config.nbytes, 'uint8');
if count ~= config.nbytes,
   buf = sprintf('error 3, only %d bytes read, %d expected\n', ...
                 count, config.nbytes);
   return
end

%%% is this right???
test_cs = mod(sum(rec), 65536);
cs = fread(fid, 1, 'uint16');
if test_cs ~= cs,
   buf = ['error 4, Checksum failure; CS is ', int2str(cs),...
          ' versus calculated ', int2str(test_cs)];
   return
end

if nargin == 3, %still  set up config
   buf = [];
   
   config.ndata = rec(6);
   ii = 7 + 2 * (0:(config.ndata-1));
   config.offsets = rec(ii) + 256 * rec(ii+1);
   config.ids = rec(config.offsets + 1) + rec(config.offsets + 2) * 256;


   %%% VMDAS BUG (wherein config.ids(end) should have been navigation (8192) but is zero)
   if config.ids(end)==0;
      config.ids(end) = 8192;
      config.error = 'warning 1, fixed leader incorrect';
      fprintf('WARNING: fixed leader broken. Replacing last ID with navigation ID\n');
   end

   
   
   %   %%% fixed leader:
   %   lsb_base =                 5; 1           %least significant base
   %   msb_base =                 6; 1           %most significant base
   %   nbeams_used_base =         9; 1
   %   ncells_base =             10; 1
   %   pings_per_ens_base =      11; 2
   %   cell_base =               13; 2
   %   blank_base =              15; 2
   %   mode_base =               17; 1
   %   code_reps_base =          19; 1
   %   coord_transf_base =       26; 1
   %   heading_align_base =      27; 2
   %   heading_bias_base =       29; 2
   %   EZ_base =                 31; 1
   %   SA_base =                 32; 1
   %   bin1distance_base =       33; 2
   %   pulse_base =              35; 2
   %   lag_base =                41; 2
      
   ofs = config.offsets(find(config.ids == 0));

   config.nbeams_used =        rec(ofs + 9);
   config.ncells =             rec(ofs + 10);
   config.num_pings =          rec(ofs + 11) + 256 * rec(ofs + 12);
   config.cell =               0.01 * (rec(ofs + 13) + 256 * rec(ofs + 14));
   config.blank =              0.01 * (rec(ofs + 15) + 256 * rec(ofs + 16));
   config.mode =               rec(ofs + 17);
   config.COR_threshold =      rec(ofs + 18);
   config.code_reps =          rec(ofs + 19);
   config.PG_threshold =       rec(ofs + 20);
   config.EV_threshold =       .001*(rec(ofs + 21) + 256 * rec(ofs + 22));
   config.tpp_secs =           rec(ofs + 23)*60 + ...
                               rec(ofs + 24) + rec(ofs + 25)/100;
   config.coord_transf =       rec(ofs + 26);
   config.head_align =         0.01 * (rec(ofs + 27) + 256 * rec(ofs + 28));
   config.head_bias =          0.01 * (rec(ofs + 29) + 256 * rec(ofs + 30));
   config.EZ =                 rec(ofs + 31);
   config.SA =                 rec(ofs + 32);
   config.pulse =              0.01 * (rec(ofs + 35) + 256 * rec(ofs + 36));
   config.bin1distance =       0.01 * (rec(ofs + 33) + 256 * rec(ofs + 34));
   config.lag =                0.01 * (rec(ofs + 41) + 256 * rec(ofs + 42));
   config.cpu_serialnumber =   2^(0*8) * rec(ofs + 43) + ...
                               2^(1*8) * rec(ofs + 44) + ...
                               2^(2*8) * rec(ofs + 45) + ...
                               2^(3*8) * rec(ofs + 46) + ...
                               2^(4*8) * rec(ofs + 47) + ...
                               2^(5*8) * rec(ofs + 48) + ...
                               2^(6*8) * rec(ofs + 49) + ...
                               2^(7*8) * rec(ofs + 50);
   config.WB =                 rec(ofs + 51) + 256 * rec(ofs + 52);   
   config.pingtype = 'bb';
   
   lsb = rec(ofs + 5);
   msb = rec(ofs + 6);
   %%% need to fix this
   config.vel_multiplier = .001;  % m/s per count
   config.sysconfig = decode_sysconfig(lsb, msb);
   
   %find out whether BT was on or not
   ofs = min(config.offsets(find(config.ids == id.bt)));
   if isempty(ofs)
      config.bt_was_on = 0;
      config.bt.BP = NaN;
      config.bt.BC = NaN;
      config.bt.BA = NaN;
      config.bt.BX = NaN;
   else
      config.bt_was_on = 1;
      config.bt.BP = rec(ofs + 3) + 256 * rec(ofs + 4);
      config.bt.BC = rec(ofs + 7);
      config.bt.BA = rec(ofs + 8);
      config.bt.BX = rec(ofs + 71) + 256 * rec(ofs + 72);
   end      

   % make these have a more uniform nomenclature
   config.convex  = config.sysconfig.convex;
   if (config.sysconfig.up)
      config.orientation = 'up';
   else
      config.orientation = 'down';
   end
   
   config.beamangle = config.sysconfig.angle;
   config.frequency = config.sysconfig.frequency;
   
   % coordinate system
   instrument = 2^3;
   ship = 2^4;
   earth = 2^3+2^4;
   if (bitand(config.coord_transf, instrument) == 0) & ...
          (bitand(config.coord_transf, ship) == 0)
      config.coordsystem = 'beam';  % no transformation   xxx00xxx
   elseif (bitand(config.coord_transf, earth) == earth)
      config.coordsystem = 'earth';                    %  xxx11xxx
   elseif (bitand(config.coord_transf, instrument) == instrument)
      config.coordsystem = 'xyz';                      %  xxx10xxx
   elseif (bitand(config.coord_transf,ship) == ship)
      config.coordsystem = 'ship';                    %  xxx11xxx
   else
      fprintf('coordinate system error (EX) in %s\n', mfilename)
      config
   end

   config.sysconfig.cal_sspeed =  bitand(config.EZ, 2^6)/(2^6);
   
end

%otherwise, get data

%%% fixed leader, but possibly variable data:
ofs = config.offsets(find(config.ids == id.flead));
buf.num_pings = rec(ofs + 11) + 256 * rec(ofs + 12);

%%% variable leader:
ofs = config.offsets(find(config.ids == id.vlead));
if nargin == 3,
   config.tr_pressure = (rec(ofs + 17) + 256 * rec(ofs + 18))/10;
end
buf.ens_num = rec(ofs + 3) + 256 * rec(ofs + 4) + 65536 * rec(ofs + 12);

ymdhms = rec(ofs + (5:11));
ymdhms(1) = ymdhms(1) + 1900;
if (ymdhms(1) < 1980)  ymdhms(1) = ymdhms(1) + 100; end


if isempty(params.yearbase) 
   config.yearbase = ymdhms(1);
else
   config.yearbase = params.yearbase;
end
if isempty(params.proc_yearbase)
    config.proc_yearbase = config.yearbase;
else
    config.proc_yearbase = params.proc_yearbase;
end

buf.dday = to_day( config.yearbase, ymdhms(1:6).') + ymdhms(7) / 8640000;



if (nargin == 3)
   return
end

%% otherwise, get data ============================================

if out.ts
   buf.heading =        rec(ofs + 19) + 256 * rec(ofs + 20);
   buf.pitch   =        rec(ofs + 21) + 256 * rec(ofs + 22);
   buf.roll    =        rec(ofs + 23) + 256 * rec(ofs + 24);
   buf.temperature =    rec(ofs + 27) + 256 * rec(ofs + 28);
   buf.soundspeed =     rec(ofs + 15) + 256 * rec(ofs + 16);
   buf.tr_pressure =       (rec(ofs + 17) + 256 * rec(ofs + 18))/10;
end
% In the following blocks, the "min" should not be needed
% when finding the offsets; we may eliminate it.
% The empty check is needed, however.

%%% velocity:
if out.vel
   ofs = min(config.offsets(find(config.ids == id.vel)));
   ii = 2 + (1:2:(config.ncells*8));
   if isempty(ofs),
      a = NaN * ii;
   else
      a = rec(ofs + ii) + 256 * rec(ofs + 1 + ii);
   end
   buf.vel = reshape(a, 4, config.ncells).';
   % We are deferring the handling of negative numbers and NaNs.
end


%%% correlation:
if out.cor
   ofs = min(config.offsets(find(config.ids == id.cor)));
   ii = 2 + (1:(config.ncells*4));
   if isempty(ofs)
      buf.cor = reshape(ii, 4, config.ncells).';
   else
      buf.cor = reshape(rec(ofs + ii), 4, config.ncells).';
   end
end

%%% amp:
if out.amp
   ofs = min(config.offsets(find(config.ids == id.amp)));
   ii = 2 + (1:(config.ncells*4));
   if isempty(ofs)
      buf.amp = reshape(ii, 4, config.ncells).';
   else
      buf.amp = reshape(rec(ofs + ii), 4, config.ncells).';
   end
end


%%% percent good:
if out.pg
   ofs = min(config.offsets(find(config.ids == id.pg)));
   ii = 2 + (1:(config.ncells*4));
   if isempty(ofs)
      buf.pg = reshape(ii, 4, config.ncells).';
   else
      buf.pg = reshape(rec(ofs + ii), 4, config.ncells).';
   end
end

%%% status starts at 1280


%% BT:
if out.bt & config.bt_was_on
   ofs = min(config.offsets(find(config.ids == id.bt)));
   ii = (0:2:6); iii = 0:3;

   buf.bt.range = rec(ofs + ii + 17) + 256 * rec(ofs + ii + 18) + ...
       65536 * rec(ofs + iii + 78);
   
   buf.bt.vel = rec(ofs + ii + 25) + 256 * rec(ofs + ii + 26);
   buf.bt.cor = rec(ofs + iii + 33);
   buf.bt.amp = rec(ofs + iii + 37);
   buf.bt.pg  = rec(ofs + iii + 41);


   badi = find(buf.bt.pg)==0;
   if ~isempty(badi)
      buf.bt.range(badi)=0;
      buf.bt.cor(badi)=0;
      buf.bt.amp(badi)=0;
   end      
   


end

if out.nav
   ofs = min(config.offsets(find(config.ids == id.nav)));
   if isempty(ofs)
      buf.nav.sec_pc_minus_utc = NaN;
      buf.nav.txy1 = NaN * ones(3,1);
      buf.nav.txy2 = buf.nav.txy1;
   else
      buf.nav.sec_pc_minus_utc = 1e-3 * buf_long(rec(ofs + (11:14)));

      %why are we doing this when buf.ymdhms is already defined above?
      %yymd = [config.yearbase, rec(ofs + 5) + 256 * rec(ofs + 6),...
      %        rec(ofs + 4) , rec(ofs + 3)];
      day_base = to_day(config.yearbase, ymdhms(1:3)');
      t1d = day_base + (1e-4 / 86400) * buf_long(rec(ofs + (7:10)));
      t2d = day_base + (1e-4 / 86400) * buf_long(rec(ofs + (23:26)));
      
      buf.nav.txy1(1) = t1d + round(buf.dday - t1d);
      buf.nav.txy2(1) = t2d + round(buf.dday - t2d);
      buf.nav.txy1(2:3) = decode_fix(rec(ofs + (15:22)));
      buf.nav.txy2(2:3) = decode_fix(rec(ofs + (27:34)));
   end
end


%% look for a bug in navigation:
ofs = min(config.offsets(find(config.ids == id.nav)));
if ~isempty(ofs)
   hms1 = buf_long(rec(ofs + (7:10)));
   hms2 = buf_long(rec(ofs + (23:26)));

   nav1 =  decode_fix(rec(ofs + (15:22)));
   nav2 =  decode_fix(rec(ofs + (27:34)));

   % flag ensemble if VmDAS has screwed up
   
   %(this is the signature of a bad serial time stamp)
   if (((hms1 == 0) & (nav1(1) == 0) & (nav1(2)==0)) | ...
       ((hms2 == 0) & (nav2(1) == 0) & (nav2(2)==0)) )
      fprintf('WARNING: bad navigation data likely at ensemble %d (%s)\n',...
              buf.ens_num, to_date(config.yearbase,buf.dday,'s'))
      buf.nav.txy1(1:3) = NaN;
      buf.nav.txy2(1:3) = NaN;
   end
end
end

%---------------------------------------------
function s = to_signed_long(u)
s = u;
ineg = u > 2147483647 ;
s(ineg) = s(ineg) - 4294967296;
ibad = s == -2147483648;
s(ibad) = NaN;
end
%---------------------------------------------
function s = buf_long(a)
s = a(1) + 256 * a(2) + 65536 * a(3) + 16777216 * a(4);
s = to_signed_long(s);
end
%---------------------------------------------
function xy = decode_fix(r)
xy = [buf_long(r(5:8)); buf_long(r(1:4))] * 180 / 2147483648;

%---------------------------------------------
end
function dd = to_day(year_base, year, month, day, hour, minute, second)
%        dd = to_day(year_base, year, month, day, hour, minute, second)
% or          to_day(year_base, [year month day hour minute second])
%
% returns decimal-day equivalent of arg
% >>>year and year_base are total, NOT just last 2 digits<<<
% hour, minute, second are optional, set to 0 by default
% Input arguments may be column or row vectors, except that
% year_base may be a scalar or a vector.
% With 2 arguments, the second must have 3-6 columns
% Output argument is a column vector.
%
%  This function is obsolete; use Matlab's datenum instead.
%


% 93/02/10 JR
% 95/12/03 EF and JH modified for matrix input, vector output.
% 2004/05/10 EF changed to use Matlab's own date routines

if nargin == 7
    d1 = datenum(year, month, day, hour, minute, second);
elseif nargin == 4
    d1 = datenum(year, month, day);
elseif nargin == 2
    [nr, nc] = size(year);
    if nc == 6,
        d1 = datenum(year(:,1), year(:,2), year(:,3), ...
            year(:,4), year(:,5), year(:,6));
    elseif nc == 3,
        d1 = datenum(year(:,1), year(:,2), year(:,3));
    elseif nc == 5,
        d1 = datenum(year(:,1), year(:,2), year(:,3), ...
            year(:,4), year(:,5), zeros(nr,1));
    elseif nc == 4,
        d1 = datenum(year(:,1), year(:,2), year(:,3), ...
            year(:,4), zeros(nr,1), zeros(nr,1));
    else
        help to_day
        error('With 2 arguments, the second must have 3-6 columns')
    end
else
    help to_day
    error('Requires 2, 4, or 7 arguments')
end

d0 = datenum(year_base, 1, 1); % datenum is 1 on 0,1,1,0,0,0
dd = d1 - d0;
return



if 0  % old version
    
    [nr_year, nc_year] = size(year);
    if nargin < 2 | (nargin > 2 & nargin < 4) | (nargin == 2 & nc_year < 3)
        help to_day
        error('Insufficient argument list')
    end
    
    if (nargin == 2)
        n_secs = nr_year;
    else
        n_secs = nr_year * nc_year;
    end
    
    hh = zeros(n_secs,1);   % optional args default
    mm = hh;
    ss = hh;
    
    if nargin == 2  % vector form
        if nc_year > 3
            hh = year(:,4);
            if nc_year > 4
                mm = year(:,5);
                if nc_year > 5
                    ss = year(:,6);
                end
            end
        end
        month = year(:,2);
        day   = year(:,3);
        year  = year(:,1);
    else
        if nargin > 4
            hh = hour(:);
            if nargin > 5
                mm = minute(:);
                if nargin > 6
                    ss = second(:);
                end
            end
        end
        month = month(:);
        day   = day(:);
        year  = year(:);
    end
    
    if (any(year < 1000) | any(year_base < 1000))
        disp('WARNING: in to_day, year and year_base should be full,')
        disp(' not year-1900');
    end
    
    if (  length(year) ~= n_secs | length(month) ~= n_secs ...
            | length(day)  ~= n_secs | length(hh)    ~= n_secs ...
            | length(mm)   ~= n_secs | length(ss)    ~= n_secs),
        help to_day
        error('All input vectors except year_base must have same length');
    end
    
    year_base = year_base(:);
    n_yb = length(year_base);
    if (n_yb ~= 1 & n_yb ~= n_secs)
        help to_day
        error('year_base must be scalar, or have same number of elements as other args')
    end
    
    dd = (to_sec([year month day hh mm ss]) -  ...
        to_sec([year_base ones(n_yb,2) zeros(n_yb,3)])) / 86400;
    
end
end
function s = to_signed(u)
  
  %%% was in read_bb.m
  
s = u;
ineg = u > 32767;
s(ineg) = s(ineg) - 65536;
ibad = s == -32768;
s(ibad) = NaN;

end

