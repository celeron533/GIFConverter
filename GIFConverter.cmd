@ECHO OFF
ECHO ====== GIF Converter ======
ECHO  From http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html
ECHO    If you are using *nix sytem, please find the bash script from the URL above.
ECHO  Windows version is ported by celeron533, 20160611
ECHO    https://github.com/celeron533/GIFConverter
ECHO.
ECHO  ** NOTE: FFmpeg.exe is required for this script.
ECHO.

SET input=%~1
SET palette=%~dpn1.png
SET output=%~dpn1.gif

REM /* location of ffmpeg.exe */
SET ffmpeg=%~dp0ffmpeg.exe

REM /* start and end time of original video source */
SET timeRange=-ss 0 -t 30

REM /* set fps and scale */
SET filters=fps=15,scale=320:-1:flags=lanczos

REM /* maximum number of colors (<=256) to the palette */
SET maxColors=256

REM /* dither for the gif */
REM SET dither=none        //Small file size. Normal quality.
REM SET dither=sierra2     //Medium file size. Better quality.
REM SET dither=sierra2_4a  //Large file size. Bett quality.
SET dither=none


REM /* information */
ECHO [INFO] TimeRange: %timeRange%
ECHO [INFO] Filters  : %filters%
ECHO [INFO] MaxColors: %maxColors%
ECHO [INFO] Dither   : %dither%
ECHO [PATH] FFmpeg  file: %ffmpeg%
ECHO [PATH] Input   file: %input%
ECHO [PATH] Palette file: %palette%
ECHO [PATH] Output  file: %output%
ECHO.

REM /* validations */
IF "%input%"=="" (
	ECHO [MSG] Please drag and drop video file to me directly.
	PAUSE
	EXIT 1
)

IF NOT EXIST "%ffmpeg%" (
	ECHO [MSG] FFmpeg.exe not found in current folder.
	CHOICE /C yn /M "[MSG] Would you like to download it now?"
	IF ERRORLEVEL 2 ( 
		NUL ) ^
	ELSE IF ERRORLEVEL 1 (
		START https://ffmpeg.zeranoe.com/builds/ )
	PAUSE
	EXIT 2
)
REM /* end of validation */



ECHO [STEP1] Generating palette file, please wait...
CALL "%ffmpeg%" -v error %timeRange% -i "%input%" -vf "%filters%,palettegen=max_colors=%maxColors%" -y "%palette%"
IF ERRORLEVEL 0 (
	ECHO [STEP1] Palette file generated successfully. ) ^
ELSE (
	ECHO [STEP1] Failed to generate palette file.
	PAUSE
	EXIT 3
)
ECHO.

ECHO [STEP2] Generating gif file, please wait...
CALL "%ffmpeg%" -v error %timeRange% -i "%input%" -i "%palette%" -lavfi "%filters% [x]; [x][1:v] paletteuse=dither=%dither%" -y "%output%"
IF ERRORLEVEL 0 (
	ECHO [STEP2] Gif file generated successfully. ) ^
ELSE (
	ECHO [STEP2] Failed to generate gif file.
	DEL /Q "%palette%"
	PAUSE
	EXIT 4
)
ECHO.

DEL /Q "%palette%"

PAUSE