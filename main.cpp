#include "opencv2/imgproc.hpp"
#include "opencv2/highgui.hpp"
#include "image_decoder.h"
#include "gesture_simulator.h"
#include "commons.h"
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

    cout << windowsize.top << " " << windowsize.left << endl;
    cout << windowsize.bottom << " " << windowsize.right << endl;

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

    // HWND hwndTarget = GetDesktopWindow();
    HWND hwndTarget = FindWindow(NULL, _T("Adobe Flash Player 10"));
    RECT windowsize; // get the height and width of the screen
    GetClientRect(hwndTarget, &windowsize);

    int key = 0;

    // Lets see all classes with different colors
    // int colors[26][3];
    // for (int i = 0; i < 26; i++)
    // {
    //     colors[i][0] = rand() % 255;
    //     colors[i][1] = rand() % 256;
    //     colors[i][2] = rand() % 256;
    // }

    // cv::namedWindow("classified", cv::WINDOW_NORMAL);
    // cv::imshow("classified", src);

    // Format results matrix to print each class with a different color
    // for (int i = 0; i < result.rows; i++)
    // {
    //     for (int j = 0; j < result.cols; j++)
    //     {
    //         int index = result.at<float>(i, j) - 1;
    //         if (index >= 0)
    //         {
    //             result.at<cv::Vec3b>(i, j) = cv::Vec3b(
    //                 colors[index][0], colors[index][1], colors[index][2]);
    //         }
    //         else
    //         {
    //             result.at<cv::Vec3b>(i, j) = cv::Vec3b(0, 0, 0);
    //         }
    //     }
    // }

    // cv::namedWindow("output", cv::WINDOW_NORMAL);
    // cv::imshow("output", result);

    // Generate final matrix

    SetWindowPos(
        hwndTarget, NULL,
        0, 0, 800, 650,
        SWP_SHOWWINDOW);
    SetActiveWindow(hwndTarget);
    SetFocus(hwndTarget);

    cv::Mat src = hwnd2mat(hwndTarget);

    cv::Rect area(MATRIX_OFFSET_X, MATRIX_OFFSET_Y,
                  src.cols - MATRIX_OFFSET_X - MATRIX_MARGIN_RIGHT,
                  src.rows - MATRIX_OFFSET_Y);

    cv::imwrite("original.png", src);

    cv::Mat src_cropped = src(area);
    cv::imwrite("original_cropped.png", src_cropped);

    cv::Mat result = classifyPixels(src, matTemplates);
    cv::imwrite("result.png", result);

    cv::Mat result_cropped = result(area);
    cv::imwrite("result_cropped.png", result_cropped);

    // Simulate mouse movement in a given direction
    int x, y, direction;

    moveMouse(hwndTarget, 0, 0, 1);

    cv::Mat matrix = generatePositionMatrix(result);
    cv::FileStorage file("matrix.xml", cv::FileStorage::WRITE);
    file << "matrix" << matrix;
    file.release();

    while (key != 27)
    {

        key = cv::waitKey(60); // you can change wait time
    }

    printf("Press any key to exit...\n");
    return 0;
}