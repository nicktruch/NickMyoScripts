scriptId = 'com.thalmic.examples.myfirstscript'

locked = true
appTitle = ""

-- affichage du bras actif
	myo.debug("arm :"..myo.getArm())


--function onForegroundWindowChange(app, title)
--	myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
--	appTitle = title
--  return true
--end

function onForegroundWindowChange(app, title)
    -- Here we decide if we want to control the new active app.
    local wantActive = false
    activeApp = ""

    if platform == "MacOS" then
        if app == "com.apple.Safari" then
            -- Keynote on MacOS
            wantActive = true
            activeApp = "Keynote"
        elseif app == "com.microsoft.Powerpoint" then
            -- Powerpoint on MacOS
            wantActive = true
            activeApp = "Powerpoint"
        end
    elseif platform == "Windows" then
        -- Powerpoint on Windows
        wantActive = string.match(title, " %- PowerPoint$") or
                     string.match(title, "^PowerPoint Slide Show %- ") or
                     string.match(title, " %- PowerPoint Presenter View$")
        activeApp = "Powerpoint"
    end
    return wantActive
end

function onActiveChange(isActive)
    if not isActive then
        unlocked = false
    end
end	

function activeAppName()
	return appTitle
end

function onPoseEdge(pose, edge)
	myo.debug("onPoseEdge: " .. pose .. ": " .. edge)
	
	pose = conditionallySwapWave(pose)
	
	if (edge == "on") then
		if (pose == "thumbToPinky") then
			toggleLock()
		elseif (not locked) then
			if (pose == "waveOut") then
				onWaveOut()		
			elseif (pose == "waveIn") then
				onWaveIn()
			elseif (pose == "fist") then
				onFist()
			elseif (pose == "fingersSpread") then
				onFingersSpread()			
			end
		end
	end
end

function toggleLock()
	locked = not locked
	myo.vibrate("short")
	if (not locked) then
		-- Vibrate twice on unlock
		myo.debug("Unlocked")
		myo.vibrate("short")
	else 
		myo.debug("Locked")
	end
end

function onWaveOut()
	myo.debug("up")
	--myo.vibrate("short")
	myo.keyboard("pageup", "press")
end

function onWaveIn()
	myo.debug("down")
	--myo.vibrate("short")
	--myo.vibrate("short")
	myo.keyboard("pagedown","press")
end


function onFist()
	myo.debug("backspace")	
	--myo.vibrate("medium")
	myo.keyboard("backspace","press")
end

function onFingersSpread()
	myo.debug("tab")
	--myo.vibrate("long")
	myo.keyboard("tab", "press")
end

function conditionallySwapWave(pose)
	if myo.getArm() == "right" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end