#ifndef IMAGE_DECODER_H
#define IMAGE_DECODER_H

#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
#include <vector>

using namespace std;

const string TEMPLATES_PATH = "templates\\";
const string templates[] = {
    "PurpleCandy.png", "RedCandy.png", "BlueCandy.png", "YellowCandy.png", "GreenCandy.png", "OrangeCandy.png",
    "PurpleVertCandy.png", "RedVertCandy.png", "BlueVertCandy.png", "YellowVertCandy.png", "GreenVertCandy.png", "OrangeVertCandy.png",
    "PurpleHorizCandy.png", "RedHorizCandy.png", "BlueHorizCandy.png", "YellowHorizCandy.png", "GreenHorizCandy.png", "OrangeHorizCandy.png",
    "PackedPurpleCandy.png", "PackedRedCandy.png", "PackedBlueCandy.png", "PackedYellowCandy.png", "PackedGreenCandy.png", "PackedOrangeCandy.png",
    "ColorfulCandy.png"};

// Array of templates to search
vector<cv::Mat> getTemplates();

// After applying a template, each pixel will have a chance
// to be classified as a candy or not. we should set a threshold
const double CLASSIFCATION_THRESHOLD = 0.6;

// Classify pixels in a given image, template by template
cv::Mat classifyPixels(cv::Mat &img, vector<cv::Mat> &templates);

// Generate a matrix from pixels classification (normalize to a given small matrix)
cv::Mat generatePositionMatrix(cv::Mat pixelsMat);

// Generate a matrix from pixels classification (normalize to a given small matrix)
cv::Mat generatePositionMatrix2(cv::Mat &img, vector<cv::Mat> &templates);

#endif