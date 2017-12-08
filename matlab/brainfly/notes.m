load('freqVariables.mat');
X
fs=250

freqband = {{8 12} {18 22}}
% freqbands2 = [ 7.5 17.5; 12.5 22.5]
% freqband = [6 8 28 30]
% freqbands2 = [7 ; 29]

fIdx=[];
if ( ~isempty(freqband) && ~isempty(fs) )
    if( true) fprintf('5) Select frequencies\n');end;
    freqbands=freqband
    if ( iscell(freqband) ) % specified as a set of pass-bands, convert to matrix version
        freqbands=zeros(2,numel(freqband))
        for bi=1:numel(freqband);
            if(numel(freqband{bi})==2)     freqbands(:,bi)=opts.freqband{bi};
            elseif(numel(freqband{bi})==3) freqbands(:,bi)=opts.freqband{bi}([1 3]);
            else                           freqbands(:,bi)=[mean(opts.freqband{bi}([1 2])) mean(opts.freqband([3 4]))];
            end
        end
    else % standardize to band start,end
        if(size(freqbands,1)==1)      freqbands=freqbands'; end;
        if(size(freqbands,1)==3)      freqbands=freqbands([1 3],:);
        elseif(size(freqbands,1)==4)  freqbands=[mean(freqbands([1 2],:),1); mean(freqbands([3 4],:),1)];
        end
    end
    
    
    disp("frequency bands:")
    freqbands
    fIdx
    
    % convert from freq-band spec in hz to weighting over frequency bins
    fIdx=zeros(size(X,2),size(freqbands,2));
    for bi=1:size(freqbands,2);
        bi
        %     [ans,lb]=min(abs(freqs-max(freqs(1),  freqbands(1,bi)))); % lower frequency bin
        %     [ans,ub]=min(abs(freqs-min(freqs(end),freqbands(2,bi)))); % upper frequency bin
        %     fIdx(lb:ub,bi)=true;
    end
    % apply the weighting over frequency bins to get the filtered signal
    %   fIdx=any(fIdx,2); % merge the different band-specs
    %   X=X(:,fIdx,:); % sub-set to the interesting frequency range
    %   freqs=freqs(fIdx) % update labelling info
end;

% if ( opts.timefeat )
%   if( opts.verb>0) fprintf('5.4) Time feature');end;
%   X=cat(2,Xt,X);
%   freqs=[0 freqs];
% end

  [[7 8 12 13], [17 18 22 23]]
  freqbands = [ 7.5 17.5; 12.5 22.5]
freqs = 8    12    16    20    24


[6 8 28 30];
freqs =  8    12    16    20    24    28
     
     

[7 8 22 23]
freqs 8  12    16    20    24

Change freqs to freqs = [7.5 12.5 17.5 22.5], remove middle interval?


- Changed ersp viewer to our frequencies?

-Freqband used in spatial filtering (246)



Error in train_ersp_clsfr (line 292)
else                                freqbands(:,bi)=[mean(opts.freqband{bi}([1 2])) mean(opts.freqband([3 4]))];
else                                freqbands(:,bi)=[mean(opts.freqband{bi}([1 2])) mean(opts.freqband{bi}([3 4]))];

