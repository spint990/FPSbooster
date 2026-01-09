--[[
    FPS Booster Ultimate - NoRender Edition
    Désactive complètement le rendu 3D pour des performances maximales
    
    HOTKEY: F4 pour toggle le rendu 3D
]]

if _G.FPSBooster_Loaded then
    warn("FPS Booster déjà chargé!")
    return
end
_G.FPSBooster_Loaded = true

-- Configuration
local CONFIG = {
    NoRender = true,           -- Désactive tout le rendu 3D au démarrage
    UnlockFPS = true,          -- Débloquer le cap FPS
    FPSLimit = 1e6,            -- Limite FPS (1e6 = illimité)
    ClearNilInstances = true,  -- Nettoyer la mémoire
    LowRendering = true,       -- Qualité de rendu minimum
    ToggleKey = Enum.KeyCode.F4, -- Touche pour toggle NoRender
}

-- Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- État du rendu
local renderEnabled = not CONFIG.NoRender

-- Attendre le chargement
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- ═══════════════════════════════════════════════════════════
-- TOGGLE RENDER FUNCTION
-- ═══════════════════════════════════════════════════════════
local function ToggleRender()
    renderEnabled = not renderEnabled
    pcall(function()
        RunService:Set3dRenderingEnabled(renderEnabled)
    end)
    warn("[FPS Booster] Rendu 3D: " .. (renderEnabled and "ON" or "OFF"))
end

-- ═══════════════════════════════════════════════════════════
-- HOTKEY - F4 pour toggle
-- ═══════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == CONFIG.ToggleKey then
        ToggleRender()
    end
end)

-- ═══════════════════════════════════════════════════════════
-- NORENDER - Désactive le rendu 3D au démarrage
-- ═══════════════════════════════════════════════════════════
if CONFIG.NoRender then
    pcall(function()
        RunService:Set3dRenderingEnabled(false)
        warn("[FPS Booster] NoRender activé")
    end)
end

-- ═══════════════════════════════════════════════════════════
-- FPS UNCAP
-- ═══════════════════════════════════════════════════════════
if CONFIG.UnlockFPS then
    pcall(function()
        if setfpscap then
            setfpscap(CONFIG.FPSLimit)
            warn("[FPS Booster] FPS débloqués")
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- LOW RENDERING
-- ═══════════════════════════════════════════════════════════
if CONFIG.LowRendering then
    pcall(function()
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    end)
end

-- ═══════════════════════════════════════════════════════════
-- CLEAR NIL INSTANCES
-- ═══════════════════════════════════════════════════════════
if CONFIG.ClearNilInstances then
    pcall(function()
        if getnilinstances then
            for _, v in pairs(getnilinstances()) do
                pcall(v.Destroy, v)
            end
        end
    end)
end

warn("═══════════════════════════════════════════")
warn("FPS Booster - Appuie sur F4 pour toggle")
warn("═══════════════════════════════════════════")
