function [best_model] = train_binary_model(training_set, labels)
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
    %    
    % Output arguments:
    %   - best_model    The model that performed best in cross-validation.
    MODELS{1} = @fitcdiscr;
    MODELS{2} = @QDA_wrapper;
    MODELS{3} = @SVM_wrapper;
    
    if size(training_set, 1) ~= size(labels, 1)
        error('Training set and labels have different lengths.');
    end
    
    % test_indices will contain in which run an element is in test fold.
    K = length(MODELS);
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
    
    trained_models = cell(K);
    model_scores = nan(K);
    for m = 1:K
        % Training data
        train_folds = training_set(test_indices ~= m, :);
        train_labels = labels(test_indices ~= m);
        
        % Test data
        test_fold = training_set(test_indices == m, :);
        test_labels = labels(test_indices == m);
        
        % Train
        trained_models{m} = MODELS{m}(train_folds, train_labels);
        
        % Validation score.
        [pred, ~] = predict(trained_models{m}, test_fold);
        accuracy = 100*sum(pred == test_labels)./length(test_labels);
        
        fprintf('Model %s obtained a test accuracy of: %f.\n', class(trained_models{m}), accuracy);
        model_scores(m) = accuracy;
    end
    
    % Return the most accurate model.
    [~, best_index] = max(model_scores);
    best_model = trained_models{best_index};
end

function [QDA_model] = QDA_wrapper(training_set, labels)
    QDA_model = fitcdiscr(training_set, labels, 'DiscrimType', 'quadratic');
end

function [SVM_model] = SVM_wrapper(training_set, labels)
    SVM_model = fitcsvm(training_set, labels, 'KernelFunction', 'rbf');
end

