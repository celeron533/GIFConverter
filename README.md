# GIFConverter
A batch script for auto generating gif files by FFmpeg.exe on Windows

Bash script from: http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html

This repo is a ported version on Windows.

## Prerequisite
* Microsoft Windows
* FFmpeg (https://ffmpeg.org/download.html#build-windows)

## How to Use
1. Put the FFmpeg.exe and GIFConverter.cmd file in the same folder.
2. Drag & drop you video file (avi, mp4, 3gp, etc.) onto the batch file.
3. Wait for devlivering the GIF. The gif file is stored with video source in the same folder.
    * Input `C:\sample\video.mp4`
    * Output `C:\sample\video.gif`

## Settings
* You could edit the batch file to modify/add any settings or parameters as you wish.

#### Default settings (may change in the future)
* Time Range of the video clip: start from `00:00:00`, period is `30` seconds.
* Gif FPS: `15`
* Image scale/resize: `width=320, height=auto`
* Max number of colors for Gif palette: `256`
* Gif dither: `none`
