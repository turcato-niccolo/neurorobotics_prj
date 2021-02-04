function [best_model] = train_binary_model(training_set, labels, varargin)
    % TRAIN_MODEL Train a model for binary classification.
    %   
    % Trains a model for binary classification, cross-validating between:
    % - Linear Discriminant Analysis
    % - Quadratic Discriminant Analysis
    % - SVM with rbf kernel.
    % 
    % Input arguments:
    %   - training_set  The training data, in a matrix sample by features.
    %   - labels        The labels of the data.
    %   - K (optional)  Number of folds for cross validation. Default 5.
    %    
    % Output arguments:
    %   - best_model    The model that performed best in cross-validation.
    MODELS{1} = @fitcdiscr;
    MODELS{2} = @QDA_wrapper;
    MODELS{3} = @SVM_wrapper;
    
    % Get optional K parameter.
    parser = inputParser;
    isinteger = @(x) isnumeric(x) && (floor(x) == x);
    addOptional(parser, 'K', 5, isinteger);
    parse(parser, varargin{:});
    K = parser.Results.K;
    
    if size(training_set, 1) ~= size(labels, 1)
        error('Training set and labels have different lengths.');
    end
    
    % test_indices(i): which run element i will be in test fold.
    test_size = floor(length(labels) / K);
    % First K-1 folds
    test_indices = ones(length(labels));
    for i = 2:K-1
        first = test_size*(i-1) + 1;
        last = test_size*i;
        test_indices(first:last) = i;
    end
    % Last fold.
    test_indices((K-1)*test_size + 1:end) = K;
    % Random permutation.
    test_indices = test_indices(randperm(length(test_indices)));
    
    average_scores = nan(length(MODELS), 1);
    for m = 1:length(MODELS)
        partial_scores = nan(K, 1);
        for k = 1:K
            % Training data
            train_folds = training_set(test_indices ~= k, :);
            train_labels = labels(test_indices ~= k);
        
            % Test data
            test_fold = training_set(test_indices == k, :);
            test_labels = labels(test_indices == k);
        
            % Train
            model = MODELS{m}(train_folds, train_labels);
        
            % Validation score.
            [pred, ~] = predict(model, test_fold);
            accuracy = 100*sum(pred == test_labels)./length(test_labels);
            
            partial_scores(k) = accuracy;
        end
        average = mean(partial_scores);
        average_scores(m) = average;
        fprintf('Model %d obtained an average test accuracy of: %f.\n', m, average);
    end
    
    % Select the most accurate model.
    [~, best_index] = max(average_scores);
    
    % Train the model on all training data.
    best_model = MODELS{best_index}(training_set, labels);
end

function [QDA_model] = QDA_wrapper(training_set, labels)
    QDA_model = fitcdiscr(training_set, labels, 'DiscrimType', 'quadratic');
end

function [SVM_model] = SVM_wrapper(training_set, labels)
    SVM_model = fitcsvm(training_set, labels, 'KernelFunction', 'rbf');
    SVM_model = fitPosterior(SVM_model, training_set, labels);
end

