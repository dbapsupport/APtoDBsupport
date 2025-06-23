local Workspace = game:GetService("Workspace")

-- Configurações do Highlight
local TARGET_HIGHLIGHT_NAME = "Highlight"
local TARGET_FILL_COLOR_RGB = { R = 255, G = 149, B = 0 }
local TARGET_OUTLINE_COLOR_RGB = { R = 255, G = 238, B = 0 }
local TARGET_FILL_TRANSPARENCY = 1
local TARGET_OUTLINE_TRANSPARENCY = 0
local TARGET_ENABLED = true
local TARGET_DEPTH_MODE = Enum.HighlightDepthMode.AlwaysOnTop
local COLOR_COMPONENT_TOLERANCE = 0.01

local highlightPartProcessed = {}

-- Função de rastreamento da sombra
local function runBallShadowTrackingLogic()
    local RunService_BS = game:GetService("RunService")
    local Workspace_BS = game:GetService("Workspace")

    local FX_FOLDER_NAME_BS = "FX"
    local TARGET_PART_NAME_BS = "BallShadow"
    local DECAL_NAME_INSIDE_BS = "Decal"
    local FOLLOWER_SPHERE_NAME_BS = "Ball"
    local SPHERE_PARENT = Workspace:WaitForChild("Lobby"):WaitForChild("ReadyArea"):WaitForChild("Model")
    local TARGET_PART_INITIAL_COLOR_BS = Color3.fromRGB(163, 162, 165)

    local MIN_TRANSPARENCY_BS = 0.3
    local MAX_TRANSPARENCY_BS = 1.0
    local MIN_HEIGHT_OFFSET_BS = 2.0
    local MAX_HEIGHT_OFFSET_BS = 280.0
    local LERP_FACTOR_BS = 1

    local isTracking_BS = false
    local trackedPartInstance_BS = nil
    local trackedDecalInstance_BS = nil
    local followerSphere_BS = nil
    local renderConnection_BS = nil
    local childAddedConnection_BS = nil
    local childRemovedConnection_BS = nil

    local function StopTracking_BS()
        if not isTracking_BS then return end

        if renderConnection_BS then
            renderConnection_BS:Disconnect()
            renderConnection_BS = nil
        end
        if childAddedConnection_BS then
            childAddedConnection_BS:Disconnect()
            childAddedConnection_BS = nil
        end
        if childRemovedConnection_BS then
            childRemovedConnection_BS:Disconnect()
            childRemovedConnection_BS = nil
        end

        local sphereToDestroy = followerSphere_BS or Workspace_BS:FindFirstChild(FOLLOWER_SPHERE_NAME_BS)
        if sphereToDestroy and sphereToDestroy.Parent then
            sphereToDestroy:Destroy()
        end

        followerSphere_BS = nil
        trackedPartInstance_BS = nil
        trackedDecalInstance_BS = nil
        isTracking_BS = false
    end

    local function StartTracking_BS(partToTrack, decalToTrack)
        if isTracking_BS or renderConnection_BS then return end
        if not partToTrack or not decalToTrack then return end

        isTracking_BS = true
        trackedPartInstance_BS = partToTrack
        trackedDecalInstance_BS = decalToTrack

        local oldFollower = SPHERE_PARENT:FindFirstChild(FOLLOWER_SPHERE_NAME_BS)
        if oldFollower then oldFollower:Destroy() end

        followerSphere_BS = Instance.new("Part")
        followerSphere_BS.Name = FOLLOWER_SPHERE_NAME_BS
        followerSphere_BS.Shape = Enum.PartType.Ball
        followerSphere_BS.Size = Vector3.new(4, 4, 4)
        followerSphere_BS.Color = Color3.fromRGB(255, 0, 0)
        followerSphere_BS.Material = Enum.Material.Neon
        followerSphere_BS.Anchored = true
        followerSphere_BS.CanCollide = false
        followerSphere_BS.Transparency = 0
        followerSphere_BS.Parent = SPHERE_PARENT

        local initialTransparency = trackedDecalInstance_BS.Transparency
        local initialNormTrans = math.clamp(
            (initialTransparency - MIN_TRANSPARENCY_BS) / (MAX_TRANSPARENCY_BS - MIN_TRANSPARENCY_BS),
            0, 1
        )
        local initialHeight = MIN_HEIGHT_OFFSET_BS + (MAX_HEIGHT_OFFSET_BS - MIN_HEIGHT_OFFSET_BS) * initialNormTrans
        local initialShadowPos = trackedPartInstance_BS.Position

        followerSphere_BS.Position = Vector3.new(
            initialShadowPos.X,
            initialShadowPos.Y + initialHeight,
            initialShadowPos.Z
        )

        renderConnection_BS = RunService_BS.RenderStepped:Connect(function(deltaTime)
            if not trackedPartInstance_BS or not trackedPartInstance_BS.Parent
                or not trackedDecalInstance_BS or not trackedDecalInstance_BS.Parent
                or trackedDecalInstance_BS.Parent ~= trackedPartInstance_BS
                or not followerSphere_BS or not followerSphere_BS.Parent then
                StopTracking_BS()
                return
            end

            local currentTransparency = trackedDecalInstance_BS.Transparency
            local normalizedTransparency = math.clamp(
                (currentTransparency - MIN_TRANSPARENCY_BS) / (MAX_TRANSPARENCY_BS - MIN_TRANSPARENCY_BS),
                0, 1
            )
            local calculatedHeightOffset = MIN_HEIGHT_OFFSET_BS + (MAX_HEIGHT_OFFSET_BS - MIN_HEIGHT_OFFSET_BS) * normalizedTransparency
            local shadowPosition = trackedPartInstance_BS.Position

            local sphereTargetPosition = Vector3.new(
                shadowPosition.X,
                shadowPosition.Y + calculatedHeightOffset,
                shadowPosition.Z
            )

            followerSphere_BS.Position = followerSphere_BS.Position:Lerp(sphereTargetPosition, LERP_FACTOR_BS)
        end)

        -- Desconectar se existiam anteriores
        if childAddedConnection_BS then
            childAddedConnection_BS:Disconnect()
            childAddedConnection_BS = nil
        end
        if childRemovedConnection_BS then
            childRemovedConnection_BS:Disconnect()
            childRemovedConnection_BS = nil
        end
    end

    local fxFolder_BS = Workspace_BS:WaitForChild(FX_FOLDER_NAME_BS, 30)
    if fxFolder_BS then
        childAddedConnection_BS = fxFolder_BS.ChildAdded:Connect(function(child)
            if isTracking_BS then return end
            if child.Name == TARGET_PART_NAME_BS and child:IsA("BasePart")
                and child.Color == TARGET_PART_INITIAL_COLOR_BS then
                task.wait(0.1)
                local decal = child:FindFirstChild(DECAL_NAME_INSIDE_BS)
                if decal and decal:IsA("Decal") then
                    StartTracking_BS(child, decal)
                end
            end
        end)

        childRemovedConnection_BS = fxFolder_BS.ChildRemoved:Connect(function(child)
            if child == trackedPartInstance_BS then
                StopTracking_BS()
            end
        end)

        if not isTracking_BS then
            local initialPart = fxFolder_BS:FindFirstChild(TARGET_PART_NAME_BS)
            if initialPart and initialPart:IsA("BasePart")
                and initialPart.Color == TARGET_PART_INITIAL_COLOR_BS then
                task.wait(0.1)
                local initialDecal = initialPart:FindFirstChild(DECAL_NAME_INSIDE_BS)
                if initialDecal and initialDecal:IsA("Decal") then
                    StartTracking_BS(initialPart, initialDecal)
                end
            end
        end

        -- Desconectar listeners após 10 segundos se não estiver rastreando
        task.delay(10, function()
            if not isTracking_BS then
                if childAddedConnection_BS then
                    childAddedConnection_BS:Disconnect()
                    childAddedConnection_BS = nil
                end
                if childRemovedConnection_BS then
                    childRemovedConnection_BS:Disconnect()
                    childRemovedConnection_BS = nil
                end
            end
        end)
    end
