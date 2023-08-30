#include "image_decoder.h"
#include "commons.h"
#include <iostream>

using namespace std;

vector<cv::Mat> getTemplates()
{
    vector<cv::Mat> matTemplates;
    for (const string &tem : templates)
    {
        cv::Mat img = cv::imread(TEMPLATES_PATH + tem, cv::IMREAD_UNCHANGED);
        if (img.empty())
        {
            cout << "Could not read the image: " << tem << endl;
            exit(1);
        }
        matTemplates.push_back(img);
    }

    return matTemplates;
}

cv::Mat classifyPixels(cv::Mat &img, vector<cv::Mat> &templates)
{
    cv::Mat result(img.rows, img.cols, CV_32FC1);

    int category_index = 1;
    for (cv::Mat &tem : templates)
    {
        cv::Mat res;
        cv::matchTemplate(
            img, tem, res, cv::TM_CCOEFF_NORMED);

        cv::threshold(res, res, CLASSIFCATION_THRESHOLD, category_index, cv::THRESH_BINARY);

        // Replace non-zero values in main result matrix with the category index
        for (int i = 0; i < res.rows; i++)
        {
            for (int j = 0; j < res.cols; j++)
            {
                if (res.at<float>(i, j) != 0)
                {
                    result.at<float>(i, j) = category_index;
                }
            }
        }

        category_index++;
    }

    return result;
}

cv::Mat generatePositionMatrix(cv::Mat pixelsMat)
{
    cv::Mat result(MATRIX_ROWS, MATRIX_COLS, CV_32FC1);

    int class_counts[MATRIX_ROWS][MATRIX_COLS][26] = {0}; // [row][col][class]

    for (int i = 0; i < pixelsMat.rows; i++)
    {
        for (int j = 0; j < pixelsMat.cols; j++)
        {
            int row = i / CELL_SIZE_Y;
            int col = j / CELL_SIZE_X;

            if (row >= MATRIX_ROWS || col >= MATRIX_COLS)
            {
                continue;
            }

            int class_index = pixelsMat.at<float>(i, j);

            if (class_index == 0)
            {
                continue;
            }

            class_counts[row][col][class_index]++;
        }
    }

    cout << "Ends generatePositionMatrix...\n"
         << endl;

    // Find the most frequent class in each cell
    for (int i = 0; i < MATRIX_ROWS; i++)
    {
        for (int j = 0; j < MATRIX_COLS; j++)
        {
            int max_class_index = 0;
            int max_class_count = 0;
            for (int k = 0; k < 26; k++)
            {
                if (class_counts[i][j][k] > max_class_count)
                {
                    max_class_count = class_counts[i][j][k];
                    max_class_index = k;
                }
            }

            result.at<float>(i, j) = max_class_index;
        }
    }

    cout << "Ends checking higher classes...\n"
         << endl;

    return result;
}