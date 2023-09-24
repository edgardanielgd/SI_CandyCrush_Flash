#include "agent.h"
#include "commons.h"
#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"
#include <vector>
#include <iostream>

using namespace std;

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

Agent::Option checkPossible(cv::Mat perception, int oi, int oj, int i, int j)
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
vector<Agent::Movement> getMovements(cv::Mat perception)
{
    vector<Agent::Movement> possible_movements;

    Agent::Option move;

    for (int i = 0; i < MATRIX_ROWS; i++)
    {
        for (int j = 0; j < MATRIX_COLS; j++)
        {
            if (j <= 7)
            {
                move = checkPossible(perception, i, j, i, j + 1);

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
                move = checkPossible(perception, i, j, i, j - 1);

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
                move = checkPossible(perception, i, j, i - 1, j);

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
                move = checkPossible(perception, i, j, i + 1, j);

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
    for (int i = y; i > 0; i--)
    {
        if (i - row_count > 0)
        {
            // Just replace with the one above
            perception.at<float>(x, i) = perception.at<float>(x, i - row_count);
        }
        else
        {
            perception.at<float>(x, i) = -1;
        }
    }
}

// utility for evaluating a neighbor
void evaluateNeighbor(cv::Mat &perception, cv::Mat &momentum, int i, int j, int color_index, bool &has_factor, int &neighbors)
{
    int neighbor_momentum = momentum.at<float>(i, j);
    int new_i = i + neighbor_momentum;

    int neighbor_color = perception.at<float>(i, j);
    bool neighbor_has_factor = neighbor_color >= 6;
    neighbor_color = neighbor_color % 6;

    if (neighbor_color == color_index && neighbor_momentum > 0)
    {
        neighbors++;
        has_factor = has_factor || neighbor_has_factor;
    }
}

// Evaluate momentums update on matches
int updateMomentum(cv::Mat perception)
{
    int broken_candies;

    cv::Mat tmp_perception = perception.clone();

    for (int i = 0; i < MATRIX_ROWS; i++)
    {
        for (int j = 0; j < MATRIX_COLS; j++)
        {
            if (tmp_perception.at<float>(i, j) == -1)
                continue;

            int color = tmp_perception.at<float>(i, j);

            if (color == 24)
                // Not that useful for this case
                continue;

            bool has_factor = color >= 6;
            int color_index = color % 6;

            int neighbors_right = 0;
            int neighbors_bottom = 0;

            // Vertical matching
            for (int k = i + 1; k < MATRIX_ROWS; k++)
            {
                int neighbor_color = tmp_perception.at<float>(k, j);
                bool neighbor_has_factor = neighbor_color >= 6;
                neighbor_color = neighbor_color % 6;

                if (neighbor_color == color_index)
                {
                    neighbors_bottom++;
                    has_factor = has_factor || neighbor_has_factor;
                }
                else
                {
                    break;
                }
            }

            // Horizontal matching
            for (int k = j + 1; k < MATRIX_COLS; k++)
            {
                int neighbor_color = tmp_perception.at<float>(i, k);

                if (neighbor_color == -1)
                    break;

                bool neighbor_has_factor = neighbor_color >= 6;
                neighbor_color = neighbor_color % 6;

                if (neighbor_color == color_index)
                {
                    neighbors_right++;
                    has_factor = has_factor || neighbor_has_factor;
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
                    removeCandy2(tmp_perception, i, k);
                }

                broken_candies += neighbors_right;
            }

            if (neighbors_bottom >= 2)
            {
                // Remove candies
                for (int k = i; k < i + neighbors_bottom + 1; k++)
                {
                    removeCandy2(tmp_perception, k, j);
                }

                broken_candies += neighbors_bottom;
            }
        }
    }

    return broken_candies;
}

// Evaluate one movement and see how many candies will be removed
int evaluateMovement(cv::Mat perception, Agent::Movement movement)
{
    // Initialize momentum matrix with zeros
    cv::Mat momentum = cv::Mat::zeros(MATRIX_ROWS, MATRIX_COLS, CV_32F);

    perception = perception.clone();

    // Perform the movement
    int x_offset = (movement.direction == RIGHT) ? 1 : (movement.direction == LEFT) ? -1
                                                                                    : 0;
    int y_offset = (movement.direction == UP) ? -1 : (movement.direction == DOWN) ? 1
                                                                                  : 0;

    int temp = perception.at<float>(movement.x, movement.y);
    perception.at<float>(movement.x, movement.y) = perception.at<float>(movement.x + x_offset, movement.y + y_offset);
    perception.at<float>(movement.x + x_offset, movement.y + y_offset) = temp;

    // Perform first momentum check
    if (movement.utility >= 94)
        return movement.utility;

    // Remove candies from momentum matrix
    int utility = 0;

    int broken_candies = updateMomentum(perception);
    while (broken_candies > 0)
    {
        utility += broken_candies = updateMomentum(perception);
    }

    return utility;
}

Agent::Movement
Agent::f2(cv::Mat perception)
{
    vector<Agent::Movement> possible_movements = getMovements(perception);
    int max_utility = -1;
    Agent::Movement best_movement;

    for (Agent::Movement movement : possible_movements)
    {
        cout << "Evaluating movement: " << movement.x << " " << movement.y << " " << movement.direction << endl;
        int utility = evaluateMovement(perception, movement);

        if (utility > max_utility)
        {
            max_utility = utility;
            best_movement = movement;
        }
    }

    return best_movement;
}
