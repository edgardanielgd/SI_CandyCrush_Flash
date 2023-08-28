#include <windows.h>
#include <iostream>
#include <tchar.h>

using namespace std;

int main()
{
    while (true)
    {
        POINT p;
        if (GetCursorPos(&p))
        {
            cout << p.x << " " << p.y << endl;
        }
        Sleep(3000);
    }
    // HWND hwndTarget = FindWindow(NULL, _T("Adobe Flash Player 10"));
    // RECT windowsize; // get the height and width of the screen
    // GetClientRect(hwndTarget, &windowsize);

    // cout << windowsize.top << " " << windowsize.left << endl;
    // cout << windowsize.bottom << " " << windowsize.right << endl;

    // Sleep(5000);
    // SetForegroundWindow(hwndTarget);
    // SetCursorPos(395, 230);
}