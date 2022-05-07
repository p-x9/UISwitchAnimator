#  UISwitchAnimator

## Sample
<iframe width="560" height="315" src="https://www.youtube.com/embed/_v6e0ATcWUA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

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