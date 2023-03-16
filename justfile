now := `date +%s`
bag := "kalibr-data-" + now + ".bag"

default:
	@just --list

alias r := record

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