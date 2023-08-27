#include "gesture_simulator.h"
#include "commons.h"
#include <iostream>

using namespace std;

void moveMouse(HWND hwnd, int x, int y, int direction)
{
    RECT windowsize; // get the height and width of the screen
    GetClientRect(hwnd, &windowsize);

    SetForegroundWindow(hwnd);

    int width = windowsize.right;
    int height = windowsize.bottom;
    int left = windowsize.left;
    int top = windowsize.top;

    cout << left << " " << top << " " << width << " " << height << endl;

    int px = MATRIX_OFFSET_X + EXTRA_WINDOW_OFFSET_X + left + y * CELL_SIZE_X + CELL_SIZE_X / 2;
    int py = MATRIX_OFFSET_Y + EXTRA_WINDOW_OFFSET_Y + top + x * CELL_SIZE_Y + CELL_SIZE_Y / 2;

    cout << px << " " << py << endl;

    SetCursorPos(px, py);

    Sleep(10000);

    /*
        Direction notation:
        1 -> Right
        2 -> Left
        3 -> Upside
        4 -> Downside
    */
    int y_offset = direction == 3 ? -CELL_SIZE_Y : direction == 4 ? CELL_SIZE_Y
                                                                  : 0;
    int x_offset = direction == 1 ? CELL_SIZE_X : direction == 2 ? -CELL_SIZE_X
                                                                 : 0;

    // Click right mouse button
    INPUT input;
    input.type = INPUT_MOUSE;
    input.mi.mouseData = 0;
    input.mi.time = 0;
    input.mi.dx = px + x_offset;
    input.mi.dy = py + y_offset;
    input.mi.dwFlags = MOUSEEVENTF_LEFTDOWN;

    SendInput(1, &input, sizeof(input));

    // Raise the mouse button
    input.mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(1, &input, sizeof(input));
}

void clickMouse(HWND hwnd, int x, int y)
{
    SetForegroundWindow(hwnd);

    INPUT input;
    input.type = INPUT_MOUSE;
    input.mi.mouseData = 0;
    input.mi.time = 0;
    input.mi.dx = x;
    input.mi.dy = y;
    input.mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    SendInput(1, &input, sizeof(input));

    input.mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(1, &input, sizeof(input));
}