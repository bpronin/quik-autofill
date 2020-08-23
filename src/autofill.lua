local SCRIPT_PATH = getScriptPath()

package.path = package.path
        .. ";" .. SCRIPT_PATH .. "/lib/?.lua"
        .. ";" .. SCRIPT_PATH .. "/lib/?.luac"

require("qwnd")

local TIMEOUT = 1000

local running = true

function OnStop()
    running = false
end

function main()
    while running do
        sleep(TIMEOUT)

        processWindow(stopOrderDialog, function(window)
            stopOrderDialog.setOrderType(window, 4)
            stopOrderDialog.setDuration(window, "המ מעלוםû")
            stopOrderDialog.setClient(window, 0)
        end)
    end
end
