#ifndef IMAGE_DECODER_H
#define IMAGE_DECODER_H

#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
#include <vector>

using namespace std;

const string TEMPLATES_PATH = "templates\\";
const string templates[] = {
    "BlueCandy.png", "BlueHorizCandy.png", "BlueVertCandy.png", "PackedBlueCandy.png",
    "GreenCandy.png", "GreenHorizCandy.png", "GreenVertCandy.png", "PackedGreenCandy.png",
    "OrangeCandy.png", "OrangeHorizCandy.png", "OrangeVertCandy.png", "PackedOrangeCandy.png",
    "PurpleCandy.png", "PurpleHorizCandy.png", "PurpleVertCandy.png", "PackedPurpleCandy.png",
    "RedCandy.png", "RedHorizCandy.png", "RedVertCandy.png", "PackedRedCandy.png",
    "YellowCandy.png", "YellowHorizCandy.png", "YellowVertCandy.png", "PackedYellowCandy.png",
    "ColorfulCandy.png"};

// Array of templates to search
vector<cv::Mat> getTemplates();

// After applying a template, each pixel will have a chance
// to be classified as a candy or not. we should set a threshold
const float CLASSIFCATION_THRESHOLD = 0.8;

// Classify pixels in a given image, template by template
cv::Mat classifyPixels(cv::Mat &img, vector<cv::Mat> &templates);

// Generate a matrix from pixels classification (normalize to a given small matrix)
cv::Mat generatePositionMatrix(cv::Mat pixelsMat, int rows, int cols);

#endif