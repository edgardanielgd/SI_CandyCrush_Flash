CC = g++
CFLAGS = -std=c++11 -Wall -Wextra
PKG_FLAGS = -ID:/MSYS2/mingw64/include/opencv4 -LD:/MSYS2/mingw64/lib -lopencv_gapi -lopencv_stitching -lopencv_alphamat -lopencv_aruco -lopencv_bgsegm -lopencv_ccalib -lopencv_cvv -lopencv_dnn_objdetect -lopencv_dnn_superres -lopencv_dpm -lopencv_face -lopencv_freetype -lopencv_fuzzy -lopencv_hdf -lopencv_hfs -lopencv_img_hash -lopencv_intensity_transform -lopencv_line_descriptor -lopencv_mcc -lopencv_ovis -lopencv_quality -lopencv_rapid -lopencv_reg -lopencv_rgbd -lopencv_saliency -lopencv_sfm -lopencv_stereo -lopencv_structured_light -lopencv_phase_unwrapping -lopencv_superres -lopencv_optflow -lopencv_surface_matching -lopencv_tracking -lopencv_highgui -lopencv_datasets -lopencv_text -lopencv_plot -lopencv_videostab -lopencv_videoio -lopencv_viz -lopencv_wechat_qrcode -lopencv_xfeatures2d -lopencv_shape -lopencv_ml -lopencv_ximgproc -lopencv_video -lopencv_xobjdetect -lopencv_objdetect -lopencv_calib3d -lopencv_imgcodecs -lopencv_features2d -lopencv_dnn -lopencv_flann -lopencv_xphoto -lopencv_photo -lopencv_imgproc -lopencv_core -lgdi32
INC_FLAGES = -I./include
CPP_FILES = ./include/*.cpp

all: main

main:
	$(CC) main.cpp $(CPP_FILES) -o main.exe $(CFLAGS) $(PKG_FLAGS) $(INC_FLAGES)

cpos:
	$(CC) getcoords.cpp -o cpos.exe -lgdi32

sensorTest:
	$(CC) testImageCrop.cpp $(CPP_FILES) -o sensorTest.exe $(CFLAGS) $(PKG_FLAGS) $(INC_FLAGES)

agentTest:
	$(CC) testMove.cpp $(CPP_FILES) -o testMove.exe $(CFLAGS) $(PKG_FLAGS) $(INC_FLAGES)

cposexec:
	./cpos

exec:
	./main

sensor:
	./sensorTest

agent:
	./testMove

clean:
	del main.exe