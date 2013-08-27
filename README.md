Device Tree for Lenovo K860/K860i (stuttgart)

What Works:

Camera
Camcoder
Wifi
Sensors
Audio
3D
Graphic
gps

What DOESNOT Work:
bluetooth heasset
wifi p2p

Build Guide:
-----------------------
**1. ia32-libs:**

        sudo dpkg --add-architecture i386
        sudo apt-get update
        sudo apt-get install ia32-libs

**2. build env:** 

        sudo apt-get install git-core gnupg flex bison python rar original-awk gawk p7zip-full gperf \
        libsdl1.2-dev libesd0-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev \
        pngcrush schedtool libc6-dev x11proto-core-dev libx11-dev libgl1-mesa-dev mingw32 tofrodos \
        python-markdown libxml2-utils g++-multilib lib32z1-dev ia32-libs lib32ncurses5-dev \
        lib32readline-gplv2-dev gcc-multilib g++-multilib ctags xsltproc

**3. sync cm-10.1 source:**

        mkdir -p ~/bin/
        mkdir -p ~/cm10.1/
        curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo
        chmod a+x ~/bin/repo
        export PATH=${PATH}:~/bin
        cd ~/cm10.1/
        repo init -u git://github.com/CyanogenMod/android.git -b cm-10.1
        repo sync -j4

**4. get prebuilt:**

        cd ~/cm10.1/vendor/cm/
        ./get-prebuilts

**5. get this repo source:**
    
        cd ~/cm10.1/
        git clone git@github.com:scue/android_device_lenovo_stuttgart.git device/lenovo/stuttgart
        (cd device/lenovo/stuttgart && git checkout cm-10.1)

**6. build for stuttgart:**

        . build/envsetup.sh
        breakfast stuttgart
        cd device/lenovo/stuttgart/
        mkdir tmp/
        ln -s /path/to/stack_system_dir tmp/system # NOTE: please replace '/path/to/stack_system_dir'
        ./extract-files.sh
        croot
        brunch stuttgart > out.txt 2>&1 &
        tail -f out.txt

**7. pack to a szb file(after built successfully):**

        cd device/lenovo/stuttgart/tools/
        ./repackszb.sh

