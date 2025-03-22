sudo apt update
sudo apt install git git-lfs zipalign apksigner
sudo git lfs install
git clone https://github.com/MusicPlayerDaemon/MPD.git input
cd input
mkdir -p output/android
cd ./output/android
python3 ../../android/build.py $ANDROID_SDK_ROOT $ANDROID_NDK_HOME arm64-v8a --buildtype=debugoptimized -Db_ndebug=true -Dwrap_mode=forcefallback
cd -
cd ./android
export JAVA_HOME=$JAVA_HOME_17_X64
./gradlew --no-daemon --stacktrace assembleArm64-v8aDebug
mkdir ../../output
cp app/build/outputs/apk/arm64-v8a/debug/*.apk ../../output
zipalign -p 4 ../../output/*.apk ../../output/aligned.apk
apksigner sign --ks-key-alias lob --ks ../sign.keystore --ks-pass pass:369852 --key-pass pass:369852 ../../output/aligned.apk
mkdir ../../prebuilt
cp ../../output/aligned.apk ../../prebuilt/mpd.apk
