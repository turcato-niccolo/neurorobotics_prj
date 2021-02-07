function [accuracy,class_accuracy] = evaluateClassifier(true_labels, predicted_labels, classes)
%EVALUATECLASSIFIER Summary of this function goes here
%   Detailed explanation goes here
class_accuracy = nan(size(classes));
accuracy = 100*sum(true_labels == predicted_labels) / length(true_labels);

for k = 1:length(classes)
    class_code = classes(k);
    data_partition = (true_labels==class_code);
    class_accuracy(k) = 100*sum(predicted_labels(data_partition) == class_code) / sum(data_partition);
end

