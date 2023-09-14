#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"

#include <iostream>
#include "agent.h"

using namespace std;

int main()
{
    int array[9][9] = {
        {4, 4, 1, 2, 3, 4, 3, 1, 1},   // 0
        {0, 0, 3, 4, 3, 3, 4, 1, 2},   // 1
        {3, 1, 5, 2, 5, 1, 3, 21, 3},  // 2
        {5, 5, 2, 2, 5, 4, 4, 0, 2},   // 3
        {0, 2, 2, 3, 4, 1, 5, 4, 2},   // 4
        {3, 3, 18, 5, 5, 2, 1, 3, 10}, // 5
        {4, 1, 5, 4, 2, 2, 3, 4, 5},   // 6
        {1, 5, 4, 3, 1, 10, 1, 1, 0},  // 7
        {3, 0, 4, 2, 0, 4, 5, 4, 2}    // 8
    };

    std::cout << array << endl;

    cv::Mat mat(9, 9, CV_32FC1);
    for (int i = 0; i < 9; i++)
    {
        for (int j = 0; j < 9; ++j)
        {
            mat.at<float>(i, j) = array[i][j];
        }
    }

    Agent agent;

    Agent::Movement movement = agent.f(mat);

    std::cout << movement.direction << endl;
    std::cout << movement.x << endl;
    std::cout << movement.y << endl;
}
