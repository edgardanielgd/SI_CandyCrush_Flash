#include "image_decoder.h"
#include "commons.h"
#include <iostream>

using namespace std;

int main()
{
    vector<cv::Mat> matTemplates = getTemplates();
    cv::Mat src = cv::imread("output/cell_7_6.png", cv::IMREAD_UNCHANGED);

    int classCount = 1;

    for (cv::Mat &tem : matTemplates)
    {
        cv::Mat toCompare;
        cv::resize(tem, toCompare, cv::Size(src.cols, src.rows), cv::INTER_LINEAR);

        // cout << "Source: " << src.rows << " " << src.cols << endl;
        // cout << "ToCompare: " << toCompare.rows << " " << toCompare.cols << endl;

        cv::Scalar ssim = cv::PSNR(src, toCompare);

        cout << "SSIM: " << ssim[0] << " " << classCount << endl;
        // cv::matchTemplate(
        //     src, tem, res, cv::TM_CCOEFF_NORMED);

        // cv::threshold(res, res, 0.0, 1, cv::THRESH_BINARY);

        // cv::imwrite("output/res_" + to_string(classCount) + ".png", res);

        classCount++;
    }
}