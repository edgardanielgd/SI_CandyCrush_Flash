#include "gesture_simulator.h"
#include "commons.h"
#include <iostream>

using namespace std;

void moveMouse(HWND hwnd, int x, int y, int direction)
{

    /*
        Direction notation:
        1 -> Right
        2 -> Left
        3 -> Upside
        4 -> Downside
    */

    RECT windowsize; // get the height and width of the screen
    GetClientRect(hwnd, &windowsize);

    SetForegroundWindow(hwnd);

    int width = windowsize.right;
    int height = windowsize.bottom;
    int left = windowsize.left;
    int top = windowsize.top;

    int px = MATRIX_OFFSET_X + EXTRA_WINDOW_OFFSET_X + left + y * CELL_SIZE_X + CELL_SIZE_X / 2;
    int py = MATRIX_OFFSET_Y + EXTRA_WINDOW_OFFSET_Y + top + x * CELL_SIZE_Y + CELL_SIZE_Y / 2;

    int y_offset = direction == UP ? -CELL_SIZE_Y : direction == DOWN ? CELL_SIZE_Y
                                                                      : 0;
    int x_offset = direction == RIGHT ? CELL_SIZE_X : direction == LEFT ? -CELL_SIZE_X
                                                                        : 0;

    clickMouse(hwnd, px, py);
    Sleep(100);
    clickMouse(hwnd, px + x_offset, py + y_offset);
}

void clickMouse(HWND hwnd, int wx, int wy)
{
    SetForegroundWindow(hwnd);

    SetCursorPos(wx, wy);
    mouse_event(MOUSEEVENTF_LEFTDOWN, wx, wy, 0, 0);
    mouse_event(MOUSEEVENTF_LEFTUP, wx, wy, 0, 0);
}