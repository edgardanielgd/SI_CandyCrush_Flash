#include "agent.h"
#include "commons.h"
#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"
#include <iostream>

using namespace std;

// Lets get simple three neighbors completion
Agent::Option Agent::evaluate(cv::Mat perception, int oi, int oj, int i, int j)
{

    struct Option option;
    option.r = 0;
    option.l = 0;
    option.t = 0;
    option.b = 0;
    option.utility = 0;

    int color = perception.at<float>(oi, oj);
    int colorSide = perception.at<float>(i, j);

    if (color == 24 && colorSide == 24)
    {
        option.utility = 100;
        return option;
    }

    if (color == 24 && colorSide >= 18 && colorSide <= 23)
    {
        option.utility = 99;
        return option;
    }

    if (color == 24 && colorSide >= 6 && colorSide <= 17)
    {
        option.utility = 98;
        return option;
    }

    if (color >= 18 && color <= 23 && colorSide >= 18 && colorSide <= 23)
    {
        option.utility = 97;
        return option;
    }

    if (color >= 18 && color <= 23 && colorSide >= 6 && colorSide <= 17)
    {
        option.utility = 96;
        return option;
    }

    if (color >= 6 && color <= 17 && colorSide >= 6 && colorSide <= 17)
    {
        option.utility = 95;
        return option;
    }

    if (color == 24)
    {
        option.utility = 94;
        return option;
    } // Empty

    cv::Mat aux = perception.clone();
    aux.at<float>(oi, oj) = colorSide;
    aux.at<float>(i, j) = color;

    for (int z = 0; z < aux.rows; z++)
    {
        for (int w = 0; w < aux.cols; w++)
        {
            int a = aux.at<float>(z, w);

            // TO OPTIMIZE
            aux.at<float>(z, w) = a % 6;
        }
    }

    int candies_at_left = 0;
    int candies_at_right = 0;
    int candies_at_top = 0;
    int candies_at_bottom = 0;

    // Left check
    int x = oj - 1;
    while (x > 0 && aux.at<float>(oi, x) == aux.at<float>(oi, oj))
    {
        candies_at_left++;
        x--;
    }

    // Right check
    x = oj + 1;
    while (x < aux.cols && aux.at<float>(oi, x) == aux.at<float>(oi, oj))
    {
        candies_at_right++;
        x++;
    }

    // Top check
    x = oi - 1;
    while (x > 0 && aux.at<float>(x, oj) == aux.at<float>(oi, oj))
    {
        candies_at_top++;
        x--;
    }

    // Bottom check
    x = oi + 1;
    while (x < aux.rows && aux.at<float>(x, oj) == aux.at<float>(oi, oj))
    {
        candies_at_bottom++;
        x++;
    }

    // remove useless moves
    const int horizontal_row = candies_at_left + candies_at_right;
    const int vertical_row = candies_at_top + candies_at_bottom;

    int move;

    if (horizontal_row >= 2)
    {
        if (vertical_row >= 2)
        {
            move = horizontal_row + vertical_row + 1;
        }
        else
        {
            move = horizontal_row + 1;
        }
    }
    else if (vertical_row >= 2)
    {
        if (horizontal_row >= 2)
        {
            move = vertical_row + horizontal_row + 1;
        }
        else
        {
            move = vertical_row + 1;
        }
    }
    else
    {
        option.utility = -1;
        option.r = candies_at_right;
        option.l = candies_at_left;
        option.t = candies_at_top;
        option.b = candies_at_bottom;
        return option;
    }

    option.r = candies_at_right;
    option.l = candies_at_left;
    option.t = candies_at_top;
    option.b = candies_at_bottom;
    option.utility = move;

    return option;
}

Agent::Movement Agent::f(cv::Mat perception)
{
    struct Movement move;
    move.x = -1;
    move.y = -1;
    move.direction = -1;
    move.utility = -1;

    int utility = 0;
    Option option, optionFinal;

    for (int i = 0; i < MATRIX_ROWS; i++)
    {
        for (int j = 0; j < MATRIX_COLS; j++)
        {
            if (j <= 7)
            {
                option = evaluate(perception, i, j, i, j + 1);
                if (move.utility <= option.utility)
                {
                    optionFinal = option;
                    move.x = i;
                    move.y = j;
                    move.direction = RIGHT;
                    move.utility = option.utility;
                }
            }

            if (j >= 1)
            {
                option = evaluate(perception, i, j, i, j - 1);
                if (move.utility <= option.utility)
                {
                    optionFinal = option;
                    move.x = i;
                    move.y = j;
                    move.direction = LEFT;
                    move.utility = option.utility;
                }
            }

            if (i >= 1)
            {
                option = evaluate(perception, i, j, i - 1, j);
                if (move.utility <= option.utility)
                {
                    optionFinal = option;
                    move.x = i;
                    move.y = j;
                    move.direction = UP;
                    move.utility = option.utility;
                }
            }

            if (i <= 7)
            {
                option = evaluate(perception, i, j, i + 1, j);
                if (move.utility <= option.utility)
                {
                    optionFinal = option;
                    move.x = i;
                    move.y = j;
                    move.direction = DOWN;
                    move.utility = option.utility;
                }
            }

            if (move.utility == 94)
                return move;
        }
    }

    cout << "Option " << endl;
    cout << "r: " << optionFinal.r << endl;
    cout << "l: " << optionFinal.l << endl;
    cout << "t: " << optionFinal.t << endl;
    cout << "b: " << optionFinal.b << endl;
    cout << "utility: " << optionFinal.utility << endl;

    return move;
}
