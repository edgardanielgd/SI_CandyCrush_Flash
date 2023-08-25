#include "image_decoder.h"
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

    int category_index = 0;
    for (cv::Mat &tem : templates)
    {
        cv::Mat res;
        cv::matchTemplate(
            img, tem, res, cv::TM_CCOEFF_NORMED);
        cv::threshold(res, res, CLASSIFCATION_THRESHOLD, 1.0, cv::THRESH_BINARY);

        // Set places where the template was found to 1 with the given category index
        for (int i = 0; i < res.rows; i++)
        {
            for (int j = 0; j < res.cols; j++)
            {
                if (res.at<float>(i, j) == 1.0)
                {
                    result.at<int>(i, j) = category_index;
                }
            }
        }

        category_index++;
    }

    return result;
}

cv::Mat generatePositionMatrix(cv::Mat pixelsMat, int rows, int cols)
{
    cv::Mat result(rows, cols, CV_32FC1);

    int row_ratio = pixelsMat.rows / rows;
    int col_ratio = pixelsMat.cols / cols;

    for (int i = 0; i < pixelsMat.rows; i++)
    {
        for (int j = 0; j < pixelsMat.cols; j++)
        {
            int row_index = i / row_ratio;
            int col_index = j / col_ratio;

            // TODO: Save a count of each category falling in this cell
            // then set its value as the category that has the highest count
        }
    }

    return result;
}