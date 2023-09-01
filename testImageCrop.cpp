#include "image_decoder.h"
#include "commons.h"
#include <iostream>
#include <windows.h>

using namespace std;

int main()
{
    vector<cv::Mat> matTemplates = getTemplates();
    cv::Mat src = cv::imread("output/cell_6_5.png", cv::IMREAD_UNCHANGED);

    // cv::cvtColor(src, src, cv::COLOR_RGBA2GRAY);

    cv::imwrite("output_test_src.png", src);

    int classCount = 1;

    for (cv::Mat &tem : matTemplates)
    {
        cv::Mat toCompare;
        cv::resize(tem, toCompare, cv::Size(src.cols, src.rows), cv::INTER_LINEAR);
        // cv::cvtColor(toCompare, toCompare, cv::COLOR_RGBA2GRAY);
        // cv::imwrite("output_test_tmp.png", toCompare);

        cv::Mat result;
        cv::matchTemplate(src, toCompare, result, cv::TM_CCOEFF_NORMED);

        // Get maximum probability
        double minLoc, maxLoc, minVal, maxVal;

        // cv::minMaxLoc(result, &minVal, &maxVal);

        auto vals = cv::sum(result);
        maxVal = vals[0] + vals[1] + vals[2] + vals[3];

        // double similarity = cv::matchShapes(src, toCompare, cv::CONTOURS_MATCH_I1, 0);
        cout << "SSIM: " << maxVal << " " << classCount << endl;
        classCount++;
    }

    // cv::Mat src = cv::imread("output/original.png", cv::IMREAD_UNCHANGED);

    // printf("pre-ola\n");
    // cv::Rect area = cv::Rect(
    //     MATRIX_OFFSET_X, MATRIX_OFFSET_Y,
    //     src.cols - MATRIX_OFFSET_X - MATRIX_MARGIN_RIGHT,
    //     src.rows - MATRIX_OFFSET_Y - MATRIX_MARGIN_BOTTOM);

    // printf("ola\n");
    // cv::Mat cropped = src(area);

    // cv::imwrite("output/cropped.png", cropped);

    // for (int i = 0; i < 9; i++)
    // {
    //     for (int j = 0; j < 9; j++)
    //     {
    //         cv::Rect cellArea = cv::Rect(
    //             j * CELL_SIZE_X,
    //             i * CELL_SIZE_Y,
    //             min(CELL_SIZE_X, cropped.cols - j * CELL_SIZE_X),
    //             min(CELL_SIZE_Y, cropped.rows - i * CELL_SIZE_Y));

    //         cv::Mat cell = cropped(cellArea);

    //         cv::imwrite("output/cell_" + to_string(i) + "_" + to_string(j) + ".png", cell);
    //     }
    // }
}