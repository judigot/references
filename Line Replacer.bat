@echo off

setlocal disableDelayedExpansion

:Variables
set InputFile=old.txt
set OutputFile=new.txt
set "_strFind=2"
set "_strInsert=replacement"

:Replace
>"%OutputFile%" (
  FOR /f "usebackq delims=" %%A IN ("%InputFile%") DO (
    IF "%%A" EQU "%_strFind%" (echo %_strInsert%) ELSE (echo %%A)
  )
)