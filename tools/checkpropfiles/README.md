Check Proprietary Files
========

*   **i9300_filelist.txt**:
    The system file list from: http://download.cyanogenmod.org/get/jenkins/42508/cm-10.1.3-i9300.zip

*   **i9300_propfiles.txt**:
    The proprietary file list for i9300

*   **i9300_android.txt**:
    The file list built from android source tree

*   **get_android_built_filelist.sh**:
    get android built file list

        ./get_android_built_filelist.sh i9300_filelist.txt i9300_propfiles.txt

*   **checkprops.sh**:
    check a proprietary file can be built from android source or NOT
        
        ./checkprops.sh ../../proprietary-files.txt i9300_android.txt
