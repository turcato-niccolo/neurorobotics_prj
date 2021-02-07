function [patients] = find_patients(root)
    % FIND_PATIENTS  Explore directory for patient data.
    %
    % Looks into 'root' directory assumed to contain one subdirectory for
    % patient. Each subdirectory should contain the online and offline
    % data.
    %
    % Input arguments:
    %   - root      The directory from which to begin searching.
    %
    % Output arguments:
    %   - patients  Cell array of patients, each patient is a structure
    %               with fields: 'name' (string), 'offline_files' (cell
    %               array) and 'online_files' (cell array). Paths to files
    %               are relative including 'root'.
    
    validsubdir = @(x) ~strcmp(x.name, '.') && ~strcmp(x.name, '..');

    subdirs = dir(root);
    % Remove 'root' itself and parent dir ('.' and '..').
    subdirs = subdirs(arrayfun(validsubdir, subdirs));

    patients = cell(length(subdirs), 1);
    for i = 1:length(subdirs)
        
        % Relative name of subdirectory.
        directory = subdirs(i).name;
        % Assume patient name/code is before first underscore.
        name = split(directory, '_');
        name = name{1};
        % Files in subdirectory.
        files = dir(fullfile(root, directory));
        filenames = cell(length(files), 1);
        for j = 1:length(files)
            filenames{j} = files(j).name;
        end
    
        patients{i}.name = name;
        patients{i}.offline_files = {};
        patients{i}.online_files = {};
        
        % Divide offline and online .gdf files.
        for j = 1:length(filenames)
            if endsWith(filenames{j}, '.gdf')
                % Full file name including root.
                full = fullfile(root, directory, filenames{j});
                if contains(filenames{j}, 'offline')
                    patients{i}.offline_files{end+1} = full;
                else
                    patients{i}.online_files{end+1} = full;
                end
            end
        end
    end
end
