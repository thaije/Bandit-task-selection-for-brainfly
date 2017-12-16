

X = load("X.mat");
X = X.X;
ch_names = load("ch_names.mat");
ch_names = ch_names.ch_names;

disp("Original dimensions X:")
size(X)
disp("Original channels:")
ch_names

%Channels to keep:"
% C3 Cz C4
targetCh = ["C3", "Cz", "C4"];

% Traverse the list backwards (to avoid troubles when we delete non-target
% channels), and remove non-target channels.
for m = numel(ch_names):-1:1
    if ~any(strcmp(targetCh, ch_names(m)))
        % remove the channel from X and the ch_names
        ch_names(m) = [];
        X(m,:,:) = [];
    end
end

disp("Target channels found:")
ch_names

disp("Resulting X:")
X