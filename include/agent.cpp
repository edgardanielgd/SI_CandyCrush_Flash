#include "agent.h"
#include "commons.h"
#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"
#include <vector>
#include <iostream>

using namespace std;

// FIRST APPROACH

// Lets get simple three neighbors completion
int Agent::evaluate(cv::Mat perception, int *counts, int oi, int oj, int i, int j)
{

    int color = perception.at<float>(oi, oj);
    int colorSide = perception.at<float>(i, j);

    if (color == 24 && colorSide == 24)
    {
        return 200;
    }

    if (color == 24 && colorSide >= 18 && colorSide <= 23)
    {
        return 180 + counts[colorSide % 6];
    }

    if (color == 24 && colorSide >= 6 && colorSide <= 17)
    {
        return 170 + counts[colorSide % 6];
    }

    if (color >= 18 && color <= 23 && colorSide >= 18 && colorSide <= 23)
    {
        return 97;
    }

    if (color >= 18 && color <= 23 && colorSide >= 6 && colorSide <= 17)
    {
        return 96;
    }

    if (color >= 6 && color <= 17 && colorSide >= 6 && colorSide <= 17)
    {
        return 95;
    }

    if (color == 24)
    {
        return 80 + counts[colorSide % 6];
    }

    cv::Mat aux = perception.clone();
    aux.at<float>(oi, oj) = colorSide;
    aux.at<float>(i, j) = color;
    cv::Mat aux2 = aux.clone();

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

    int specials_count = 0;

    if (colorSide >= 6)
    {
        specials_count += 3;
    }

    // Left check
    int x = oj - 1;
    while (x > 0 && aux.at<float>(oi, x) == aux.at<float>(oi, oj))
    {
        candies_at_left++;

        if (aux2.at<float>(oi, x) >= 6)
        {
            specials_count += 3;
        }

        x--;
    }

    // Right check
    x = oj + 1;
    while (x < aux.cols && aux.at<float>(oi, x) == aux.at<float>(oi, oj))
    {
        candies_at_right++;

        if (aux2.at<float>(oi, x) >= 6)
        {
            specials_count += 3;
        }

        x++;
    }

    // Top check
    x = oi - 1;
    while (x > 0 && aux.at<float>(x, oj) == aux.at<float>(oi, oj))
    {
        candies_at_top++;

        if (aux2.at<float>(x, oj) >= 6)
        {
            specials_count += 3;
        }

        x--;
    }

    // Bottom check
    x = oi + 1;
    while (x < aux.rows && aux.at<float>(x, oj) == aux.at<float>(oi, oj))
    {
        candies_at_bottom++;

        if (aux2.at<float>(x, oj) >= 6)
        {
            specials_count += 3;
        }

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

        return -1;
    }

    return move + specials_count;
}

Agent::Movement Agent::f(cv::Mat perception)
{
    struct Movement move;
    move.x = -1;
    move.y = -1;
    move.direction = -1;
    move.utility = -1;

    // Save the best amount of candies before moving
    int candies_count[6] = {0, 0, 0, 0, 0, 0};

    for (int i = 0; i < MATRIX_ROWS; i++)
    {
        for (int j = 0; j < MATRIX_COLS; j++)
        {
            int candy = perception.at<float>(i, j);

            if (candy == 24)
                continue;

            int factor = (candy % 6) + 1;
            int color = candy % 6;

            candies_count[color] += factor;
        }
    }

    int utility = -1;

    for (int i = 0; i < MATRIX_ROWS; i++)
    {
        for (int j = 0; j < MATRIX_COLS; j++)
        {
            if (j <= 7)
            {
                utility = evaluate(perception, candies_count, i, j, i, j + 1);
                if (move.utility <= utility)
                {
                    move.x = i;
                    move.y = j;
                    move.direction = RIGHT;
                    move.utility = utility;
                }
            }

            if (j >= 1)
            {
                utility = evaluate(perception, candies_count, i, j, i, j - 1);
                if (move.utility <= utility)
                {
                    move.x = i;
                    move.y = j;
                    move.direction = LEFT;
                    move.utility = utility;
                }
            }

            if (i >= 1)
            {
                utility = evaluate(perception, candies_count, i, j, i - 1, j);
                if (move.utility <= utility)
                {
                    move.x = i;
                    move.y = j;
                    move.direction = UP;
                    move.utility = utility;
                }
            }

            if (i <= 7)
            {
                utility = evaluate(perception, candies_count, i, j, i + 1, j);
                if (move.utility <= utility)
                {
                    move.x = i;
                    move.y = j;
                    move.direction = DOWN;
                    move.utility = utility;
                }
            }
        }
    }

    return move;
}