end

-- Verificação de similaridade de cores
local function areColorsSimilar(colorA_Color3, targetColor_RGBTable)
    if not colorA_Color3 or not targetColor_RGBTable then return false end

    local r = math.abs(colorA_Color3.R - (targetColor_RGBTable.R / 255)) < COLOR_COMPONENT_TOLERANCE
    local g = math.abs(colorA_Color3.G - (targetColor_RGBTable.G / 255)) < COLOR_COMPONENT_TOLERANCE
    local b = math.abs(colorA_Color3.B - (targetColor_RGBTable.B / 255)) < COLOR_COMPONENT_TOLERANCE

    return r and g and b
end

-- Processa uma parte se o highlight bater com os critérios
local function processPartIfMatches(partInstance)
    if not partInstance or not partInstance:IsA("BasePart") or highlightPartProcessed[partInstance] then return end

    local hi = partInstance:FindFirstChild(TARGET_HIGHLIGHT_NAME)
    if hi and hi:IsA("Highlight") then
        local nm = (hi.Name == TARGET_HIGHLIGHT_NAME)
        local en = (hi.Enabled == TARGET_ENABLED)
        local dm = (hi.DepthMode == TARGET_DEPTH_MODE)
        local ft = (math.abs(hi.FillTransparency - TARGET_FILL_TRANSPARENCY) < 0.01)
        local ot = (math.abs(hi.OutlineTransparency - TARGET_OUTLINE_TRANSPARENCY) < 0.01)
        local fc = areColorsSimilar(hi.FillColor, TARGET_FILL_COLOR_RGB)
        local oc = areColorsSimilar(hi.OutlineColor, TARGET_OUTLINE_COLOR_RGB)

        if nm and en and dm and fc and ft and oc and ot then
            highlightPartProcessed[partInstance] = true
            runBallShadowTrackingLogic()
        end
    end
end

-- Escutando novos descendentes adicionados ao workspace
Workspace.DescendantAdded:Connect(function(d)
    if d:IsA("BasePart") then
        task.wait(0.05)
        processPartIfMatches(d)
    elseif d:IsA("Highlight") and d.Name == TARGET_HIGHLIGHT_NAME and d.Parent then
        processPartIfMatches(d.Parent)
    end
end)

-- Verificação inicial de partes já existentes
for _, d in ipairs(Workspace:GetDescendants()) do
    if d:IsA("BasePart") then
        processPartIfMatches(d)
    end
end
