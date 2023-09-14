#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"
#include "image_decoder.h"
#include "gesture_simulator.h"
#include "commons.h"
#include "agent.h"
#include <Windows.h>
#include <iostream>
#include <tchar.h>
#include <chrono>

using namespace std;
using namespace std::chrono;

cv::Mat hwnd2mat(HWND hwnd)
{
    HDC hwindowDC, hwindowCompatibleDC;

    int height, width, srcheight, srcwidth;
    HBITMAP hbwindow;
    cv::Mat src;
    BITMAPINFOHEADER bi;

    hwindowDC = GetDC(hwnd);
    hwindowCompatibleDC = CreateCompatibleDC(hwindowDC);
    SetStretchBltMode(hwindowCompatibleDC, COLORONCOLOR);

    srcheight = WINDOW_HEIGHT;
    srcwidth = WINDOW_WIDTH;
    height = WINDOW_HEIGHT; // change this to whatever size you want to resize to
    width = WINDOW_WIDTH;

    src.create(height, width, CV_8UC4);

    // create a bitmap
    hbwindow = CreateCompatibleBitmap(hwindowDC, width, height);
    bi.biSize = sizeof(BITMAPINFOHEADER); // http://msdn.microsoft.com/en-us/library/windows/window/dd183402%28v=vs.85%29.aspx
    bi.biWidth = width;
    bi.biHeight = -height; // this is the line that makes it draw upside down or not
    bi.biPlanes = 1;
    bi.biBitCount = 32;
    bi.biCompression = BI_RGB;
    bi.biSizeImage = 0;
    bi.biXPelsPerMeter = 0;
    bi.biYPelsPerMeter = 0;
    bi.biClrUsed = 0;
    bi.biClrImportant = 0;

    // use the previously created device context with the bitmap
    SelectObject(hwindowCompatibleDC, hbwindow);
    // copy from the window device context to the bitmap device context
    StretchBlt(hwindowCompatibleDC, 0, 0, width, height, hwindowDC, 0, 0, srcwidth, srcheight, SRCCOPY); // change SRCCOPY to NOTSRCCOPY for wacky colors !
    GetDIBits(hwindowCompatibleDC, hbwindow, 0, height, src.data, (BITMAPINFO *)&bi, DIB_RGB_COLORS);    // copy from hwindowCompatibleDC to hbwindow

    // avoid memory leak
    DeleteObject(hbwindow);
    DeleteDC(hwindowCompatibleDC);
    ReleaseDC(hwnd, hwindowDC);

    return src;
}

int main()
{

    // First lets read all templates we want to search for
    vector<cv::Mat> matTemplates = getTemplates();

    HWND hwndTarget = FindWindow(NULL, _T("Adobe Flash Player 10"));
    RECT windowsize; // get the height and width of the screen
    GetClientRect(hwndTarget, &windowsize);

    int key = 0;

    // Crop the image and get only the candies matrix
    cv::Rect area(MATRIX_OFFSET_X, MATRIX_OFFSET_Y,
                  WINDOW_WIDTH - MATRIX_OFFSET_X - MATRIX_MARGIN_RIGHT,
                  WINDOW_HEIGHT - MATRIX_OFFSET_Y - MATRIX_MARGIN_BOTTOM);

    // Close after k second
    auto start = high_resolution_clock::now();

    Agent agent = Agent();

    while (true)
    {

        // Check process should end
        auto end = high_resolution_clock::now();
        auto duration = duration_cast<seconds>(end - start);

        if (duration.count() >= MAX_RUNTIME)
        {
            return 0;
        }

        SetWindowPos(
            hwndTarget, NULL,
            0, 0, WINDOW_WIDTH, WINDOW_HEIGHT,
            SWP_SHOWWINDOW);
        SetActiveWindow(hwndTarget);
        SetFocus(hwndTarget);

        cv::Mat src = hwnd2mat(hwndTarget);
        cv::Mat src_cropped = src(area);

        // cv::imwrite("output/original_cropped.png", src_cropped);

        // Load image from file
        // cv::Mat src_cropped = cv::imread("output/original_cropped.png", cv::IMREAD_UNCHANGED);

        cv::Mat matrix = generatePositionMatrix2(src_cropped, matTemplates);

        // Sleep(5000);
        // cout << "======" << endl;
        // cout << matrix << endl;
        // Sleep(3000);
        // cout << "======" << endl;

        Agent::Movement move = agent.f(matrix);

        if (move.x != -1 && move.y != -1)
        {
            moveMouse(hwndTarget, move.x, move.y, move.direction);
        }

        key = cv::waitKey(60); // you can change wait time
    }

    printf("Press any key to exit...\n");
    return 0;
}