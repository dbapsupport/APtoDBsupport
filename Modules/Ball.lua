local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Configurações
local FX_FOLDER_NAME = "FX"
local TARGET_PART_NAME = "BallShadow"
local DECAL_NAME_INSIDE = "Decal"
local FOLLOWER_SPHERE_NAME = "Ball"
local SPHERE_PARENT = Workspace:WaitForChild("Lobby"):WaitForChild("ReadyArea"):WaitForChild("Model")
local TARGET_TRACKED_COLOR = Color3.fromRGB(111, 111, 111)
local MIN_TRANSPARENCY = 0.3
local MAX_TRANSPARENCY = 1.0
local MIN_HEIGHT_OFFSET = 2.0
local MAX_HEIGHT_OFFSET = 280.0
local LERP_FACTOR = 1

-- Estado
local isTracking = false
local trackedPartInstance = nil
local trackedDecalInstance = nil
local followerSphere = nil
local renderConnection = nil

-- Iniciar acompanhamento
local function StartTracking(partToTrack, decalToTrack)
    if isTracking or renderConnection then return end
    if not partToTrack or not decalToTrack then return end

    isTracking = true
    trackedPartInstance = partToTrack
    trackedDecalInstance = decalToTrack

    -- Muda a cor da parte rastreada
    trackedPartInstance.Color = TARGET_TRACKED_COLOR

    -- Remove esfera antiga, se houver
    local oldFollower = SPHERE_PARENT:FindFirstChild(FOLLOWER_SPHERE_NAME)
    if oldFollower then oldFollower:Destroy() end

    -- Cria nova esfera
    followerSphere = Instance.new("Part")
    followerSphere.Name = FOLLOWER_SPHERE_NAME
    followerSphere.Shape = Enum.PartType.Ball
    followerSphere.Size = Vector3.new(4, 4, 4)
    followerSphere.Color = Color3.fromRGB(255, 255, 255)
    followerSphere.Material = Enum.Material.Air
    followerSphere.Anchored = true
    followerSphere.CanCollide = false
    followerSphere.Transparency = 1
    followerSphere.Parent = SPHERE_PARENT

    -- Posição inicial com base na transparência
    local initialTransparency = trackedDecalInstance.Transparency
    local initialNormTrans = math.clamp(
        (initialTransparency - MIN_TRANSPARENCY) / (MAX_TRANSPARENCY - MIN_TRANSPARENCY),
        0, 1
    )
    local initialHeight = MIN_HEIGHT_OFFSET + (MAX_HEIGHT_OFFSET - MIN_HEIGHT_OFFSET) * initialNormTrans
    local initialShadowPos = trackedPartInstance.Position

    followerSphere.Position = Vector3.new(
        initialShadowPos.X,
        initialShadowPos.Y + initialHeight,
        initialShadowPos.Z
    )

    -- Conectar atualização por frame
    renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not trackedPartInstance
            or not trackedPartInstance.Parent
            or not trackedDecalInstance
            or not trackedDecalInstance.Parent
            or trackedDecalInstance.Parent ~= trackedPartInstance
            or not followerSphere
            or not followerSphere.Parent
        then
            StopTracking()
            return
        end

        local currentTransparency = trackedDecalInstance.Transparency
        local normalizedTransparency = math.clamp(
            (currentTransparency - MIN_TRANSPARENCY) / (MAX_TRANSPARENCY - MIN_TRANSPARENCY),
            0, 1
        )

        local calculatedHeightOffset = MIN_HEIGHT_OFFSET + (MAX_HEIGHT_OFFSET - MIN_HEIGHT_OFFSET) * normalizedTransparency
        local shadowPosition = trackedPartInstance.Position
        local sphereTargetPosition = Vector3.new(
            shadowPosition.X,
            shadowPosition.Y + calculatedHeightOffset,
            shadowPosition.Z
        )

        followerSphere.Position = followerSphere.Position:Lerp(sphereTargetPosition, LERP_FACTOR)
    end)
end

-- Parar acompanhamento
function StopTracking()
    if not isTracking then return end

    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end

    local sphereToDestroy = followerSphere or Workspace:FindFirstChild(FOLLOWER_SPHERE_NAME)
    if sphereToDestroy and sphereToDestroy.Parent then
        sphereToDestroy:Destroy()
    end

    followerSphere = nil
    trackedPartInstance = nil
    trackedDecalInstance = nil
    isTracking = false
end

-- Inicialização
local fxFolder = Workspace:WaitForChild(FX_FOLDER_NAME, 30)
if fxFolder then
    -- Quando uma nova parte é adicionada
    fxFolder.ChildAdded:Connect(function(child)
        if child.Name == TARGET_PART_NAME and child:IsA("BasePart") and not isTracking then
            task.wait(0.1)
            local decal = child:FindFirstChild(DECAL_NAME_INSIDE)
            if decal and decal:IsA("Decal") and not isTracking then
                StartTracking(child, decal)
            end
        end
    end)

    -- Quando a parte rastreada é removida
    fxFolder.ChildRemoved:Connect(function(child)
        if child == trackedPartInstance then
            StopTracking()
        end
    end)

    -- Verificação inicial se já existe a parte ao iniciar
    if not isTracking then
        local initialPart = fxFolder:FindFirstChild(TARGET_PART_NAME)
        if initialPart and initialPart:IsA("BasePart") then
            local initialDecal = initialPart:FindFirstChild(DECAL_NAME_INSIDE)
            if initialDecal and initialDecal:IsA("Decal") and not isTracking then
                StartTracking(initialPart, initialDecal)
            end
        end
    end
end
