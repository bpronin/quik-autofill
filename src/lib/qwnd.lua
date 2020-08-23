local w32 = require("w32")

local CB_SETCURSEL = 334

local function printHandle(title, hWnd)
    message((title or "Handle") .. string.format(": 0x%08x", hWnd))
end

local function findChildAfter(hParent, hChild, childClass, childText, depth)
    local hWnd = w32.FindWindowEx(hParent, hChild, childClass, childText)
    --printHandle("Depth "..depth, hWnd)
    if depth == 0 then
        return hWnd
    else
        return findChildAfter(hParent, hWnd, "", "", depth - 1)
    end
end

function findWindow(types)
    for _, t in pairs(types) do
        local hWnd = w32.FindWindow(t.class, t.title)
        if hWnd ~= 0 then
            return {
                type = t,
                handle = hWnd
            }
        end
    end
    return nil
end

stopOrderDialog = {
    class = "",
    title = "Новая стоп-заявка"
}

function stopOrderDialog.setOrderType(window, orderType)
    local hWnd = findChildAfter(window.handle, 0, "ComboBox", "", 0)
    w32.PostMessage(hWnd, CB_SETCURSEL, orderType, 0)
end

function stopOrderDialog.setDuration(window, duration)
    local hWnd = findChildAfter(window.handle, 0, "Button", duration, 0)
    w32.PostMessage(hWnd, w32.BM_CLICK, 0, 0)
end

function stopOrderDialog.setClient(window, client)
    local hWnd = findChildAfter(window.handle, 0, "Button", "По рыночной цене", 4)
    w32.PostMessage(hWnd, CB_SETCURSEL, client, 0)
end
