## IdleUserCloseProgram.au3
Get Idle Time for a specific application window and child windows with different titles.

### Features
- The script can be set to work during certain time periods.
- Warnings can be shown when reaching the idle time limit
- Has a tooltip to check functionality when troubleshooting.
- 2 idle times can be set separately, active window and background

### Case of success

We use it to automatically disconnect idle users on [Sigrid ERP](https://prosoft.es/productos/sigrid) software, as it open multiple windows for each
function.


The script detects both if the user is absent with the window active and does not use the mouse, as well as if the window is in the background and is not used in the stipulated time, it ends the process to release the license.

### How to use

- Install Autoit and SciTE Editor
- Download and modify code
- Tools > Compile (it will create en exe in same path as script)
- Copy exe to C:\Users\[User Name]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup or your favorite method to execute things at startup.

### Thanks to jpatdfl
