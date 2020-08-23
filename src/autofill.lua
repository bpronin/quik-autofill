local SCRIPT_PATH = getScriptPath()

package.path = package.path
        .. ";" .. SCRIPT_PATH .. "/lib/?.lua"
        .. ";" .. SCRIPT_PATH .. "/lib/?.luac"

require("qwnd")

local function onStopOrderDialogOpen(window)
    stopOrderDialog.setOrderType(window, 4)
    stopOrderDialog.setDuration(window, "המ מעלוםû")
    stopOrderDialog.setClient(window, 0)
end

local timeout = 1000
local running = true
local window_open = false

function OnStop()
    running = false
end

function main()
    while running do
        sleep(timeout)

        local window = findWindow({stopOrderDialog})
        if window then
            if not window_open then
                window_open = true
                if window.type == stopOrderDialog then
                    onStopOrderDialogOpen(window)
                end
            end
        else
            window_open = false
        end
    end
end
