# RandomizedSMZ3MSU

This is a very basic powershell script for randomizing MSUs made for the [SMZ3 Cas' Randomizer](https://github.com/Vivelin/SMZ3Randomizer).

To run this, either download the [RandomizedSMZ3MSU.ps1](https://github.com/MattEqualsCoder/RandomizedSMZ3MSU/blob/main/RandomizedSMZ3MSU.ps1) powershell script file or copy its text and create a new file named RandomizedSMZ3MSU.ps1. Place the RandomizedSMZ3MSU.ps1 file is in the directory with all of the MSU folders.

![image](https://user-images.githubusercontent.com/63823784/200104170-362fcc64-438d-447c-add8-3097c9e52f38.png)

After that, right click on the RandomizedSMZ3MSU.ps1 and click Run with Powershell. It'll then scan through all of your MSU folders and find any that it thinks it can use. If you don't see an MSU file you're expecting, make sure that it's set to combined SMZ3.

![image](https://user-images.githubusercontent.com/63823784/200104571-1523a1dc-215c-4b6c-8907-0828f00cd791.png)


If the list of MSUs looks good, type in Y and hit enter. It'll thne create a new folder (default of RandomizedSMZ3MSU) with a randomized-smz3.msu file in it that you can use for generating a new seed.

## Issues/Questions

### Execution-Policy Error

Most computers are set to not trust downloaded powershell files. To get around this, sometimes you can create the RandomizedSMZ3MSU.ps1 file yourself and copy the contents into it and the computer will realize it's a local file. Otherwise you may need to do the following:

1. Open Powershell by hitting the Start Menu and typing in "Powershell"
2. Navigate to your MSU directory by typing in "cd <full path to your MSU directory" and hitting enter
3. Paste in the command "Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process" to bypass the execution policy this one time and enter A when prompted.
4. Type in .\RandomizedSMZ3MSU.ps1 and hit enter

### MSU Isn't Showing Up

Make sure that the MSU is set to SMZ3 combined.

### Changing Names

There are two lines at the top of the powershell file for the folder and msu names which can be modified.
