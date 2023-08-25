#include "gesture_simulator.h"

void moveMouse(HWND hwnd, int x, int y, char direction)
{
    RECT windowsize; // get the height and width of the screen
    GetClientRect(hwnd, &windowsize);

    SetForegroundWindow(hwnd);

    // int width = windowsize.right;
    // int height = windowsize.bottom;
    // int left = windowsize.left;
    // int top = windowsize.top;

    SetCursorPos(x, y);

    /*
        Direction notation:
        1 -> Right
        2 -> Left
        3 -> Upside
        4 -> Downside
    */
    int y_offset = direction == 3 ? -10 : direction == 4 ? 10
                                                         : 0;
    int x_offset = direction == 1 ? 10 : direction == 2 ? -10
                                                        : 0;

    // Click right mouse button
    INPUT input;
    input.type = INPUT_MOUSE;
    input.mi.mouseData = 0;
    input.mi.time = 0;
    input.mi.dx = x + x_offset;
    input.mi.dy = y + y_offset;
    input.mi.dwFlags = MOUSEEVENTF_RIGHTDOWN;

    SendInput(1, &input, sizeof(input));

    // Raise the mouse button
    input.mi.dwFlags = MOUSEEVENTF_RIGHTUP;
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