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

    struct Movement
    {
        int x, y, direction;
    };

    struct Option
    {
        Movement move;
        int utility;
    };

    // Lets get simple three neighbors completion
    int evaluate(cv::Mat perception, int oi, int oj, int i, int j, int color)
    {
        if (i < 0 || i >= MATRIX_ROWS)
            return -1;
        if (j < 0 || j >= MATRIX_COLS)
            return -1;

        int candiesCountY = 0;

        for (int z = 1; z < 3; z++)
        {
            int zx = i + z;
            int zy = i - z;

            // Ignore previous position
            if (zx == oi && zy == oj)
                continue;
        }

        int x = perception.at<float>(i, j);
        x %= 6;

        return candiesCountY;
    }

    Movement f(cv::Mat perception)
    {
        struct Movement move;
        move.x = 0;
        move.y = 0;
        move.direction = 1;

        // Lets get the best choice
        int optionUtility = -1;

        for (int i = MATRIX_ROWS - 1; i >= 0; i--)
        {
            for (int j = 0; j < MATRIX_COLS; j++)
            {
                // const int current = perception.at<float>(i, j);
                // optionUtility = evaluate(perception, i, j, i + 1, j, current);
                // optionUtility = evaluate(perception, i, j, i - 1, j, current);
                // optionUtility = evaluate(perception, i, j, i, j + 1, current);
                // optionUtility = evaluate(perception, i, j, i, j - 1, current);

                // evaluation = evaluate(perception, i, j, i, j + 2, i, j + 3);
                // if (evaluation)
                // {
                //     move.x = i;
                //     move.y = j;
                //     move.direction = 1;

                //     return move;
                // }

                // evaluation = evaluate(perception, i, j, i, j - 2, i, j - 3);
                // if (evaluation)
                // {
                //     move.x = i;
                //     move.y = j;
                //     move.direction = 2;

                //     return move;
                // }

                // evaluation = evaluate(perception, i, j, i + 2, j, i + 3, j);
                // if (evaluation)
                // {
                //     move.x = i;
                //     move.y = j;
                //     move.direction = 4;

                //     return move;
                // }

                // evaluation = evaluate(perception, i, j, i - 2, j, i - 3, j);
                // if (evaluation)
                // {
                //     move.x = i;
                //     move.y = j;
                //     move.direction = 3;

                //     return move;
                // }
            }
        }

        return move;
    }
};

#endif