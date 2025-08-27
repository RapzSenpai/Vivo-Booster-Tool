Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Show-Menu {
    $msg = @"
[VIVO Y17s GAME BOOSTER]

Choose what you want to do:

1. 🚀 Enable Gaming Mode
2. 🧹 Revert to Normal Mode
3. 📊 Check Current Settings
4. 🎮 Launch Mobile Legends
5. 🐝 Enable Battery Honey Mode
6. ❌ Exit
"@
    [System.Windows.MessageBox]::Show($msg, "Vivo Game Booster", "OKCancel", "Information")
}

function Run-ADB($cmd) {
    Start-Process "D:\RootKit\platform-tools\adb.exe" -ArgumentList $cmd -NoNewWindow -Wait
}

function Enable-GamingMode {
    Run-ADB "shell settings put global window_animation_scale 0.5"
    Run-ADB "shell settings put global transition_animation_scale 0.5"
    Run-ADB "shell settings put global animator_duration_scale 0.5"
    Run-ADB "shell settings put global debug.hwui.renderer skiavk"
    Run-ADB "shell settings put global force_gpu_rendering 1"
    Run-ADB "shell settings put global angle_gl_driver_selection_values all"
    Run-ADB "shell settings put global angle_gl_driver_all_angle 0"
    Run-ADB "shell settings put system peak_refresh_rate 90"
    Run-ADB "shell settings put system min_refresh_rate 90"
    Run-ADB "shell settings put global max_background_processes 2"
    Run-ADB "shell settings put global activity_manager_constants max_cached_processes=8"
    Run-ADB "shell settings put global master_sync_enabled 0"
    Run-ADB "shell settings put global avoid_bad_wifi 0"
    Run-ADB "shell settings put global wifi_sleep_policy 2"
    Run-ADB "shell settings put global game_package_name com.mobile.legends"
    Run-ADB "shell settings put global game_mode 2"
    [System.Windows.MessageBox]::Show("Gaming Mode Applied!", "Vivo Booster")
}

function Enable-BatteryHoney {
    Run-ADB "shell settings put global window_animation_scale 0"
    Run-ADB "shell settings put global transition_animation_scale 0"
    Run-ADB "shell settings put global animator_duration_scale 0"
    Run-ADB "shell dumpsys deviceidle enable"
    Run-ADB "shell dumpsys deviceidle force-idle"
    Run-ADB "shell settings put secure location_mode 1"
    Run-ADB "shell settings put global max_background_processes 1"
    Run-ADB "shell settings put global wifi_sleep_policy 2"
    Run-ADB "shell settings put global auto_sync 0"
    Run-ADB "shell settings put system peak_refresh_rate 60"
    Run-ADB "shell settings put system min_refresh_rate 60"
    [System.Windows.MessageBox]::Show("Battery Honey Mode Activated!", "Vivo Booster")
}

function Revert-ToNormal {
    Run-ADB "shell settings delete global game_package_name"
    Run-ADB "shell settings delete global game_mode"
    Run-ADB "shell settings delete global max_background_processes"
    Run-ADB "shell settings delete global activity_manager_constants"
    Run-ADB "shell settings put global force_gpu_rendering 0"
    Run-ADB "shell settings put global window_animation_scale 1"
    Run-ADB "shell settings put global transition_animation_scale 1"
    Run-ADB "shell settings put global animator_duration_scale 1"
    Run-ADB "shell settings put global auto_sync 1"
    Run-ADB "shell settings put secure location_mode 3"
    Run-ADB "shell settings put global wifi_sleep_policy 0"
    Run-ADB "shell settings put system peak_refresh_rate 60"
    Run-ADB "shell settings put system min_refresh_rate 60"
    [System.Windows.MessageBox]::Show("Settings Reverted to Normal Mode", "Vivo Booster")
}

function Check-Status {
    $adbPath = "D:\RootKit\platform-tools\adb.exe"

    $get = {
        param ($setting, $scope)
        try {
            & $adbPath shell settings get $scope $setting
        } catch {
            return "N/A"
        }
    }

    $output = @()
    $output += "{0,-25} {1}" -f "Animation Scale:",        (& $get "window_animation_scale" "global")
    $output += "{0,-25} {1}" -f "Transition Scale:",       (& $get "transition_animation_scale" "global")
    $output += "{0,-25} {1}" -f "Animator Scale:",         (& $get "animator_duration_scale" "global")
    $output += "{0,-25} {1}" -f "Max BG Processes:",       (& $get "max_background_processes" "global")
    $output += "{0,-25} {1}" -f "Game Package:",           (& $get "game_package_name" "global")
    $output += "{0,-25} {1}" -f "Game Mode:",              (& $get "game_mode" "global")
    $output += "{0,-25} {1}" -f "Peak Refresh Rate:",      (& $get "peak_refresh_rate" "system")
    $output += "{0,-25} {1}" -f "Min Refresh Rate:",       (& $get "min_refresh_rate" "system")
    $output += "{0,-25} {1}" -f "WiFi Policy:",            (& $get "wifi_sleep_policy" "global")
    $output += "{0,-25} {1}" -f "Avoid Bad WiFi:",         (& $get "avoid_bad_wifi" "global")
    $output += "{0,-25} {1}" -f "Auto Sync:",              (& $get "auto_sync" "global")
    $output += "{0,-25} {1}" -f "Location Mode:",          (& $get "location_mode" "secure")

    $msg = $output -join "`n"
    [System.Windows.Forms.MessageBox]::Show($msg, "Current Booster Settings", [System.Windows.Forms.MessageBoxButtons]::OK)
}

function Launch-MLBB {
    Run-ADB "shell am force-stop com.mobile.legends"
    Run-ADB "shell am start -n com.mobile.legends/.MainActivity"
    [System.Windows.MessageBox]::Show("🎮 Mobile Legends Launched!", "Vivo Booster")
}

function Choose-Action {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select Booster Mode"
    $form.Size = New-Object System.Drawing.Size(250, 200)
    $form.StartPosition = "CenterScreen"

    $gamingButton = New-Object System.Windows.Forms.Button
    $gamingButton.Text = "Gaming"
    $gamingButton.Dock = "Top"
    $gamingButton.Add_Click({
        Enable-GamingMode
        $form.Close()
    })

    $revertButton = New-Object System.Windows.Forms.Button
    $revertButton.Text = "Revert"
    $revertButton.Dock = "Top"
    $revertButton.Add_Click({
        Revert-ToNormal
        $form.Close()
    })

    $batteryButton = New-Object System.Windows.Forms.Button
    $batteryButton.Text = "Battery"
    $batteryButton.Dock = "Top"
    $batteryButton.Add_Click({
        Enable-BatteryHoney
        $form.Close()
    })

    $statusButton = New-Object System.Windows.Forms.Button
    $statusButton.Text = "Show Info"
    $statusButton.Dock = "Top"
    $statusButton.Add_Click({
        Check-Status
    })

    $form.Controls.AddRange(@($statusButton, $batteryButton, $revertButton, $gamingButton))
    $form.ShowDialog()
}

do {
    $choice = [System.Windows.Forms.MessageBox]::Show("Open Game Booster Menu?", "Vivo Game Booster", [System.Windows.Forms.MessageBoxButtons]::YesNo)
    if ($choice -eq [System.Windows.Forms.DialogResult]::Yes) {
        Choose-Action
    }
} while ($choice -eq [System.Windows.Forms.DialogResult]::Yes)
