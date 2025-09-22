sudo apt update
sudo apt install git git-lfs zipalign apksigner
sudo git lfs install
sudo apt install meson g++ pkgconf libfmt-dev libpcre2-dev libmad0-dev libmpg123-dev libid3tag0-dev libflac-dev libvorbis-dev libopus-dev libogg-dev libadplug-dev libaudiofile-dev libsndfile1-dev libfaad-dev libfluidsynth-dev libgme-dev libmikmod-dev libmodplug-dev libmpcdec-dev libwavpack-dev libwildmidi-dev libsidplay2-dev libsidutils-dev libresid-builder-dev libavcodec-dev libavformat-dev libmp3lame-dev libtwolame-dev libshine-dev libsamplerate0-dev libsoxr-dev libbz2-dev libcdio-paranoia-dev libiso9660-dev libmms-dev libzzip-dev libcurl4-gnutls-dev libexpat1-dev nlohmann-json3-dev libasound2-dev libao-dev libjack-jackd2-dev libopenal-dev libpulse-dev libshout3-dev libsndio-dev libmpdclient-dev libnfs-dev libupnp-dev libavahi-client-dev libsqlite3-dev libsystemd-dev libgtest-dev libicu-dev libchromaprint-dev libgcrypt20-dev libsystemd-dev libpipewire-0.3-dev
git clone https://github.com/MusicPlayerDaemon/MPD.git input
cd input
mkdir -p output/android
cd ./output/android
python3 ../../android/build.py $ANDROID_SDK_ROOT $ANDROID_NDK_HOME arm64-v8a --buildtype=debugoptimized -Db_ndebug=true -Did3tag=enabled -Dchromaprint=enabled -Dwrap_mode=forcefallback -Dsqlite=enabled -Dzeroconf=bonjour -Dlibmpdclient=enabled -Dipv6=enabled -Dudisks=enabled -Dwebdav=enabled -Dqobuz=enabled
cd -
cd ./android
export JAVA_HOME=$JAVA_HOME_17_X64
./gradlew --no-daemon --stacktrace assembleArm64-v8aDebug
mkdir ../../output
cp app/build/outputs/apk/arm64-v8a/debug/*.apk ../../output
zipalign -p 4 ../../output/*.apk ../../output/aligned.apk
apksigner sign --ks-key-alias lob --ks ../../sign.keystore --ks-pass pass:369852 --key-pass pass:369852 ../../output/aligned.apk
mkdir ../../prebuilt
cp ../../output/aligned.apk ../../prebuilt/mpd.apk
