@echo off
setlocal enabledelayedexpansion
for %%A in ("Cache" "Cookies" "Desktop" "Favorites" "History" "My Music" "My Pictures" "My Video" "Programs" "Recent" "SendTo" "Start Menu" "Startup" "AppData" "Local AppData") do (
	set /a line=0
	for /f "delims=" %%a in ('reg.exe query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "%%~A"') do (
		set /a line+=1
		if !line! equ 2 (
			for /f "tokens=3" %%b in ("%%a") do (
				if "%%~b"=="REG_EXPAND_SZ" (
					for /f "tokens=4,5" %%B in ("%%a") do (
					if not "%%C"=="" (
						for /f "delims=" %%n in ('echo^(%%B %%C') do (
							if exist "%%n" (set "%%~A=%%n") else (
								if /i "%%~A"=="programs" if exist "%%n Menu\Programs" set "%%~A=%%n Menu\Programs"
								if /i "%%~A"=="startup" if exist "%%n Menu\Programs\Startup" set "%%~A=%%n Menu\Programs\Startup"
							)
						)
					) else (
						for /f "delims=" %%N in ('echo^(%%B') do (
							if exist "%%N" (set "%%~A=%%N") else (if /i "%%~A"=="programs" set "%%~A=%%N Menu\Programs") 
							if /i "%%~A"=="startup" if exist "%%N Menu\Programs\Startup" set "%%~A=%%N Menu\Programs\Startup"
							)
						)
					)
				) else (
					for /f "delims=" %%# in ('echo^(%%b') do (
						if exist "%%#" (set "%%~A=%%#") else (if /i "%%~A"=="programs" set "%%~A=%%# Menu\Programs")
						if /i "%%~A"=="startup" if exist "%%# Menu\Programs\Startup" set "%%~A=%%# Menu\Programs\Startup"
					)
				)
			)
		)
	)
)
exit /b 0





