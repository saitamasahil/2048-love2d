function love.conf(t)
    t.identity = "2048plus"
    t.version = "11.5"
    t.console = false

    t.window.title = "2048 Plus"
    t.window.icon = nil
    t.window.width = 640
    t.window.height = 480
    t.window.borderless = false
    t.window.resizable = true
    t.window.fullscreen = true
    t.window.fullscreentype = "desktop"
    t.window.vsync = 1
    t.window.display = 1
    t.window.highdpi = true
    t.window.x = nil
    t.window.y = nil

    t.modules.thread = false
    t.modules.audio = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = true
    t.modules.touch = true
    t.modules.video = false
end
