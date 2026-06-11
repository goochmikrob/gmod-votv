--@name Trasnformer Fixing System GM-VoTV
--@author Gooch
--@include gmod-votv/gm-votv/code/ui_lib/wingui.txt
--@shared
--@superuser

if SERVER then
    
end

if CLIENT then
    
    local WinGUI = require( "gmod-votv/gm-votv/code/ui_lib/wingui.txt" )    
    WinGUI:EnableScreenMode()
    
    -- Since WinGUI already knows the desktop resolution,
    -- you dont have to get the game resolution before
    -- creating panels (like on the HUD example).
    
    local finishing = false
    
    local T_ = 
    {   
        id = "1",
        fixed = false,
        bytesCorrect = false,
        fourbyteCorrect = false,
        codeCorrect = false,
        
    }
    
    local nums_origin = 
    {
        num1 = {correct=true, num=0},
        num2 = {correct=true, num=0},
        num3 = {correct=true, num=0},
        num4 = {correct=true, num=0}
    }
    
    local nums_guess = 
    { 
        num1 = {correct=false, num=0},
        num2 = {correct=false, num=0},
        num3 = {correct=false, num=0},
        num4 = {correct=false, num=0}
    }
    
    local function initOrigins()
        
        for k, v in pairs(nums_origin) do
            
            v.num = math.random(1,9)
            
        end
        
    end
    
    local FAKE_DLLS =
    {
    "C:/Windows/System32/ntdll.dll",
    "C:/Windows/System32/kernel32.dll",
    "C:/Windows/System32/kernelbase.dll",
    "C:/Windows/System32/advapi32.dll",
    "C:/Windows/System32/user32.dll",
    "C:/Windows/System32/gdi32.dll",
    "C:/Windows/System32/win32u.dll",
    "C:/Windows/System32/msvcrt.dll",
    "C:/Windows/System32/sechost.dll",
    "C:/Windows/System32/rpcrt4.dll",
    "C:/Windows/System32/ole32.dll",
    "C:/Windows/System32/combase.dll",
    "C:/Windows/System32/ucrtbase.dll",
    "C:/Windows/System32/shlwapi.dll",
    "C:/Windows/System32/setupapi.dll",
    "C:/Windows/System32/ws2_32.dll",
    "C:/Windows/System32/crypt32.dll",
    "C:/Windows/System32/wininet.dll",
    "C:/Windows/System32/urlmon.dll",
    "C:/Windows/System32/shell32.dll",
    "C:/Windows/System32/msi.dll",
    "C:/Windows/System32/wldap32.dll",
    "C:/Windows/System32/dhcpcsvc.dll",
    "C:/Windows/System32/dnsapi.dll",
    "C:/Windows/System32/iphlpapi.dll",
    "C:/Windows/System32/winhttp.dll",
    "C:/Windows/System32/wintrust.dll",
    "C:/Windows/System32/imagehlp.dll",
    "C:/Windows/System32/rsaenh.dll",
    "C:/Windows/System32/bcrypt.dll",
    "C:/Windows/System32/dbghelp.dll",
    "C:/Windows/System32/netapi32.dll",
    "C:/Windows/System32/psapi.dll",
    "C:/Windows/System32/winmm.dll",
    "C:/Windows/System32/opengl32.dll",
    "C:/Windows/System32/ddraw.dll",
    "C:/Windows/System32/dsound.dll",
    "C:/Windows/System32/dxgi.dll",
    "C:/Windows/System32/d3d11.dll",
    "C:/Windows/System32/xinput1_3.dll",
    "C:/Windows/System32/xaudio2_7.dll",
    "C:/Windows/System32/mfplat.dll",
    "C:/Windows/System32/mfreadwrite.dll",
    "C:/Windows/System32/wmcodecdsp.dll",
    "C:/Windows/System32/msdmo.dll",
    "C:/Windows/System32/vcomp140.dll",
    "C:/Windows/System32/vcruntime140.dll",
    "C:/Windows/System32/msvcp140.dll",
    "C:/Windows/System32/concrt140.dll",
    
    -- SysWOW64
    "C:/Windows/SysWOW64/ntdll.dll",
    "C:/Windows/SysWOW64/kernel32.dll",
    "C:/Windows/SysWOW64/user32.dll",
    "C:/Windows/SysWOW64/gdi32.dll",
    "C:/Windows/SysWOW64/oleaut32.dll",
    
    -- Program Files
    "C:/Program Files/NVIDIA Corporation/NVAPI/nvapi64.dll",
    "C:/Program Files/NVIDIA Corporation/PhysX/PhysX3_x64.dll",
    "C:/Program Files/Steam/steamapps/common/GarrysMod/bin/tier0.dll",
    "C:/Program Files/Steam/steamapps/common/GarrysMod/bin/vstdlib.dll",
    "C:/Program Files/Steam/steamapps/common/GarrysMod/bin/filesystem_stdio.dll",
    "C:/Program Files/Steam/steamapps/common/GarrysMod/bin/inputsystem.dll",
    "C:/Program Files/Steam/steamclient64.dll",
    "C:/Program Files/Steam/tier0_s64.dll",
    "C:/Program Files/Steam/vstdlib_s64.dll",
    
    -- Driver related
    "C:/Windows/System32/drivers/dxgkrnl.sys",
    "C:/Windows/System32/drivers/cldflt.sys",
    "C:/Windows/System32/drivers/wd/WdBoot.sys",
    "C:/Windows/System32/drivers/ntfs.sys",
    
    -- Office / Common
    "C:/Program Files/Microsoft Office/root/Office16/MSO.dll",
    "C:/Program Files/Microsoft Office/root/Office16/RICHEDIT20.DLL",
    "C:/Program Files (x86)/Common Files/Adobe/Adobe Desktop Common/ADS/Adobe Desktop Service.dll",
    "C:/Program Files/Discord/app-1.0.9166/modules/discord_voice/discord_voice.node.dll",
    
    -- Random/Corrupted/Missing (for flavor)
    "C:/Windows/Temp/$sys$/drv_amd64_temp.dll",
    "D:/Backup/old_system/winsxs/amd64_microsoft-windows-com-base-qfe-ole32_31bf3856ad364e35_10.0.19041.1_none_abc123.dll",
    "C:/Windows/Installer/$PatchCache$/Managed/DC3BF90CCE4674B83F8A8177A92D32D1/mscorlib.dll",
    "E:/System Volume Information/{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}/recovery.dll",
    
    -- Transformer-specific (flavor text)
    "C:/Transmod/firmware/pcu_controller.dll",
    "C:/Transmod/drivers/power_relay_driver.sys",
    "C:/Transmod/diagnostics/spectrum_analyzer.dll",
    "D:/VARTA/Backup/2024/Q3/transformer_calib.dat.dll",
    "C:/Users/Operator/AppData/Local/Temp/tfm_repair_3782.tmp/repair_runtime.dll",
    
    -- Vulkan / GPU
    "C:/Windows/System32/vulkan-1.dll",
    "C:/Windows/System32/vulkaninfo.dll",
    "C:/Windows/System32/amdvlk64.dll",
    "C:/Windows/System32/nvoglv64.dll",
    
    -- Audio / MIDI
    "C:/Windows/System32/audioses.dll",
    "C:/Windows/System32/midimap.dll",
    "C:/Windows/System32/wdmaud.drv"
    }
    
    local inited = 0
    
    initOrigins()
    -- create a test window
    local window = WinGUI:Create( "Window" )
    window.w = 700                  -- make it a wider
    window.h = 280                  -- make it a taller
    window:SetTitle( "TRANSFORMER REPAIRING MANAGEMENT: "..(T_.fixed == false and "DOWN" or "WORKING") )  -- set the text shown in the title bar
    window:Center()                 -- put the window in the middle of the screen
    window:MakePopup()              -- focus on this window

    local function CreateText(txt, pnl)
        
        local label = WinGUI:Create( "Label", pnl )
        label.text = txt
        label:Dock( WinGUI.DOCK.TOP)
        
        return label
        
    end
    
    local function CompareBytes()
        
        local t1 = nums_origin
        local t2 = nums_guess
    
        local eq = ( ( t1.num1.num == t2.num1.num and t1.num2.num == t2.num2.num and t1.num3.num == t2.num3.num and t1.num4.num == t2.num4.num )==true and 1 or 0 )
        
        return eq
        
    end
    

    -- listen to click events
    
    local sheet = WinGUI:Create( "PropertySheet", window )
    sheet:Dock( WinGUI.DOCK.TOP )
    sheet.h = 200
    sheet.OnSwitchTab = function( index, panel )
        player():emitSound("buttons/button15.wav",100,100)
    end
    
    -- Create our first tab
    local firstPanel = sheet:AddTab( "Byte Match" )
    
    -- then add a bytematch_label to it's panel
    local bytematch_label = WinGUI:Create( "Label", firstPanel )
    bytematch_label.text = "Byte Match:::    Rotate the numbers until they equal within 15 seconds"
    bytematch_label:Dock( WinGUI.DOCK.TOP )
    
    CreateText( " ", firstPanel )
    CreateText( "ORIGIN BYTES", firstPanel )
    local bytes_originn = WinGUI:Create( "Label", firstPanel )
    bytes_originn.text = ( nums_origin.num1.num.."B,  "..nums_origin.num2.num.."B,  "..nums_origin.num3.num.."B,  "..nums_origin.num4.num.."B " )
    bytes_originn:Dock( WinGUI.DOCK.TOP )
    CreateText( " ", firstPanel )
    CreateText( "INPUT BYTES", firstPanel )
    local bytes_guessedd = CreateText( nums_guess.num1.num.."B,  "..nums_guess.num2.num.."B,  "..nums_guess.num3.num.."B,  "..nums_guess.num4.num.."B ", firstPanel )
    CreateText( " ", firstPanel )
    local Timeleft = CreateText( "ByteQuota:", firstPanel )
    
    local btn_Mchange1 = WinGUI:Create("Button", firstPanel)
    btn_Mchange1.text = "Value (+)"
    btn_Mchange1.x = 240
    btn_Mchange1.y = 45
    btn_Mchange1.w = 80
    btn_Mchange1.OnClick = function()
        
        player():emitSound("buttons/button15.wav",100,105)
        nums_guess.num1.num = math.clamp(nums_guess.num1.num + 1, 0, 9)
        
    end
    
    local xt1 = WinGUI:Create( "Label", firstPanel )
    xt1.text = nums_guess.num1.num
    xt1.x = 270
    xt1.y = 72
    xt1:SetContentAlignment( WinGUI.CONTENT_ALIGN.CENTER )
    local btn_Pchange1 = WinGUI:Create("Button", firstPanel)
    btn_Pchange1.text = "Value (-)"
    btn_Pchange1.x = 240
    btn_Pchange1.y = 95
    btn_Pchange1.w = 80
    btn_Pchange1.OnClick = function()
        
        player():emitSound("buttons/button15.wav",100,90)
        nums_guess.num1.num = math.clamp(nums_guess.num1.num - 1, 0, 9)
        
    end
    
    local btn_Mchange2 = WinGUI:Create("Button", firstPanel)
    btn_Mchange2.text = "Value (+)"
    btn_Mchange2.x = 320
    btn_Mchange2.y = 45
    btn_Mchange2.w = 80
    btn_Mchange2.OnClick = function()
        
        player():emitSound("buttons/button15.wav",100,105)
        nums_guess.num2.num = math.clamp(nums_guess.num2.num + 1, 0, 9)
        
    end
    local xt2 = WinGUI:Create( "Label", firstPanel )
    xt2.text = nums_guess.num2.num
    xt2.x = 350
    xt2.y = 72
    xt2:SetContentAlignment( WinGUI.CONTENT_ALIGN.CENTER )
    local btn_Pchange2 = WinGUI:Create("Button", firstPanel)
    btn_Pchange2.text = "Value (-)"
    btn_Pchange2.x = 320
    btn_Pchange2.y = 95
    btn_Pchange2.w = 80
    btn_Pchange2.OnClick = function()
        
        player():emitSound("buttons/button15.wav",100,90)
        nums_guess.num2.num = math.clamp(nums_guess.num2.num - 1, 0, 9)
        
    end    
    
    local btn_Mchange3 = WinGUI:Create("Button", firstPanel)
    btn_Mchange3.text = "Value (+)"
    btn_Mchange3.x = 400
    btn_Mchange3.y = 45
    btn_Mchange3.w = 80
    btn_Mchange3.OnClick = function()
        
        player():emitSound("buttons/button15.wav",100,105)
        nums_guess.num3.num = math.clamp(nums_guess.num3.num + 1, 0, 9)
        
    end    
    local xt3 = WinGUI:Create( "Label", firstPanel )
    xt3.text = nums_guess.num3.num
    xt3.x = 430
    xt3.y = 72
    xt3:SetContentAlignment( WinGUI.CONTENT_ALIGN.CENTER )
    local btn_Pchange3 = WinGUI:Create("Button", firstPanel)
    btn_Pchange3.text = "Value (-)"
    btn_Pchange3.x = 400
    btn_Pchange3.y = 95
    btn_Pchange3.w = 80
    btn_Pchange3.OnClick = function()
        
        player():emitSound("buttons/button15.wav",100,90)
        nums_guess.num3.num = math.clamp(nums_guess.num3.num - 1, 0, 9)
        
    end        
    
    local btn_Mchange4 = WinGUI:Create("Button", firstPanel)
    btn_Mchange4.text = "Value (+)"
    btn_Mchange4.x = 480
    btn_Mchange4.y = 45
    btn_Mchange4.w = 80
    btn_Mchange4.OnClick = function()
        
        player():emitSound("buttons/button15.wav",100,105)
        nums_guess.num4.num = math.clamp(nums_guess.num4.num + 1, 0, 9)
        
    end    
    local xt4 = WinGUI:Create( "Label", firstPanel )
    xt4.text = nums_guess.num4.num
    xt4.x = 510
    xt4.y = 72
    xt4:SetContentAlignment( WinGUI.CONTENT_ALIGN.CENTER )
    local btn_Pchange4 = WinGUI:Create("Button", firstPanel)
    btn_Pchange4.text = "Value (-)"
    btn_Pchange4.x = 480
    btn_Pchange4.y = 95
    btn_Pchange4.w = 80
    btn_Pchange4.OnClick = function()
        
        player():emitSound("buttons/button15.wav",100,90)
        nums_guess.num4.num = math.clamp(nums_guess.num4.num - 1, 0, 9)
        
    end        
    
    -- Create our second tab
    local secondPanel = sheet:AddTab( "4Byte Match" )

    local sinematch_label = WinGUI:Create( "Label", secondPanel )
    sinematch_label.text = "4Byte Match:::    Rotate the scrollers until they equal"
    sinematch_label:Dock( WinGUI.DOCK.TOP )
    
    local sliderBasic = WinGUI:Create( "HSlider", secondPanel )
    sliderBasic.value = math.random(-100,100)
    sliderBasic.minValue = -100
    sliderBasic.maxValue = 100
    sliderBasic:Dock( WinGUI.DOCK.TOP )
    
    local sliderBasic2 = WinGUI:Create( "HSlider", secondPanel )
    sliderBasic2.value = math.random(-100,100)
    sliderBasic2.minValue = -100
    sliderBasic2.maxValue = 100
    sliderBasic2:Dock( WinGUI.DOCK.TOP )
        
    local sliderBasic3 = WinGUI:Create( "HSlider", secondPanel )
    sliderBasic3.value = math.random(-100,100)
    sliderBasic3.minValue = -100
    sliderBasic3.maxValue = 100
    sliderBasic3:Dock( WinGUI.DOCK.TOP )
        
    local sinematch_lbl2 = CreateText("", secondPanel)
    
    local progressBar = WinGUI:Create( "ProgressBar", secondPanel )
    progressBar:Dock( WinGUI.DOCK.TOP )
    
    -- Create our third tab
    local thirdPanel = sheet:AddTab( "2-Bit Match" )
    
    -- then add a button that closes it
    local panel3rdTEXT = CreateText("Convert a number into 2-binary system.", thirdPanel) 
    panel3rdTEXT:Dock( WinGUI.DOCK.TOP )    
    
    local targetNumber = math.random(1,20)
    local bitNumber = math.intToBin( math.random(1,20) )
    local targetBitNumber = math.intToBin( targetNumber )
    
    local panel3rdINFO = CreateText("Press a button if numbers are equal.", thirdPanel) 
    local panel3rdBITNUM = CreateText( "", thirdPanel )
    
    timer.create("GenerateNumber",0.35,0,function() bitNumber=math.intToBin( math.random(1,15) ) panel3rdBITNUM.text = bitNumber.."BTA : : : "..targetBitNumber.."BTA"  end)
    
    CreateText(" ",thirdPanel)
    CreateText(" ",thirdPanel)
    
    local panel3rdBTN = WinGUI:Create("Button", thirdPanel)
    panel3rdBTN:Dock( WinGUI.DOCK.TOP )
    panel3rdBTN.text = "[ EQUALIZE & COMPARE ]"
    
    panel3rdBTN.OnClick = function()
       
        if bitNumber == targetBitNumber then
            
            panel3rdTEXT.text = " "
            panel3rdINFO.text = "Proceed to next tasks or press REFRESH button."
            panel3rdBTN:SetVisible(false)
            T_.codeCorrect = true
            timer.remove("GenerateNumber")
            
        end
        
    end
    
    
    local _equality = 0
    local frozen = 1
    
    local compare_btn = WinGUI:Create("Button", sheet)
    compare_btn.text = "[ COMPILE 0/3 ]"
    compare_btn.w = 150
    compare_btn.h = 25
    compare_btn.y = 175
    compare_btn.OnClick = function()
        
        if sheet._currentTab == 1 then
        
            if (CompareBytes() == 1) and T_.bytesCorrect == false then
                
                Timeleft:SetVisible(false)
                T_.bytesCorrect = true
                timer.remove("IN_OR")
                player():emitSound("buttons/button5.wav",100,110)
                
            elseif (CompareBytes() == 0) or T_.bytesCorrect == true then
                        
                player():emitSound("buttons/button10.wav",100,95)
                
            end
            
        end
        
        if sheet._currentTab == 2 then
            
            if _equality >= 98 and T_.fourbyteCorrect == false then
                
                T_.fourbyteCorrect = true
                sliderBasic:SetVisible(false)
                sliderBasic2:SetVisible(false)
                sliderBasic3:SetVisible(false)
                
                player():emitSound("buttons/button5.wav",100,110)
                
            elseif _equality < 98 or T_.fourbyteCorrect == true then
                
                player():emitSound("buttons/button10.wav",100,95)
                
            end
            
        end
            
    end
    
    timer.create("IN_OR",15,0,function() initOrigins() if player():getPos():getDistance( chip():getPos() ) < 500 and sheet._currentTab == 1 then player():emitSound("buttons/button18.wav",100,85) end end)
        
    local function checkSlidersEquality(s1, s2, s3)
        local range = 100  //  max  
        local maxDiff = math.max(
            math.abs(s1 - s2),
            math.abs(s1 - s3),
            math.abs(s2 - s3)
        )
        
        local percent = 100 - (maxDiff / range * 100)
        percent = math.max(0, math.min(100, percent))
        
        return percent
    end
        
        -- add a test button to the window
    local button = WinGUI:Create( "Button", window )
    button.text = "REFRESH"
    button.OnClick = function()
        
        if ((T_.bytesCorrect==true and 1 or 0 )+(T_.fourbyteCorrect==true and 1 or 0)+(T_.codeCorrect==true and 1 or 0)) == 3 then
            
            button:SetVisible(false)
            sheet:SetVisible(false)
            finishing = true
            window:SetTitle( "TRANSFORMER REPAIRING MANAGEMENT: Software Initializing")
            
            lbl = WinGUI:Create( "Label", window )
            lbl.text = "Initializing ASO-TF64 Protocol for this computer. You can leave the terminal now."
            lbl:Dock(WinGUI.DOCK.TOP)
        
            lbl_dll = WinGUI:Create( "Label", window )
            lbl_dll.text = "ETF64 INIT............"
            lbl_dll:Dock(WinGUI.DOCK.TOP)
            
            
            prgbar = WinGUI:Create( "ProgressBar", window )
            prgbar.value = 0
            prgbar:Dock(WinGUI.DOCK.TOP)
            
            sheet.h = 1
            
        end
            
    end
    
    -- make the button fill the window's width
    -- and pinned to the top
    button:SetDimensions( 550, 1000, 150, 20 )
    
    timer.create("CYCLE_finishing",0.01,0,function()

        if finishing == true then
            
            prgbar.value = prgbar.value + (0.00015*frozen)
            
            
            if inited <= #FAKE_DLLS then inited = inited + 1*frozen else inited = 0 end 
                
            if frozen == 1 then
                
            lbl_dll.text = FAKE_DLLS[inited]
            
            end
            
            local random_bump = math.random(1,1000)
            if random_bump == 500 then 
                
                if frozen == 1 then
                    
                    lbl_dll.text = FAKE_DLLS[inited]
                    frozen = 0
                     
                    timer.simple(5, function()
                    frozen = 1 prgbar.value = prgbar.value + 0.1
                    end) 
                    
                end 
                
            end
            
            if random_bump == 800 then
                
                if frozen == 1 then
                    
                    lbl_dll.text = FAKE_DLLS[inited]
                    frozen = 0
                    
                    lbl_dll.text = "Detected a corrupted file. RETRYING... "..FAKE_DLLS[inited]
                    prgbar.value = prgbar.value - 0.02
                    timer.simple(10,function() frozen = 1 end)
                    
                end
                
            end
            
            if prgbar.value >= 1 then 
                
                finishing = false 
                lbl.text = "ETF64 Protocol initialized. Waiting for system response."
                OK_BTN = WinGUI:Create("Button",window)
                OK_BTN.text = "OK"
                
                OK_BTN.x = 525
                OK_BTN.y = 250
                OK_BTN.w = 150
                OK_BTN.h = 20
                OK_BTN.textColor = Color(255,255,255)
                OK_BTN.backgroundColor = Color(50,50,50)
                lbl_dll.text = ""
                
            end
            
            
        end

    end)
        
    hook.add( "render", "", function()
        
        if T_.bytesCorrect == false then
            
            Timeleft.text = "ByteQuota: "..math.round(timer.timeleft("IN_OR"),2)
            
            bytes_originn.text = nums_origin.num1.num.."B, "..nums_origin.num2.num.."B, "..nums_origin.num3.num.."B, "..nums_origin.num4.num.."B "
            bytes_guessedd.text = nums_guess.num1.num.."B,  "..nums_guess.num2.num.."B,  "..nums_guess.num3.num.."B,  "..nums_guess.num4.num.."B "
            
            xt1.text = nums_guess.num1.num    
            xt2.text = nums_guess.num2.num    
            xt3.text = nums_guess.num3.num    
            xt4.text = nums_guess.num4.num    
                
        end
        
        if T_.fourbyteCorrect == false then
            
            _equality = checkSlidersEquality(sliderBasic.value, sliderBasic2.value, sliderBasic3.value)
            
            sinematch_lbl2.text = "Equality: "..math.round(_equality,2)
            progressBar.value = _equality / 100
            
        end
         
        WinGUI:Render()
        compare_btn:SetVisible( !T_.fixed )
        compare_btn.text = "[ COMPILE "..((T_.bytesCorrect==true and 1 or 0 )+(T_.fourbyteCorrect==true and 1 or 0)+(T_.codeCorrect==true and 1 or 0)).."/3 ]"
        render.setBackgroundColor(Color(0,0,0,0))
        
--[[    local T_ = 
    {   
        id = "1",
        fixed = false,
        bytesCorrect = false,
        fourbyteCorrect = false,
        codeCorrect = false,
        
    }
    --]]
        
    end)
    
end