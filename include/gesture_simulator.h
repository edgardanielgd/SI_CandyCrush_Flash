#ifndef GESTURE_SIMULATOR_H
#define GESTURE_SIMULATOR_H

#include <iostream>
#include <Windows.h>

void moveMouse(HWND hwnd, int x, int y, int direction);

// Have care, coordinates are in screen coordinates
void clickMouse(HWND hwnd, int wx, int wy);

#endif