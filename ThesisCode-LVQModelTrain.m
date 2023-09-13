clc;
clear;
clear all;
close all;


% Egitim ve test icin gerekli olan girdi ve hedef veri setlerinin okunmasi
input=xlsread('train_24000x60');
target=xlsread('train_output_labels');
testInputs=xlsread('test_6000x60');
testTargets=xlsread('test_output_labels');


% Ilgili veri setlerinin aga girdisi yapilabilmesi icin gerceklestirilen transpoz islemi
input=input';
target=target';
testInputs=testInputs';
testTargets=testTargets';


% Ilgili girdi veri setlerinin -1 ve 1 araliginda normalize edilip olceklendirilmesi
input=normalize(input, 'range', [-1 1]);
testInputs=normalize(testInputs, 'range', [-1 1]);


trainInputs = input;
trainTargets = target;


net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 100/100;
net.divideParam.valRatio = 0/100;
net.divideParam.testRatio = 0/100;


for i=29:36
    
% Modelde bulunan Kohonen katmanindaki noron sayisinin ve ilgili ag parametrelerinin belirlenmesi
kohonenLayerSize = i; 
net = lvqnet(kohonenLayerSize,0.01); %0.01 learning rate - ogrenme orani
net.trainParam.epochs = 100;
net.performFcn = 'mse'; %performance function - performans fonksiyonu


% Agin egitimi
net = train(net,trainInputs,trainTargets);


% Elde edilen ciktilar ile ilgili metriklerin test veri seti ile elde 
% edilmesi
testPredictedTargets = net(testInputs);
trainPredictedTargets = net(trainInputs);


% Agin mimarisinin goruntulenmesi
view(net)


% Modelin egitim suresi uzun surebildigi icin kayit islemini gerceklestiriyorum. Boylelikle egitilen modeller sonradan kullanilabilir.
fname = sprintf("lvq_model_%d_noron_100", i);
save(string(fname), 'net')


% Test ve egitim veriseti icin ilgili hata matrislerinin olusturulmasi ve kayit edilmesi
plotconfusion(testPredictedTargets, testTargets)
saveas(gcf,"lvq_model_"+i+"_noron_test_confusion_matrix_100")

plotconfusion(trainPredictedTargets, trainTargets)
saveas(gcf,"lvq_model_"+i+"_noron_train_confusion_matrix_100")


% Test veri seti icin performans metriklerinin hesaplanmasi
[~, testPredictedLabels] = max(testPredictedTargets);
[~, testTrueLabels] = max(testTargets);
testNumCorrect = sum(testPredictedLabels == testTrueLabels);
testNumTotal = numel(testTrueLabels);


% Test veri setine gore oruntu tanima orani
testAccuracy = testNumCorrect / testNumTotal;


% Test veri setine gore kesinlik, duyarlilik ve f1 skoru degerlerinin hesaplanmasi:
testNumClasses = size(testTargets, 1);
testPrecision = zeros(testNumClasses, 1);
testRecall = zeros(testNumClasses, 1);
testF1Score = zeros(testNumClasses, 1);


for a = 1:testNumClasses
    testTruePositive = sum(testPredictedLabels == a & testTrueLabels == a);
    testFalsePositive = sum(testPredictedLabels == a & testTrueLabels ~= a);
    testFalseNegative = sum(testPredictedLabels ~= a & testTrueLabels == a);
    
    testPrecision(a) = testTruePositive / (testTruePositive + testFalsePositive);
    testRecall(a) = testTruePositive / (testTruePositive + testFalseNegative);
    testF1Score(a) = 2 * testPrecision(a) * testRecall(a) / (testPrecision(a) + testRecall(a));
end


% Test veri setine gore genel performans metriklerinin hesaplanmasi
testMacroPrecision = mean(testPrecision, "omitnan");
testMacroRecall = mean(testRecall, "omitnan");
testMacroF1Score = mean(testF1Score, "omitnan");


%##################################################################


% Egitim veri seti icin performans metriklerinin hesaplanmasi
[~, trainPredictedLabels] = max(trainPredictedTargets);
[~, trainTrueLabels] = max(trainTargets);
trainNumCorrect = sum(trainPredictedLabels == trainTrueLabels);
trainNumTotal = numel(trainTrueLabels);


% Egitim veri setine gore oruntu tanima orani
trainAccuracy = trainNumCorrect / trainNumTotal;


% Egitim veri setine gore kesinlik, duyarlilik ve f1 skoru degerlerinin hesaplanmasi:
trainNumClasses = size(trainTargets, 1);
trainPrecision = zeros(trainNumClasses, 1);
trainRecall = zeros(trainNumClasses, 1);
trainF1Score = zeros(trainNumClasses, 1);

for b = 1:testNumClasses
    trainTruePositive = sum(trainPredictedLabels == b & trainTrueLabels == b);
    trainFalsePositive = sum(trainPredictedLabels == b & trainTrueLabels ~= b);
    trainFalseNegative = sum(trainPredictedLabels ~= b & trainTrueLabels == b);
    
    trainPrecision(b) = trainTruePositive / (trainTruePositive + trainFalsePositive);
    trainRecall(b) = trainTruePositive / (trainTruePositive + trainFalseNegative);
    trainF1Score(b) = 2 * trainPrecision(b) * trainRecall(b) / (trainPrecision(b) + trainRecall(b));
end


% Egitim veri setine gore genel performans metriklerinin hesaplanmasi
trainMacroPrecision = mean(trainPrecision, "omitnan");
trainMacroRecall = mean(trainRecall, "omitnan");
trainMacroF1Score = mean(trainF1Score, "omitnan");


% Elde edilen sonuclarin sonradan incelenebilmesi icin noron sayisi ve egitim fonksiyonunun ismine gore olusturulan bir .txt dosyasina yazdirilmasi
fname = sprintf("LVQTrainAndTestMetrics%dNeuron100.txt", i);
fid = fopen(fname,'wt');

fprintf(fid,'Test veri seti icin:');
fprintf(fid,'Model Adi: lvq_model_%.2f%%\n_noron', i);
fprintf(fid,'Accuracy: %.2f%%\n', testAccuracy * 100);
fprintf(fid,'Precision: %.2f%%\n', testMacroPrecision * 100);
fprintf(fid,'Recall: %.2f%%\n', testMacroRecall * 100);
fprintf(fid,'F1 Score: %.2f%%\n', testMacroF1Score * 100);
fprintf(fid,'--------------------------------------');
fprintf(fid,'Egitim veri seti icin:');
fprintf(fid,'Model Adi: lvq_model_%.2f%%\n_noron', i);
fprintf(fid,'Accuracy: %.2f%%\n', trainAccuracy * 100);
fprintf(fid,'Precision: %.2f%%\n', trainMacroPrecision * 100);
fprintf(fid,'Recall: %.2f%%\n', trainMacroRecall * 100);
fprintf(fid,'F1 Score: %.2f%%\n', trainMacroF1Score * 100);
fprintf(fid,'======================================');

fclose(fid);

end
