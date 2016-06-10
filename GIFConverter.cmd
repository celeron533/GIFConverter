@ECHO OFF
ECHO ====== GIF Converter ======
ECHO  From http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html#content
ECHO  Windows version is ported by celeron533
ECHO ===========================

SET input=%~1
SET palette=%~dpn1.png
SET output=%~dpn1.gif

SET ffmpeg=%~dp0ffmpeg.exe
SET filters=fps=15,scale=320:-1:flags=lanczos
REM SET dither=sierra2_4a
SET dither=none

REM ECHO Input file: %input%
REM ECHO Palette file: %palette%
REM ECHO Output file: %output%
REM ECHO Filters: %filters%
REM ECHO FFmpeg: %ffmpeg%


REM Validation
IF "%input%"=="" (
	ECHO Please drag and drop video file to me directly.
	PAUSE
	EXIT 1
)

IF NOT EXIST "%ffmpeg%" (
	ECHO ffmpeg.exe not found in current folder.
	CHOICE /C yn /M "Would you like to download it?"
	IF ERRORLEVEL 2 ( 
		@ECHO OFF ) ^
	ELSE IF ERRORLEVEL 1 (
		START https://ffmpeg.zeranoe.com/builds/ )
	PAUSE
	EXIT 2
)
REM End of validation

ECHO ===== STEP 1 =====
ECHO   Generating palette file...
ECHO   Please wait...
CALL "%ffmpeg%" -v error -ss 0 -t 30 -i "%input%" -vf "%filters%,palettegen" -y "%palette%"
IF ERRORLEVEL 0 (
	ECHO   Palette file generated successed ) ^
ELSE (
	ECHO   Failed to generate palette file
	PAUSE
	EXIT 3
)

ECHO ===== STEP 2 =====
ECHO   Generating gif file...
ECHO   Please wait...
CALL "%ffmpeg%" -v error -ss 0 -t 30 -i "%input%" -i "%palette%" -lavfi "%filters% [x]; [x][1:v] paletteuse=dither=%dither%" -y "%output%"
IF ERRORLEVEL 0 (
	ECHO   Gif file generated successed ) ^
ELSE (
	ECHO   Failed to generate gif file
	DEL /Q "%palette%"
	PAUSE
	EXIT 4
)

DEL /Q "%palette%"

PAUSE