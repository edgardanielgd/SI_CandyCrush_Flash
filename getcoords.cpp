#include <windows.h>
#include <iostream>

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
        Sleep(1000);
    }
}