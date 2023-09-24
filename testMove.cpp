#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"

#include <iostream>
#include "agent.h"

using namespace std;

int main()
{
    int array[9][9] = {
        {0, 1, 4, 3, 5, 4, 0, 2, 4},   // 0
        {4, 2, 2, 4, 0, 4, 1, 0, 5},   // 1
        {3, 3, 4, 0, 0, 20, 1, 2, 4},  // 2
        {3, 1, 0, 2, 2, 4, 0, 5, 2},   // 3
        {1, 4, 2, 4, 5, 1, 20, 4, 0},  // 4
        {4, 3, 0, 5, 2, 3, 0, 5, 1},   // 5
        {2, 1, 20, 24, 1, 3, 2, 1, 1}, // 6
        {3, 1, 4, 5, 2, 5, 1, 4, 0},   // 7
        {4, 3, 4, 3, 1, 0, 1, 5, 5}    // 8
    };

    cv::Mat mat(9, 9, CV_32FC1);
    for (int i = 0; i < 9; i++)
    {
        for (int j = 0; j < 9; ++j)
        {
            mat.at<float>(i, j) = array[i][j];
        }
    }

    Agent agent;

    Agent::Movement movement = agent.f2(mat);

    std::cout << movement.direction << endl;
    std::cout << movement.x << endl;
    std::cout << movement.y << endl;
}
