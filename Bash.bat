@echo off

@REM Get IP address
  ipconfig /all
  
#REM Clear DNS Cache (website loads on mobile but not on PC)
  ipconfig /flushdns