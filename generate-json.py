import sys
import os
import numpy as np
import ffmpeg
import cv2
import json

class JsonEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.integer):
            return int(obj)
        elif isinstance(obj, np.floating):
            return float(obj)
        elif isinstance(obj, np.ndarray):
            return obj.tolist()
        else:
            return super(JsonEncoder, self).default(obj)
        

def resizeMovie(movie_path, width: int, height: int, fps = 10):
    stream = ffmpeg.input(movie_path)
    stream = ffmpeg.filter(stream, "fps", fps=fps, round="up")
    stream = ffmpeg.filter(stream, "hue", h=0, s=0)
    stream = ffmpeg.filter(stream, "scale", width, height)

    output_path = "tmp-"+os.path.basename(movie_path)
    stream = ffmpeg.output(stream, output_path)

    ffmpeg.run(stream)

    return output_path


def convert_to_frame_data(movie_path, width: int, height: int):
    cap_file = cv2.VideoCapture(movie_path)
    frame_list = np.empty(width*height)

    print('\n')
    while True:
        ret, frame = cap_file.read()
        if ret != True:
            break
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        frame_list = np.vstack((frame_list, gray.flatten()))
        print('.', end='', flush=True)

    frame_list = frame_list

    frame_count = int(np.size(frame_list) / width / height)
    frame_list.reshape((width*height, frame_count))

    return frame_list


def save_as_json_file(frame_list, file_name = 'data.json', value_name = 'data', threshold = 128):
    list = 1 * frame_list.astype(bool)
    list = frame_list > threshold
    list = 1 * list

    with open(file_name, 'w') as f:
        f.write(json.dumps(list,cls=JsonEncoder))


if __name__ == '__main__':
    movie_path = sys.argv[1]
    print(movie_path)
    if not movie_path:
        print("prease set movie path.")
        sys.exit()
    width = int(sys.argv[2])
    height = int(sys.argv[3])

    converted_path = resizeMovie(movie_path, width=width, height=height)
    frame_list = convert_to_frame_data(converted_path, width=width, height=height)

    output = "data.json"
    save_as_json_file(frame_list, file_name=output)

    print("\nSucceed with output: %s" % output)
    
