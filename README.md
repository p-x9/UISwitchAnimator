#  UISwitchAnimator

## Sample
tap to open youtube video  
[![youtube](http://img.youtube.com/vi/_v6e0ATcWUA/0.jpg)](https://www.youtube.com/embed/_v6e0ATcWUA)

## Installation
### required
- OpenCV
- python
    - ffmpeg-python
    - cv2

### installation
1. Download this source.
1. Download your video.
1. Run script to generate json file for animation.  
please refer next section `generate json file`
1. Place generated json file which name is 'data.json' under 'UISwitchAnimator/UISwitchAnimato/'.

### generate json file
``` bash
python generate-json.py <downloaded video path> <width pixel> <height pixel>
```
sample
```bash:sample.sh
python generate-json.py video.mp4 48 36
```


## Usage
launch app and double tap view. 
