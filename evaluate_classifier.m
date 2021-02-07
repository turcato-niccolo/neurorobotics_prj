function [accuracy, class_accuracy] = evaluate_classifier(true_labels, predicted_labels, classes)
% [accuracy, class_accuracy] = evaluate_classifier(true_labels, predicted_labels, classes)
% 
% This function evaluates the performances of the classifier both total an
% per class
%
% Input arguments:
%   - true_labels           expected classification labels
%   - predicted_labels      predicted classification labels
%   - classes               class labels
%
% Output arguments:
%   - accuracy      	fraction of the samples correctly classified
%   - class_accuracy    fraction of the samples of class_i correctly classified

accuracy = 100*sum(true_labels == predicted_labels) / length(true_labels);
class_accuracy = nan(size(classes));

for k = 1:length(classes)
    class_code = classes(k);
    data_partition = (true_labels==class_code);
    class_accuracy(k) = 100*sum(predicted_labels(data_partition) == class_code) / sum(data_partition);
end

