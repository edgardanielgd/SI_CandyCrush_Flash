#ifndef AGENT_H
#define AGENT_H

#include "agent.h"
#include "commons.h"
#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"

class Agent
{
public:
    Agent() {}

    ~Agent() {}

    struct Option
    {
        int r, l, t, b, utility;
    };

    struct Movement
    {
        int x, y, direction, utility;
        Option option;
    };

    int evaluate(cv::Mat perception, int *counts, int oi, int oj, int i, int j);

    Movement f(cv::Mat perception);

    Movement f2(cv::Mat perception);
};

#endif