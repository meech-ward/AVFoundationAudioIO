AUDIO_IO_DIR="$(pwd)/../../../Entities/AudioIO"

echo "git \"$AUDIO_IO_DIR\"" > ../Cartfile

cd ../
carthage update --platform iOS

cd Carthage/Checkouts/AudioIO
swift package generate-xcodeproj

carthage build --platform iOS

cd ../../../
carthage update --platform iOS