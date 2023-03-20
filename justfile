now := `date +%s`
bag := "kalibr-data-" + now + ".bag"
cwd := `pwd`

default:
	@just --list

alias r := record

# build-container:
# 	# test -d ./kalibr
# 	# if ! docker image inspect kalibr > /dev/null 2>&1; then; 
# 		# docker build -t kalibr ./kalibr; \
# 	# fi


# taken from https://github.com/ethz-asl/kalibr.git
enter-container:
	xhost +local:root
	docker run -it --rm \
		--env="DISPLAY" \
		--env="QT_X11_NO_MITSHM=1" \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--volume={{cwd}}:/data \
		kalibr



# start the ZED SDK wrapper
[unix]
start-zedm:
	ros2 launch zed_wrapper zedm.launch.py

# record a ros2 bag of the left and right camera sensor and the IMU data
record:
	ros2 bag record -o {{bag}} /zedm/zed_node/imu/data_raw /zedm/zed_node/left/image_rect_color /zedm/zed_node/right/image_rect_color	

convert-rosbag-to-ros1-format:
	@echo "TODO"

calibrate-cameras:
	kalibr_calibrate_cameras --bag {{bag}} --topics /zedm/zed_node/left/image_rect_color /zedm/zed_node/right/image_rect_color --models pinhole-radtan pinhole-radtan --target april_10x6_53.2x32.4cm.yaml