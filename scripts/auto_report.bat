@echo off
setlocal EnableExtensions
REM Xac dinh root tu vi tri file BAT
set "PROJECT_ROOT=%~dp0.."
for %%I in ("%PROJECT_ROOT%") do set "PROJECT_ROOT=%%~fI"
set "LOG_FILE=%PROJECT_ROOT%\data\log-he-thong.log"
set "BACKUP_DIR=%PROJECT_ROOT%\backup"
set "REPORT_FILE=%BACKUP_DIR%\bao-cao-su-co.txt"

REM AUDIT: chi kiem tra/tao thu muc, khong xoa du lieu
if not exist "%LOG_FILE%" (
  echo [ERROR] Khong tim thay file log: "%LOG_FILE%"
  exit /b 1
)
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

(
  echo.
  echo ===== GREENTECH INCIDENT REPORT =====
  echo Source: %LOG_FILE%
  echo Generated: %date% %time%
  echo -------------------------------------
) >> "%REPORT_FILE%"

REM TYPE dua du lieu theo luong qua Pipe; FINDSTR loc CRITICAL va ERROR
REM >> ghi noi tiep, khong ghi de bao cao cu
type "%LOG_FILE%" | findstr /I /C:"CRITICAL" /C:"ERROR" >> "%REPORT_FILE%"
if errorlevel 2 (
  echo [ERROR] Loi khi doc hoac loc log.
  exit /b 2
)
echo [DONE] Bao cao da duoc cap nhat: "%REPORT_FILE%"
endlocal
exit /b 0
