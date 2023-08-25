#ifndef GESTURE_SIMULATOR_H
#define GESTURE_SIMULATOR_H

#include <iostream>
#include <Windows.h>

void moveMouse(HWND hwnd, int x, int y, char direction);

void clickMouse(HWND hwnd, int x, int y);

#endif