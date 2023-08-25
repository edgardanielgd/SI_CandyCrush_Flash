#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"
#include "image_decoder.h"
#include <Windows.h>
#include <iostream>
#include <tchar.h>

using namespace std;

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

    RECT windowsize; // get the height and width of the screen
    GetClientRect(hwnd, &windowsize);

    srcheight = windowsize.bottom;
    srcwidth = windowsize.right;
    height = windowsize.bottom / 1; // change this to whatever size you want to resize to
    width = windowsize.right / 1;

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

    printf("Starts...\n");
    // HWND hwndTarget = GetDesktopWindow();
    HWND hwndTarget = FindWindow(NULL, _T("Adobe Flash Player 10"));
    cout << hwndTarget << endl;
    int key = 0;

    SetForegroundWindow(hwndTarget);

    printf("Waiting for 10 seconds...\n");
    Sleep(10000);
    printf("Starts...\n");

    cv::Mat src = hwnd2mat(hwndTarget);

    cout << src.size() << endl;

    printf("Starts classifyPixels...\n");
    cv::Mat result = classifyPixels(src, matTemplates);
    printf("Ends classifyPixels...\n");

    cout << result.size() << endl;

    result = result * (255 / templates->size());

    cv::namedWindow("output", cv::WINDOW_NORMAL);
    cv::imshow("output", result);

    while (key != 27)
    {
        // cv::Mat src = hwnd2mat(hwndTarget);
        // cv::imshow("output", src);
        // cout << src << endl;
        key = cv::waitKey(60); // you can change wait time
    }

    printf("Press any key to exit...\n");
    return 0;
}