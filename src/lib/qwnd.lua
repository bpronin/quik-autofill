local w32 = require("w32")

local CB_SETCURSEL = 334

local activeWindow

--local function printHandle(title, hWnd)
--    message((title or "Handle") .. string.format(": 0x%08x", hWnd))
--end

local function findWindow(wndType)
    local hWnd = w32.FindWindow(wndType.wndClass, wndType.wndText)
    if hWnd ~= 0 then
        return {
            type = wndType,
            handle = hWnd
        }
    else
        return nil
    end
end

local function findChildAt(hParent, hOffsetChild, offsetChildClass, offsetChildText, depth)
    local hWnd = w32.FindWindowEx(hParent, hOffsetChild, offsetChildClass, offsetChildText)
    if depth == 0 then
        return hWnd
    else
        return findChildAt(hParent, hWnd, "", "", depth - 1)
    end
end

function printWindow(prefix, window)
    message(prefix .. string.format("Handle: 0x%08X", window.handle) .. " Text:" .. window.type.wndText)
end

function processWindow(type, onOpen, onClose)
    local window = findWindow(type)
    if window then
        if not activeWindow then
            activeWindow = window
            onOpen(activeWindow)
        end
    else
        if activeWindow then
            if onClose then
                onClose(activeWindow)
            end
            activeWindow = nil
        end
    end
end

orderDialog = {
    wndClass = "#32770",
    wndText = "Ввод Заявки"
}

function orderDialog.setClient(window, client)
    local hWnd = findChildAt(window.handle, 0, "Button", "Рыночная", 1)
    w32.PostMessage(hWnd, CB_SETCURSEL, client, 0)
end

stopOrderDialog = {
    wndClass = "#32770",
    wndText = "Новая стоп-заявка"
}

function stopOrderDialog.setOrderType(window, orderType)
    local hWnd = findChildAt(window.handle, 0, "ComboBox", "", 0)
    w32.PostMessage(hWnd, CB_SETCURSEL, orderType, 0)
end

function stopOrderDialog.setDuration(window, duration)
    local hWnd = findChildAt(window.handle, 0, "Button", duration, 0)
    w32.PostMessage(hWnd, w32.BM_CLICK, 0, 0)
end

function stopOrderDialog.setClient(window, client)
    local hWnd = findChildAt(window.handle, 0, "Button", "По рыночной цене", 4)
    w32.PostMessage(hWnd, CB_SETCURSEL, client, 0)
end