// SECOND APPROACH
Agent::Option checkPossible(cv::Mat perception, int *counts, int oi, int oj, int i, int j)
{

    struct Agent::Option option;
    option.r = 0;
    option.l = 0;
    option.t = 0;
    option.b = 0;
    option.utility = -1;

    int color = perception.at<float>(oi, oj);
    int colorSide = perception.at<float>(i, j);

    if (color == 24 && colorSide == 24)
    {
        option.utility = 200;
        return option;
    }

    if (color == 24 && colorSide >= 18 && colorSide <= 23)
    {
        option.utility = 180 + counts[colorSide % 6];
        return option;
    }

    if (color == 24 && colorSide >= 6 && colorSide <= 17)
    {
        option.utility = 170 + counts[colorSide % 6];
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
        option.utility = 80 + counts[colorSide % 6];
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

    int move = -1;

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
        return option;
    }

    option.r = candies_at_right;
    option.l = candies_at_left;
    option.t = candies_at_top;
    option.b = candies_at_bottom;
    option.utility = move;
    return option;
}

// Get all possible movements
vector<Agent::Movement> getMovements(cv::Mat perception, int *counts)
{
    vector<Agent::Movement> possible_movements;

    Agent::Option move;

    for (int i = 0; i < MATRIX_ROWS; i++)
    {
        for (int j = 0; j < MATRIX_COLS; j++)
        {
            if (j <= 7)
            {
                move = checkPossible(perception, counts, i, j, i, j + 1);

                if (move.utility > 0)
                {
                    Agent::Movement movement;
                    movement.x = i;
                    movement.y = j;
                    movement.direction = RIGHT;
                    movement.utility = move.utility;
                    movement.option = move;

                    possible_movements.push_back(movement);
                }
            }

            if (j >= 1)
            {
                move = checkPossible(perception, counts, i, j, i, j - 1);

                if (move.utility > 0)
                {
                    Agent::Movement movement;
                    movement.x = i;
                    movement.y = j;
                    movement.direction = LEFT;
                    movement.utility = move.utility;
                    movement.option = move;

                    possible_movements.push_back(movement);
                }
            }

            if (i >= 1)
            {
                move = checkPossible(perception, counts, i, j, i - 1, j);

                if (move.utility > 0)
                {
                    Agent::Movement movement;
                    movement.x = i;
                    movement.y = j;
                    movement.direction = UP;
                    movement.utility = move.utility;
                    movement.option = move;

                    possible_movements.push_back(movement);
                }
            }

            if (i <= 7)
            {
                move = checkPossible(perception, counts, i, j, i + 1, j);

                if (move.utility > 0)
                {
                    Agent::Movement movement;
                    movement.x = i;
                    movement.y = j;
                    movement.direction = DOWN;
                    movement.utility = move.utility;
                    movement.option = move;

                    possible_movements.push_back(movement);
                }
            }
        }
    }

    return possible_movements;
}

// Utilities for updating momentum matrix
void removeCandy(cv::Mat &momentum, int x, int y)
{
    // Remove candy from momentum matrix
    momentum.at<float>(x, y) = -1;

    // Increase momentum on candies that are above
    for (int i = x - 1; i >= 0; i--)
    {
        if (momentum.at<float>(i, y) == -1)
            continue;

        momentum.at<float>(i, y)++;
    }
}

void removeCandy2(cv::Mat &perception, int x, int y, int row_count = 1)
{
    if (perception.at<float>(x, y) == -1)
        return;
    for (int i = x; i >= 0; i--)
    {
        if (i - row_count >= 0)
        {
            // Just replace with the one above
            perception.at<float>(i, y) = perception.at<float>(i - row_count, y);
        }
        else
        {
            perception.at<float>(i, y) = -1;
        }
    }
}

// Mark candy as matched and check if should be matched
void evaluateCandy(cv::Mat perception, cv::Mat &matched_candies_src, int x, int y)
{
    if (perception.at<float>(x, y) == -1)
        return;

    if (matched_candies_src.at<float>(x, y) > 0)
        return;

    int color = perception.at<float>(x, y);

    cv::Mat matched_candies(MATRIX_ROWS, MATRIX_COLS, CV_32F);
    matched_candies_src.copyTo(matched_candies);

    if (color >= 6 && color <= 11)
    {
        // Horizontal candy, all rows are matched
        for (int i = 0; i < MATRIX_ROWS; i++)
        {
            matched_candies.at<float>(i, y) = 1;
            evaluateCandy(perception, matched_candies, i, y);
        }
    }

    if (color >= 12 && color <= 17)
    {
        // Vertical candy, all columns are matched
        for (int i = 0; i < MATRIX_COLS; i++)
        {
            matched_candies.at<float>(x, i) = 1;
            evaluateCandy(perception, matched_candies, x, i);
        }
    }

    if (color >= 18 && color <= 23)
    {
        // Packed candy, 9x9 matrix is matched
        for (int i = max(0, x - 1); i < min(MATRIX_ROWS, x + 2); i++)
        {
            for (int j = max(0, y - 1); j < min(MATRIX_COLS, y + 2); j++)
            {
                matched_candies.at<float>(i, j) = 1;
                evaluateCandy(perception, matched_candies, i, j);
            }
        }
    }

    if (color == 24)
    {
        // Black candy, (lets assume all caandies are matched)
        for (int i = 0; i < MATRIX_ROWS; i++)
        {
            for (int j = 0; j < MATRIX_COLS; j++)
            {
                matched_candies.at<float>(i, j) = 1;
            }
        }
    }

    matched_candies.at<float>(x, y) = 1;

    matched_candies_src = matched_candies;
}

