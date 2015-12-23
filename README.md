Image Similarity Metric for Magnetic Resonance Imaging (MRI)

In many medical image processing applications, it is computationally admirable to assess an image in terms of its quality. 
This article deals with the problems concerning evaluating the quality of magnetic resonance images, resulting from various 
compressed sensing approaches. Since magnetic resonance imaging (MRI) inherently has a high acquisition time, there are 
numerous methods to speed it up by means of under sampling the acquired data especially by compressed sensing strategies. 
Although this may be true, it leads to image degradation in most methods. Hence, a model is required to assess the quality 
of MR reconstructed images as a feedback. The objective of this article is to create and simulate a statistical 
anthropomorphic model to appraise the performance of the reconstruction step and to estimate how much information has been 
lost. For this purpose, we present an image quality assessment framework based on machine learning in order to reduce the 
need of human observer and to omit the availability of a reference image. The proposed method applies several feature sets 
extracted from 2D slices which stem from texture statistics. They represent and characterize both local and global properties 
of each image. Then by means of mathematical and statistical models such as learned multi Support Vector Machine (SVM) 
classifier, a classification process is performed on the feature space to classify the images into five distinguishable 
groups. These groups are specified according to quality scale ranked by expert clinical radiologists and physicians who are 
well-familiar with magnetic resonance images. The scale is composed of five ranks so that the best quality image is clustered 
in the first class and the fifth class includes those with worst quality. Ultimately, some images will be used to test and 
evaluate the performance of the classification and interpret the error rates. Experimental results show that the proposed 
framework differentiates images with various qualities with the overall accuracy of 91.2%
