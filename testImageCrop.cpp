#include "image_decoder.h"
#include "commons.h"
#include <iostream>

using namespace std;

int main()
{
    vector<cv::Mat> matTemplates = getTemplates();
    cv::Mat src = cv::imread("output/cell_0_2.png", cv::IMREAD_UNCHANGED);

    // cv::cvtColor(src, src, cv::COLOR_BGR2GRAY);

    cv::imwrite("output_test_src.png", src);

    int classCount = 1;

    for (cv::Mat &tem : matTemplates)
    {
        cv::Mat toCompare;
        cv::resize(tem, toCompare, cv::Size(src.cols, src.rows), cv::INTER_LINEAR);
        // cv::cvtColor(toCompare, toCompare, cv::COLOR_BGR2GRAY);
        // cv::imwrite("output_test_tmp.png", toCompare);

        cv::Mat result;
        // cv::matchTemplate(src, toCompare, result, cv::TM_CCORR_NORMED);

        // Get maximum probability
        // double minLoc, maxLoc, minVal, maxVal;

        // cv::minMaxLoc(result, &minVal, &maxVal);

        cv::Scalar ssim = cv::PSNR(src, toCompare);

        // double similarity = cv::matchShapes(src, toCompare, cv::CONTOURS_MATCH_I1, 0);
        cout << "SSIM: " << ssim[0] << " " << classCount << endl;
        classCount++;
    }
}