// Evaluate momentums update on matches
int updateMomentum(cv::Mat &perception, int trig_x = -1, int trig_y = -1)
{
    // Save a record of checked cells in order to prevent from counting the same cell twice
    cv::Mat matched_cells = cv::Mat::zeros(MATRIX_ROWS, MATRIX_COLS, CV_32F);

    if (trig_x != -1 && trig_y != -1)
    {
        evaluateCandy(perception, matched_cells, trig_x, trig_y);
    }

    for (int i = 0; i < MATRIX_ROWS; i++)
    {
        for (int j = 0; j < MATRIX_COLS; j++)
        {
            if (perception.at<float>(i, j) == -1)
                continue;

            int color = perception.at<float>(i, j);

            if (color == 24)
                // Not that useful for this case
                continue;

            int color_index = color % 6;

            int neighbors_right = 0;
            int neighbors_bottom = 0;

            // Vertical matching
            for (int k = i + 1; k < MATRIX_ROWS; k++)
            {
                int neighbor_color_src = perception.at<float>(k, j);

                if (neighbor_color_src == -1)
                    break;

                int neighbor_color = neighbor_color_src % 6;

                if (neighbor_color == color_index)
                {
                    neighbors_bottom++;
                }
                else
                {
                    break;
                }
            }

            // Horizontal matching
            for (int k = j + 1; k < MATRIX_COLS; k++)
            {
                int neighbor_color_src = perception.at<float>(i, k);

                if (neighbor_color_src == -1)
                    break;

                int neighbor_color = neighbor_color_src % 6;

                if (neighbor_color == color_index)
                {
                    neighbors_right++;
                }
                else
                {
                    break;
                }
            }

            if (neighbors_right >= 2)
            {
                // Remove candies
                for (int k = j; k < j + neighbors_right + 1; k++)
                {
                    evaluateCandy(perception, matched_cells, i, k);
                }
            }

            if (neighbors_bottom >= 2)
            {
                // Remove candies
                for (int k = i; k < i + neighbors_bottom + 1; k++)
                {
                    // cout << "Removing candy at: " << k << " " << j << endl;
                    evaluateCandy(perception, matched_cells, k, j);
                }
            }
        }
    }

    // Update matched candies
    for (int i = 0; i < MATRIX_ROWS; i++)
    {
        for (int j = 0; j < MATRIX_COLS; j++)
        {
            if (matched_cells.at<float>(i, j) > 0)
            {
                removeCandy2(perception, i, j);
            }
        }
    }

    // count non zero values in matched cells
    int broken_candies = cv::countNonZero(matched_cells);

    return broken_candies;
}

// Evaluate one movement and see how many candies will be removed
int evaluateMovement(cv::Mat perception, Agent::Movement movement)
{
    // Initialize momentum matrix with zeros
    cv::Mat momentum = cv::Mat::zeros(MATRIX_ROWS, MATRIX_COLS, CV_32F);

    perception = perception.clone();

    // Perform the movement
    int x_offset = (movement.direction == UP) ? -1 : (movement.direction == DOWN) ? 1
                                                                                  : 0;
    int y_offset = (movement.direction == RIGHT) ? 1 : (movement.direction == LEFT) ? -1
                                                                                    : 0;
    int temp = perception.at<float>(movement.x, movement.y);
    perception.at<float>(movement.x, movement.y) = perception.at<float>(movement.x + x_offset, movement.y + y_offset);
    perception.at<float>(movement.x + x_offset, movement.y + y_offset) = temp;

    // Perform first momentum check
    if (movement.utility >= 80)
        return movement.utility;

    // Remove candies from momentum matrix
    int utility = 0;

    int broken_candies = updateMomentum(perception, movement.x, movement.y);
    utility += broken_candies;
    while (broken_candies > 0)
    {
        broken_candies = updateMomentum(perception);
        utility += broken_candies;
    }

    return utility;
}

Agent::Movement
Agent::f2(cv::Mat perception)
{
    // Save the best amount of candies before moving
    int candies_count[6] = {0, 0, 0, 0, 0, 0};

    for (int i = 0; i < MATRIX_ROWS; i++)
    {
        for (int j = 0; j < MATRIX_COLS; j++)
        {
            int candy = perception.at<float>(i, j);

            if (candy == 24)
                continue;

            int factor = (candy % 6) + 1;
            int color = candy % 6;

            candies_count[color] += factor;
        }
    }

    vector<Agent::Movement> possible_movements = getMovements(perception, candies_count);
    int max_utility = -1;
    Agent::Movement best_movement;

    for (Agent::Movement movement : possible_movements)
    {
        int utility = evaluateMovement(perception, movement);

        if (utility > max_utility)
        {
            max_utility = utility;
            best_movement = movement;
        }
    }

    return best_movement;
}
