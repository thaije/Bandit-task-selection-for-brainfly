set batdir=%~dp0
cd %batdir%
rem start .\eeg_quickstart.bat eego %*
start .\debug_quickstart.bat
rem Weird windows hack to sleep for 2 secs to allow the buffer server to start
ping 127.0.0.1 -n 10 > nul

cd matlab\brainfly
start startDoubleSigProcBuffer.bat
rem Weird windows hack to sleep for 2 secs to allow the buffer server to start
ping 127.0.0.1 -n 5 > nul

start runBrainfly.bat
