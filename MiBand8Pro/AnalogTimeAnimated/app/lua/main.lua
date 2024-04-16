local lvgl = require("lvgl")
local dataman = require("dataman")

-- load our submodules
require "image"
require "root"

local function getItemsPosition()
	local imgPosition = {
        background = { 0, 72 },
        timeHour =	 { 168, 240 },
        timeMinute = { 168, 240 },
        timeSecond = { 168, 240 },
		timeSecondCircle = { 168, 240 }
    }
    return imgPosition
end

local animIndex = 1
local animPath = {
	"linear", "ease_in", "ease_out", "ease_in_out", "overshoot", "bounce", "step"
}

-- prepare main watchface fuction
local function entry()
    local root = createRoot()
	
	local watchface = {}
	
    -- setup watchface elements positions
	local pos = getItemsPosition()
	
    -- create watchface elements
    --watchface.background = Image(root, "img_0001.bin", pos.background)
    --watchface.timeHour =   HandImage(root, "arrHour.bin", pos.timeHour)
    --watchface.timeMinute = HandImage(root, "arrMinute.bin", pos.timeMinute)
    --watchface.timeSecond = HandImageAnim(root, "arrSecond.bin", pos.timeSecond)
	watchface.timeSecondCircle = HandImageAnim(root, "segundos.bin", pos.timeSecondCircle)

    -- create label to display current animation mode
	local labelMode = lvgl.Label(root, {
		x = 20, y = 20,
		h = 60,
		text_font = lvgl.BUILTIN_FONT.MONTSERRAT_40,
		text = "1",
		bg_color = 0,
		border_width = 0,
		text_color = '#eeeeee'
	})

	local infoSeconds = lvgl.Label(root, {
		x = 150, y = 20,
		h = 60,
		text_font = lvgl.BUILTIN_FONT.MONTSERRAT_40,
		text = "1",
		bg_color = '#ee00ee',
		border_width = 0,
		text_color = '#eeeeee'
	})

	local infoSecondsInvert = lvgl.Label(root, {
		x = 200, y = 20,
		h = 60,
		text_font = lvgl.BUILTIN_FONT.MONTSERRAT_40,
		text = "1",
		bg_color = '#ee00ee',
		border_width = 0,
		text_color = '#eeeeee'
	})


	local hourLabel = lvgl.Label(root, {
		x = 168-80, y = 240,
		h = 60,
		text_font = lvgl.BUILTIN_FONT.MONTSERRAT_40,
		text = "1",
		bg_color = 0,
		border_width = 0,
		text_color = '#eeeeee'
	})

	local minuteLabel = lvgl.Label(root, {
		x = 168-40, y = 240,
		h = 60,
		text_font = lvgl.BUILTIN_FONT.MONTSERRAT_40,
		text = "1",
		bg_color = 0,
		border_width = 0,
		text_color = '#eeeeee'
	})


	
    dataman.subscribe("timeHour", hourLabel, function(obj, value)
		local hora = value // 0x100
		--local hourPos = 7200 // 24 * hour
		obj:set { text = hora }
    end)

    dataman.subscribe("timeMinute", minuteLabel, function(obj, value)
		local minuto = value // 0x100
		--local minPos = 3600 // 60 * min
        obj:set { text = minuto }
    end)


    dataman.subscribe("timeSecond", watchface.timeSecondCircle.widget, function(obj, value)
		--256
		local segundos = value // 0x100
		local segundosInvertidos = (segundos == 0) and 0 or 60 - segundos
		local secPos = 900 + (60 * segundosInvertidos)
		local secEnd = secPos - 60

		infoSeconds:set {text = segundosInvertidos}
		infoSecondsInvert:set {text = segundos}

		watchface.timeSecondCircle.rotateAnim:set {
			start_value = secPos,
			end_value = secEnd,
            path = animPath[animIndex],
			run = true,
		}
		
    end)
    -- attach on pressed event
    -- changing on animation mode
    --watchface.background.widget:add_flag(lvgl.FLAG.CLICKABLE)
    --watchface.background.widget:onevent(lvgl.EVENT.PRESSED, function(obj, code)
	--	animIndex = animIndex + 1	
	--	if animIndex == #animPath then
	--		animIndex = 1
	--	end	
	--	labelMode:set { text = animIndex }
	--end)
end

entry()