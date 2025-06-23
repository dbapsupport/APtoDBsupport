local g = getgenv()
if not g._authenticated or g._launched then return end
g._launched = true

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Nova",
    SubTitle = "Death Ball",
    TabWidth = 100,
    Size = UDim2.fromOffset(500, 300),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    main = Window:AddTab({ Title = "Main", Icon = "home" }),
    farm = Window:AddTab({ Title = "Farm", Icon = "skull" }),
    skins = Window:AddTab({ Title = "Visuals", Icon = "paintbrush" }),
    rage = Window:AddTab({ Title = "Rage", Icon = "syringe" }),
    settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

--Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

--[[-------------------------------------------------------MAIN-------------------------------------------------------]]--  

    -- Ball function
    local RunService=game:GetService("RunService");local Workspace=game:GetService("Workspace");local FX_FOLDER_NAME="FX";local TARGET_PART_NAME="BallShadow";local DECAL_NAME_INSIDE="Decal";local FOLLOWER_SPHERE_NAME="Ball";local TARGET_TRACKED_COLOR=Color3.fromRGB(111,111,111);local MIN_TRANSPARENCY=0.3;local MAX_TRANSPARENCY=1.0;local MIN_HEIGHT_OFFSET=2.0;local MAX_HEIGHT_OFFSET=280.0;local LERP_FACTOR=1;local isTracking=false;local trackedPartInstance=nil;local trackedDecalInstance=nil;local followerSphere=nil;local renderConnection=nil;local function StartTracking(partToTrack,decalToTrack)if isTracking or renderConnection then return end;if not partToTrack or not decalToTrack then return end;isTracking=true;trackedPartInstance=partToTrack;trackedDecalInstance=decalToTrack;trackedPartInstance.Color=TARGET_TRACKED_COLOR;local oldFollower=Workspace:FindFirstChild(FOLLOWER_SPHERE_NAME);if oldFollower then oldFollower:Destroy()end;followerSphere=Instance.new("Part");followerSphere.Name=FOLLOWER_SPHERE_NAME;followerSphere.Shape=Enum.PartType.Ball;followerSphere.Size=Vector3.new(4,4,4);followerSphere.Color=Color3.fromRGB(255,255,255);followerSphere.Material=Enum.Material.Air;followerSphere.Anchored=true;followerSphere.CanCollide=false;followerSphere.Transparency=1;followerSphere.Parent=Workspace;local initialTransparency=trackedDecalInstance.Transparency;local initialNormTrans=math.clamp((initialTransparency-MIN_TRANSPARENCY)/(MAX_TRANSPARENCY-MIN_TRANSPARENCY),0,1);local initialHeight=MIN_HEIGHT_OFFSET+(MAX_HEIGHT_OFFSET-MIN_HEIGHT_OFFSET)*initialNormTrans;local initialShadowPos=trackedPartInstance.Position;followerSphere.Position=Vector3.new(initialShadowPos.X,initialShadowPos.Y+initialHeight,initialShadowPos.Z);renderConnection=RunService.RenderStepped:Connect(function(deltaTime)if not trackedPartInstance or not trackedPartInstance.Parent or not trackedDecalInstance or not trackedDecalInstance.Parent or trackedDecalInstance.Parent~=trackedPartInstance or not followerSphere or not followerSphere.Parent then StopTracking();return end;local currentTransparency=trackedDecalInstance.Transparency;local normalizedTransparency=math.clamp((currentTransparency-MIN_TRANSPARENCY)/(MAX_TRANSPARENCY-MIN_TRANSPARENCY),0,1);local calculatedHeightOffset=MIN_HEIGHT_OFFSET+(MAX_HEIGHT_OFFSET-MIN_HEIGHT_OFFSET)*normalizedTransparency;local shadowPosition=trackedPartInstance.Position;local sphereTargetPosition=Vector3.new(shadowPosition.X,shadowPosition.Y+calculatedHeightOffset,shadowPosition.Z);followerSphere.Position=followerSphere.Position:Lerp(sphereTargetPosition,LERP_FACTOR)end)end;function StopTracking()if not isTracking then return end;if renderConnection then renderConnection:Disconnect();renderConnection=nil end;local sphereToDestroy=followerSphere or Workspace:FindFirstChild(FOLLOWER_SPHERE_NAME);if sphereToDestroy and sphereToDestroy.Parent then sphereToDestroy:Destroy()end;followerSphere=nil;trackedPartInstance=nil;trackedDecalInstance=nil;isTracking=false end;local fxFolder=Workspace:WaitForChild(FX_FOLDER_NAME,30);if fxFolder then fxFolder.ChildAdded:Connect(function(child)if child.Name==TARGET_PART_NAME and child:IsA("BasePart")and not isTracking then task.wait(0.1);local decal=child:FindFirstChild(DECAL_NAME_INSIDE);if decal and decal:IsA("Decal")and not isTracking then StartTracking(child,decal)end end end);fxFolder.ChildRemoved:Connect(function(child)if child==trackedPartInstance then StopTracking()end end);if not isTracking then local initialPart=fxFolder:FindFirstChild(TARGET_PART_NAME);if initialPart and initialPart:IsA("BasePart")then local initialDecal=initialPart:FindFirstChild(DECAL_NAME_INSIDE);if initialDecal and initialDecal:IsA("Decal")and not isTracking then StartTracking(initialPart,initialDecal)end end end end
    local Workspace=game:GetService("Workspace");local TARGET_HIGHLIGHT_NAME="Highlight";local TARGET_FILL_COLOR_RGB={R=255,G=149,B=0};local TARGET_OUTLINE_COLOR_RGB={R=255,G=238,B=0};local TARGET_FILL_TRANSPARENCY=1;local TARGET_OUTLINE_TRANSPARENCY=0;local TARGET_ENABLED=true;local TARGET_DEPTH_MODE=Enum.HighlightDepthMode.AlwaysOnTop;local COLOR_COMPONENT_TOLERANCE=0.01;local highlightPartProcessed={};local function runBallShadowTrackingLogic()local RunService_BS=game:GetService("RunService");local Workspace_BS=game:GetService("Workspace");local FX_FOLDER_NAME_BS="FX";local TARGET_PART_NAME_BS="BallShadow";local DECAL_NAME_INSIDE_BS="Decal";local FOLLOWER_SPHERE_NAME_BS="ToroBall";local TARGET_PART_INITIAL_COLOR_BS=Color3.fromRGB(163,162,165);local MIN_TRANSPARENCY_BS=0.3;local MAX_TRANSPARENCY_BS=1.0;local MIN_HEIGHT_OFFSET_BS=2.0;local MAX_HEIGHT_OFFSET_BS=280.0;local LERP_FACTOR_BS=1;local isTracking_BS=false;local trackedPartInstance_BS=nil;local trackedDecalInstance_BS=nil;local followerSphere_BS=nil;local renderConnection_BS=nil;local childAddedConnection_BS=nil;local childRemovedConnection_BS=nil;local function StopTracking_BS()if not isTracking_BS then return end;if renderConnection_BS then renderConnection_BS:Disconnect();renderConnection_BS=nil;end;if childAddedConnection_BS then childAddedConnection_BS:Disconnect();childAddedConnection_BS=nil;end;if childRemovedConnection_BS then childRemovedConnection_BS:Disconnect();childRemovedConnection_BS=nil;end;local sphereToDestroy=followerSphere_BS or Workspace_BS:FindFirstChild(FOLLOWER_SPHERE_NAME_BS);if sphereToDestroy and sphereToDestroy.Parent then sphereToDestroy:Destroy()end;followerSphere_BS=nil;trackedPartInstance_BS=nil;trackedDecalInstance_BS=nil;isTracking_BS=false end;local function StartTracking_BS(partToTrack,decalToTrack)if isTracking_BS or renderConnection_BS then return end;if not partToTrack or not decalToTrack then return end;isTracking_BS=true;trackedPartInstance_BS=partToTrack;trackedDecalInstance_BS=decalToTrack;local oldFollower=Workspace_BS:FindFirstChild(FOLLOWER_SPHERE_NAME_BS);if oldFollower then oldFollower:Destroy()end;followerSphere_BS=Instance.new("Part");followerSphere_BS.Name=FOLLOWER_SPHERE_NAME_BS;followerSphere_BS.Shape=Enum.PartType.Ball;followerSphere_BS.Size=Vector3.new(4,4,4);followerSphere_BS.Color=Color3.fromRGB(255,0,0);followerSphere_BS.Material=Enum.Material.Neon;followerSphere_BS.Anchored=true;followerSphere_BS.CanCollide=false;followerSphere_BS.Transparency=0;followerSphere_BS.Parent=Workspace_BS;local initialTransparency=trackedDecalInstance_BS.Transparency;local initialNormTrans=math.clamp((initialTransparency-MIN_TRANSPARENCY_BS)/(MAX_TRANSPARENCY_BS-MIN_TRANSPARENCY_BS),0,1);local initialHeight=MIN_HEIGHT_OFFSET_BS+(MAX_HEIGHT_OFFSET_BS-MIN_HEIGHT_OFFSET_BS)*initialNormTrans;local initialShadowPos=trackedPartInstance_BS.Position;followerSphere_BS.Position=Vector3.new(initialShadowPos.X,initialShadowPos.Y+initialHeight,initialShadowPos.Z);renderConnection_BS=RunService_BS.RenderStepped:Connect(function(deltaTime)if not trackedPartInstance_BS or not trackedPartInstance_BS.Parent or not trackedDecalInstance_BS or not trackedDecalInstance_BS.Parent or trackedDecalInstance_BS.Parent~=trackedPartInstance_BS or not followerSphere_BS or not followerSphere_BS.Parent then StopTracking_BS();return end;local currentTransparency=trackedDecalInstance_BS.Transparency;local normalizedTransparency=math.clamp((currentTransparency-MIN_TRANSPARENCY_BS)/(MAX_TRANSPARENCY_BS-MIN_TRANSPARENCY_BS),0,1);local calculatedHeightOffset=MIN_HEIGHT_OFFSET_BS+(MAX_HEIGHT_OFFSET_BS-MIN_HEIGHT_OFFSET_BS)*normalizedTransparency;local shadowPosition=trackedPartInstance_BS.Position;local sphereTargetPosition=Vector3.new(shadowPosition.X,shadowPosition.Y+calculatedHeightOffset,shadowPosition.Z);followerSphere_BS.Position=followerSphere_BS.Position:Lerp(sphereTargetPosition,LERP_FACTOR_BS)end);if childAddedConnection_BS then childAddedConnection_BS:Disconnect();childAddedConnection_BS=nil;end;if childRemovedConnection_BS then childRemovedConnection_BS:Disconnect();childRemovedConnection_BS=nil;end end;local fxFolder_BS=Workspace_BS:WaitForChild(FX_FOLDER_NAME_BS,30);if fxFolder_BS then childAddedConnection_BS=fxFolder_BS.ChildAdded:Connect(function(child)if isTracking_BS then return end;if child.Name==TARGET_PART_NAME_BS and child:IsA("BasePart")and child.Color==TARGET_PART_INITIAL_COLOR_BS then task.wait(0.1);local decal=child:FindFirstChild(DECAL_NAME_INSIDE_BS);if decal and decal:IsA("Decal")then StartTracking_BS(child,decal)end end end);childRemovedConnection_BS=fxFolder_BS.ChildRemoved:Connect(function(child)if child==trackedPartInstance_BS then StopTracking_BS()end end);if not isTracking_BS then local initialPart=fxFolder_BS:FindFirstChild(TARGET_PART_NAME_BS);if initialPart and initialPart:IsA("BasePart")and initialPart.Color==TARGET_PART_INITIAL_COLOR_BS then task.wait(0.1);local initialDecal=initialPart:FindFirstChild(DECAL_NAME_INSIDE_BS);if initialDecal and initialDecal:IsA("Decal")then StartTracking_BS(initialPart,initialDecal)end end end;task.delay(10,function()if not isTracking_BS then if childAddedConnection_BS then childAddedConnection_BS:Disconnect();childAddedConnection_BS=nil;end;if childRemovedConnection_BS then childRemovedConnection_BS:Disconnect();childRemovedConnection_BS=nil;end end end)end end;local function areColorsSimilar(colorA_Color3,targetColor_RGBTable)if not colorA_Color3 or not targetColor_RGBTable then return false end;local r=math.abs(colorA_Color3.R-(targetColor_RGBTable.R/255))<COLOR_COMPONENT_TOLERANCE;local g=math.abs(colorA_Color3.G-(targetColor_RGBTable.G/255))<COLOR_COMPONENT_TOLERANCE;local b=math.abs(colorA_Color3.B-(targetColor_RGBTable.B/255))<COLOR_COMPONENT_TOLERANCE;return r and g and b end;local function processPartIfMatches(partInstance)if not partInstance or not partInstance:IsA("BasePart")or highlightPartProcessed[partInstance]then return end;local hi=partInstance:FindFirstChild(TARGET_HIGHLIGHT_NAME);if hi and hi:IsA("Highlight")then local nm=(hi.Name==TARGET_HIGHLIGHT_NAME);local en=(hi.Enabled==TARGET_ENABLED);local dm=(hi.DepthMode==TARGET_DEPTH_MODE);local ft=(math.abs(hi.FillTransparency-TARGET_FILL_TRANSPARENCY)<0.01);local ot=(math.abs(hi.OutlineTransparency-TARGET_OUTLINE_TRANSPARENCY)<0.01);local fc=areColorsSimilar(hi.FillColor,TARGET_FILL_COLOR_RGB);local oc=areColorsSimilar(hi.OutlineColor,TARGET_OUTLINE_COLOR_RGB);if nm and en and dm and fc and ft and oc and ot then highlightPartProcessed[partInstance]=true;runBallShadowTrackingLogic()end end end;Workspace.DescendantAdded:Connect(function(d)if d:IsA("BasePart")then task.wait(0.05);processPartIfMatches(d)elseif d:IsA("Highlight")and d.Name==TARGET_HIGHLIGHT_NAME and d.Parent then processPartIfMatches(d.Parent)end end);for _,d in ipairs(Workspace:GetDescendants())do if d:IsA("BasePart")then processPartIfMatches(d)end end
    
    -- Variáveis globais
    local camera = Workspace.CurrentCamera
    local player = Players.LocalPlayer
    
    -- Constantes do AutoParry
    local BALL_NAME = "Ball"
    local TORO_BALL_NAME = "ToroBall"
    local SHOW_VISUAL_HITBOX = false
    local THREAT_FILL_TRANSPARENCY = 0.34
    local VISUAL_HITBOX_COLOR = Color3.fromRGB(0, 255, 0)
    local VISUAL_HITBOX_TRANSPARENCY = 0.75
    local BASE_PARRY_RADIUS = 15
    local TORO_BALL_FIXED_PARRY_RADIUS = 20
    local MIN_SPEED_FOR_RADIUS_INCREASE = 40
    local MAX_PARRY_RADIUS = 50
    local PARRY_COOLDOWN = 0
    local ENABLE_DIRECTION_FILTER = true
    local DIRECTION_DOT_THRESHOLD = 0.707
    local CLASH_SPAM_RADIUS = 10
    local ENABLE_PREDICTION_FILTER = true
    local PREDICTION_FRAMES = 2
    local PREDICTION_TOLERANCE = 0.2
    local DEBUG_SPEED_INFO = false
    local MIN_BALL_SPEED = 0.05
    local ENABLE_CURVE_DETECTION = true
    local CURVE_ANGLE_THRESHOLD = 45
    local MIN_SPEED_FOR_CURVE_DETECTION = 10
    local autoAbilityEnabled = true
    
    -- Variáveis de estado
    local scriptEnabled = false
    local currentRadiusIncreasePerSpeed = 0.1
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    local ball = nil -- Inicializa como nil, será procurado no loop
    local trackedBallType = nil -- << NOVO: Pode ser "Normal" ou "Toro"
    
    local lastParryTime = 0
    local parryVisual = nil
    local previousBallPosition = nil
    local heartbeatConnection = nil
    local lastBallMovementVector = Vector3.zero
    local lastBallSpeed = 0
    
    -- Função para verificar se o ActiveAbilityLabel está visível
    local function IsAbilityActive()
        local deflectBillboard = humanoidRootPart and humanoidRootPart:FindFirstChild("DeflectBillboardGui")
        if not deflectBillboard then return false end
        
        local activeAbilityLabel = deflectBillboard:FindFirstChild("ActiveAbilityLabel")
        if not activeAbilityLabel then return false end
        
        return activeAbilityLabel.Visible
    end
    
    local function UpdateOrCreateVisualizer(currentHrp, radius)
        if not scriptEnabled or not SHOW_VISUAL_HITBOX then
            if parryVisual then DestroyVisualizer() end
            return
        end
        
        if not currentHrp or not currentHrp.Parent then 
            if parryVisual then DestroyVisualizer() end
            return
        end
        
        if not parryVisual or not parryVisual.Parent then 
            if parryVisual then parryVisual:Destroy() end
            parryVisual = Instance.new("Part")
            parryVisual.Name = "Part"
            parryVisual.Shape = Enum.PartType.Ball
            parryVisual.Material = Enum.Material.ForceField
            parryVisual.Color = VISUAL_HITBOX_COLOR
            parryVisual.Transparency = VISUAL_HITBOX_TRANSPARENCY
            parryVisual.Anchored = true
            parryVisual.CanCollide = false
            parryVisual.CanQuery = false
            parryVisual.CanTouch = false
            parryVisual.Locked = true
            parryVisual.Parent = Workspace
        end
        
        local diameter = radius * 2
        parryVisual.Size = Vector3.new(diameter, diameter, diameter)
        parryVisual.CFrame = currentHrp.CFrame
    end
    
    local function DestroyVisualizer()
        if parryVisual then 
            parryVisual:Destroy()
            parryVisual = nil
        end
    end

    local function PerformParryAction()
        local sD, eD = pcall(function() 
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        end)
        
        if not sD then 
            warn("VIM KeyDown Err:", eD)
            return
        end
        
        local sU, eU = pcall(function() 
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        end)
        
        if not sU then 
            warn("VIM KeyUp Err:", eU)
        end
    end
    
    local function AutoParryLoop(deltaTime)
        if not scriptEnabled or deltaTime <= 0 then return end
    
        local currentCharacter = player.Character
        local currentHrp = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
        if not currentCharacter or not currentHrp then DestroyVisualizer(); return; end
        character = currentCharacter; humanoidRootPart = currentHrp;
    
        if IsAbilityActive() then return end
    
        local hrpPos = humanoidRootPart.Position 
        local primaryBallInstance = Workspace:FindFirstChild(BALL_NAME)
        local secondaryBallInstance = Workspace:FindFirstChild(TORO_BALL_NAME)
        local newCurrentBallCandidate = nil
        local newTrackedBallTypeCandidate = nil

        if primaryBallInstance and secondaryBallInstance then
            local distToPrimary = (primaryBallInstance.Position - hrpPos).Magnitude
            local distToSecondary = (secondaryBallInstance.Position - hrpPos).Magnitude
            if distToPrimary <= distToSecondary then
                newCurrentBallCandidate = primaryBallInstance
                newTrackedBallTypeCandidate = "Normal"
            else
                newCurrentBallCandidate = secondaryBallInstance
                newTrackedBallTypeCandidate = "Toro"
            end
        elseif primaryBallInstance then
            newCurrentBallCandidate = primaryBallInstance
            newTrackedBallTypeCandidate = "Normal"
        elseif secondaryBallInstance then
            newCurrentBallCandidate = secondaryBallInstance
            newTrackedBallTypeCandidate = "Toro"
        else
            DestroyVisualizer(); ball = nil; trackedBallType = nil; previousBallPosition = nil; return
        end

        if ball ~= newCurrentBallCandidate then
            if newCurrentBallCandidate then previousBallPosition = newCurrentBallCandidate.Position else previousBallPosition = nil end
        end
        ball = newCurrentBallCandidate
        trackedBallType = newTrackedBallTypeCandidate
        local currentBall = ball
        
        local playerModelInWorkspace = Workspace:FindFirstChild(player.Name)
        local playerCharHighlight = nil
        local isThreat = false -- Assume que não há ameaça por padrão
        if playerModelInWorkspace then
            playerCharHighlight = playerModelInWorkspace:FindFirstChildWhichIsA("Highlight")
            if playerCharHighlight and playerCharHighlight.Enabled and math.abs(playerCharHighlight.FillTransparency - THREAT_FILL_TRANSPARENCY) < 0.001 then
                isThreat = true -- Ameaça detectada
            end
        end

        local ballPos = currentBall.Position
        local distance = (humanoidRootPart.Position - ballPos).Magnitude
        local ballSpeed = 0
        local ballMovementVector = Vector3.zero
        if previousBallPosition then 
            ballMovementVector = ballPos - previousBallPosition
            local distanceMoved = ballMovementVector.Magnitude
            if deltaTime > 1e-5 and distanceMoved / deltaTime < 5000 then
                ballSpeed = distanceMoved / deltaTime
            end
        end
        previousBallPosition = ballPos

        if ballSpeed < MIN_BALL_SPEED then
            local visualizerRadiusToShow = BASE_PARRY_RADIUS
            if trackedBallType == "Toro" then
                visualizerRadiusToShow = TORO_BALL_FIXED_PARRY_RADIUS
            end
            UpdateOrCreateVisualizer(humanoidRootPart, visualizerRadiusToShow)
            return
        end
    
        local parryRadiusToUse
        if trackedBallType == "Toro" then
            parryRadiusToUse = TORO_BALL_FIXED_PARRY_RADIUS
        else 
            parryRadiusToUse = BASE_PARRY_RADIUS
            if ballSpeed >= MIN_SPEED_FOR_RADIUS_INCREASE then
                local radiusIncrease = (ballSpeed * currentRadiusIncreasePerSpeed)
                parryRadiusToUse = parryRadiusToUse + radiusIncrease
                parryRadiusToUse = math.min(parryRadiusToUse, MAX_PARRY_RADIUS)
            end
        end
    
        local isMakingSharpCurve = false
        if ENABLE_CURVE_DETECTION and ballSpeed > MIN_SPEED_FOR_CURVE_DETECTION and lastBallMovementVector.Magnitude > 0 then
            local currentBallDirectionUnit = ballMovementVector.Unit
            local lastBallDirectionUnit = lastBallMovementVector.Unit
            if currentBallDirectionUnit.Magnitude > 0.99 and lastBallDirectionUnit.Magnitude > 0.99 then
                local dotProduct = currentBallDirectionUnit:Dot(lastBallDirectionUnit)
                local angle = math.deg(math.acos(math.clamp(dotProduct, -1, 1)))
                isMakingSharpCurve = (angle > CURVE_ANGLE_THRESHOLD)
            end
        end
        lastBallMovementVector = ballMovementVector
        lastBallSpeed = ballSpeed
        UpdateOrCreateVisualizer(humanoidRootPart, parryRadiusToUse)
    
        local currentTime = os.clock()
        if currentTime - lastParryTime < PARRY_COOLDOWN then return end
    
        -- ==========================================
        --          CONDIÇÕES PARA ATIVAR PARRY (LÓGICA REVISADA)
        -- ==========================================
        local shouldPerformParry = false

        if trackedBallType == "Normal" then
            -- Para a bola "Normal", 'isThreat' é OBRIGATÓRIO
            if isThreat then
                -- Condições Normais para "Ball" (requer isThreat)
                if distance <= parryRadiusToUse and not isMakingSharpCurve then
                    local directionCheckPassed = true
                    if ENABLE_DIRECTION_FILTER then
                        local vectorToPlayer = (humanoidRootPart.Position - ballPos).Unit
                        local ballDirectionUnit = ballMovementVector.Unit
                        if ballMovementVector.Magnitude > 0.01 and ballDirectionUnit.Magnitude > 0.99 then
                            local directionDot = ballDirectionUnit:Dot(vectorToPlayer)
                            directionCheckPassed = (directionDot > DIRECTION_DOT_THRESHOLD)
                        else
                            directionCheckPassed = false 
                        end
                    end
                    local predictionCheckPassed = true
                    if directionCheckPassed and ENABLE_PREDICTION_FILTER and ballMovementVector.Magnitude > 0.01 then
                        local predictedBallPos = ballPos + (ballMovementVector * PREDICTION_FRAMES)
                        local predictedDistance = (humanoidRootPart.Position - predictedBallPos).Magnitude
                        predictionCheckPassed = (predictedDistance <= distance + PREDICTION_TOLERANCE)
                    end
                    if directionCheckPassed and predictionCheckPassed then
                        shouldPerformParry = true
                    end
                end

                -- Condições de Clash Spam para "Ball" (requer isThreat)
                if not shouldPerformParry and (distance <= CLASH_SPAM_RADIUS and not isMakingSharpCurve) then
                    shouldPerformParry = true
                end
            end
        elseif trackedBallType == "Toro" then
            -- Para a "ToroBall", 'isThreat' NÃO é obrigatório, mas pode ajudar.
            -- Ela pode ser rebatida a qualquer momento.

            -- Condição para ToroBall MUITO PRÓXIMA (mais permissiva, ignora curva e alguns filtros)
            -- Usamos um raio menor aqui, como o CLASH_SPAM_RADIUS, ou uma fração do seu raio fixo
            local toroVeryCloseRadius = math.min(CLASH_SPAM_RADIUS, TORO_BALL_FIXED_PARRY_RADIUS * 0.5) -- Ex: 7.5 se CLASH_SPAM é 10 e TORO_FIXED é 15. Pegue o menor desses para garantir que não seja muito grande.

            if distance <= toroVeryCloseRadius then
                 -- Quando MUITO perto, vamos ser bem permissivos com a direção,
                 -- apenas para garantir que não estamos dando parry numa bola que está claramente indo embora.
                local directionCheckPassedForVeryClose = true
                if ENABLE_DIRECTION_FILTER then -- Ainda pode usar o filtro de direção, mas talvez com um threshold menor
                    local vectorToPlayer = (humanoidRootPart.Position - ballPos).Unit
                    local ballDirectionUnit = ballMovementVector.Unit
                    if ballMovementVector.Magnitude > 0.01 and ballDirectionUnit.Magnitude > 0.99 then
                        local directionDot = ballDirectionUnit:Dot(vectorToPlayer)
                        directionCheckPassedForVeryClose = (directionDot > (DIRECTION_DOT_THRESHOLD * 0.5)) -- Ex: threshold de direção mais baixo (0.35)
                    else
                        directionCheckPassedForVeryClose = false
                    end
                end
                if directionCheckPassedForVeryClose then
                    if DEBUG_SPEED_INFO then print("ToroBall VERY CLOSE parry condition!") end
                    shouldPerformParry = true
                end
            
            -- Condições Normais para "ToroBall" (usa seu raio fixo, não exige 'isThreat')
            -- Mas se 'isThreat' estiver ativo, é um bônus.
            -- Ignora o filtro de curva para ToroBall, já que ela é mais imprevisível/clicável.
            elseif not shouldPerformParry and distance <= parryRadiusToUse then --  (removido: and not isMakingSharpCurve)
                local directionCheckPassed = true
                if ENABLE_DIRECTION_FILTER then
                    local vectorToPlayer = (humanoidRootPart.Position - ballPos).Unit
                    local ballDirectionUnit = ballMovementVector.Unit
                    if ballMovementVector.Magnitude > 0.01 and ballDirectionUnit.Magnitude > 0.99 then
                        local directionDot = ballDirectionUnit:Dot(vectorToPlayer)
                        directionCheckPassed = (directionDot > DIRECTION_DOT_THRESHOLD)
                    else
                        directionCheckPassed = false 
                    end
                end
                
                -- Filtro de predição ainda pode ser útil para ToroBall para evitar parries tardios
                local predictionCheckPassed = true
                if directionCheckPassed and ENABLE_PREDICTION_FILTER and ballMovementVector.Magnitude > 0.01 then
                    local predictedBallPos = ballPos + (ballMovementVector * PREDICTION_FRAMES)
                    local predictedDistance = (humanoidRootPart.Position - predictedBallPos).Magnitude
                    predictionCheckPassed = (predictedDistance <= distance + PREDICTION_TOLERANCE) 
                end

                if directionCheckPassed and predictionCheckPassed then
                    shouldPerformParry = true
                end
            end
        end

        -- ==========================================
        --          ATIVAÇÃO FINAL DO PARRY
        -- ==========================================
        if shouldPerformParry then
            PerformParryAction()
            lastParryTime = currentTime
        end
    end

    local AutoParryToggle = Tabs.main:AddToggle("autoparry", {
        Title = "Auto parry",
        Default = true,
        Callback = function(value)
            scriptEnabled = value
            if scriptEnabled then
                if not heartbeatConnection or not heartbeatConnection.Connected then
                    ball = nil
                    trackedBallType = nil
                    previousBallPosition = nil
                    heartbeatConnection = RunService.Heartbeat:Connect(AutoParryLoop)
                end
            else
                if heartbeatConnection and heartbeatConnection.Connected then
                    heartbeatConnection:Disconnect()
                end
                heartbeatConnection = nil
                DestroyVisualizer()
                ball = nil
                trackedBallType = nil
                previousBallPosition = nil
            end
        end
    })

    local AutoParryKeybind = Tabs.main:AddKeybind("bind", {
        Title = "Parry Bind",
        Mode = "Toggle",
        Default = "G",
        Callback = function(Value)
            AutoParryToggle:SetValue(not AutoParryToggle.Value)
        end
    })
    
    Tabs.main:AddSlider("pingcomp", {
        Title = "Ping compensator",
        Description = "adjust according to your ms.",
        Default = 0.08,
        Min = 0.01,
        Max = 0.2,
        Rounding = 3,
        Callback = function(value)
            currentRadiusIncreasePerSpeed = value
        end
    })

local player = Players.LocalPlayer
local character = Workspace:FindFirstChild(player.Name)

-- Find DeflectButton
local deflectButton = player:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("HolderBottom"):WaitForChild("ToolbarButtons"):WaitForChild("DeflectButton")

local lastTransparency = deflectButton.BackgroundTransparency
local timerRunning = false
local startTime = 0
local printed90 = false

-- List of allowed abilities
local allowedAbilities = {
    -- Gazo
    ["FAKE BALL"] = true, ["ASTRAL PORTAL"] = true, ["CURSED BLUE"] = true,
    -- Lufus
    ["EXTEND-O ARM"] = true, ["GLASS WALL"] = true,
    -- Saito
    ["UPPER CUT"] = true, ["SONIC SLIDE"] = true, ["GROUND WALLS"] = true,
    -- Keilo
    ["ZAP FREEZE"] = true, ["ZAP DEFLECT"] = true, ["GOD SPEED"] = true,
    ["ASSASSIN INVISIBILITY"] = true, ["LIGHTNING INTERCEPT"] = true,
    -- Senshu
    ["CHARGED KICK"] = true, ["JUGGLING BLAST"] = true,
    -- Koju
    ["LEAP STRIKE"] = true, ["CHAIN SPEAR"] = true, ["HANDGUN"] = true,
    -- Kameki
    ["DRAGON RUSH"] = true, ["INSTANT TRAVEL"] = true, ["KI BLAST"] = true,
    -- Torokai
    ["ICE SLIDE"] = true, ["ICE SHIELD"] = true, ["FIRE DASH"] = true, ["FIRE BALL"] = true,
    -- JIRO
    ["BONK"] = true, ["SIDE STEP"] = true, ["BUNGEE"] = true,
    -- Gloom
    ["SHADOW RAMPAGE"] = true, ["DREAD SPHERE"] = true, ["PHANTOM GASP"] = true,
    -- Denjin
    ["ORBITAL CANNON"] = true,
    -- Wu
    ["RULERS HOLD"] = true, ["DAGGER DASH"] = true
}

-- Function to check if button is on cooldown
local function isOnCooldown(button)
    return button.BackgroundColor3 == Color3.new(0, 0, 0)
end

-- Function to simulate button click
local function clickButton(button)
    local pos = button.AbsolutePosition
    local size = button.AbsoluteSize
    local inset = GuiService:GetGuiInset()
    local centerX = pos.X + size.X / 2
    local centerY = pos.Y + size.Y / 2 + inset.Y
    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
end

-- Function to check Highlight transparency
local function isHighlightValid()
    local highlight = character:FindFirstChild("Highlight")
    if highlight and highlight:IsA("Highlight") then
        return math.abs(highlight.FillTransparency - 0.34) <= 0.001
    end
    return false
end

-- Main loop
task.spawn(function()
    while true do
        if autoAbilityEnabled then
            local currentTransparency = deflectButton.BackgroundTransparency
            local now = tick()

            -- Detect transparency change in DeflectButton
            if currentTransparency ~= lastTransparency then
                if not timerRunning then
                    startTime = now
                    timerRunning = true
                    printed90 = false
                else
                    timerRunning = false
                end
                lastTransparency = currentTransparency
            end

            -- Check if timer is running and 0.8s has passed
            if timerRunning and not printed90 then
                local elapsed = now - startTime
                if elapsed >= 0.8 then
                    if isHighlightValid() then
                        local gui = player:WaitForChild("PlayerGui")
                        local hud = gui:WaitForChild("HUD")
                        local holderBottom = hud:WaitForChild("HolderBottom")
                        local toolbarButtons = holderBottom:WaitForChild("ToolbarButtons")

                        for i = 1, 4 do
                            local button = toolbarButtons:FindFirstChild("AbilityButton" .. i)
                            if button then
                                local nameLabel = button:FindFirstChild("AbilityNameLabel")
                                if nameLabel then
                                    local abilityName = nameLabel.Text
                                    if allowedAbilities[abilityName] and not isOnCooldown(button) then
                                        clickButton(button)
                                        break
                                    end
                                end
                            end
                        end
                    end
                    printed90 = true
                end
            end
        end
        task.wait(0.05)
    end
end)

    

    Tabs.main:AddToggle("autoability", {
    Title = "Auto ability",
    Default = true,
    Callback = function(value)
        autoAbilityEnabled = value
    end
    })

        
    Tabs.main:AddToggle("autoready", {
        Title = "Auto ready",
        Default = false,
        Callback = function(Value)
            local player = game.Players.LocalPlayer
            local destino = Vector3.new(568.79, 281.908, -788.431)
    
            getgenv().autoReadyData = getgenv().autoReadyData or {
                ativo = false,
                andando = false,
                connectionStatus = nil,
                connectionChar = nil
            }
            local data = getgenv().autoReadyData
    
            local function mover()
                if data.andando then return end
                data.andando = true
                task.spawn(function()
                    while data.ativo do
                        local char = player.Character
                        local hum = char and char:FindFirstChild("Humanoid")
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and not player:GetAttribute("IsInGame") and (hrp.Position - destino).Magnitude > 5 then
                            hum:MoveTo(destino)
                        end
                        task.wait(0.3)
                    end
                    data.andando = false
                end)
            end
    
            if Value then
                data.ativo = true
                mover()
                if data.connectionStatus then data.connectionStatus:Disconnect() end
                data.connectionStatus = player:GetAttributeChangedSignal("IsInGame"):Connect(function()
                    if not player:GetAttribute("IsInGame") and data.ativo then mover() end
                end)
                if data.connectionChar then data.connectionChar:Disconnect() end
                data.connectionChar = player.CharacterAdded:Connect(function(char)
                    if data.ativo and not player:GetAttribute("IsInGame") then
                        char:WaitForChild("Humanoid")
                        mover()
                    end
                end)
            else
                data.ativo = false
                if data.connectionStatus then data.connectionStatus:Disconnect() end
                if data.connectionChar then data.connectionChar:Disconnect() end
                local char = player.Character
                local hum = char and char:FindFirstChild("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hum and hrp then hum:MoveTo(hrp.Position) end
            end
        end
    })    
    
    local fovInicialPadrao = camera and math.clamp(camera.FieldOfView, 70, 120) or 70
    Tabs.main:AddSlider("fov", {
        Title = "FOV",
        Default = fovInicialPadrao,
        Min = 70,
        Max = 120,
        Rounding = 0,
        Callback = function(Value)
            if camera then 
                camera.FieldOfView = Value 
            end
        end
    })
    
    Tabs.main:AddSlider("maxzoom", {
        Title = "Max zoom",
        Default = 45,
        Min = 45,
        Max = 200,
        Rounding = 0,
        Callback = function(Value)
            local currentPlayer = Players.LocalPlayer
            if currentPlayer then 
                currentPlayer.CameraMaxZoomDistance = Value 
            end
        end
    })

--[[-------------------------------------------------------FARM-------------------------------------------------------]]--

	local LocalPlayer = Players.LocalPlayer

	local CONFIG = {
		REVIVE_FOLDER_NAME = "ReviveParts",
		TELEPORT_Y_OFFSET = 3,
		TELEPORT_TIMEOUT = 1.8,
		WAIT_AFTER_TP = 0.15,
		WAIT_AFTER_CLICK = 0.2,
		ALIGN_MAX_FORCE = 200000,
		ALIGN_RESPONSIVENESS = 180,
		BOSS_CHECK_INTERVAL = 0.8,
		INITIAL_BOSS_DETECT_DELAY = 3,
		COLLIDER_REMOVE_TOLERANCE = 0.1,
		SPECIFIC_COLLIDER_POS = Vector3.new(463.603, 310.282, 1245.33)
	}

	local bossCoordinates = {
		["VillainMech"] = Vector3.new(476.02, 348.572, 1161.245),
		["TheStatue"] = Vector3.new(462.908, 368.243, 1264.58),
		["CursedSpirit"] = Vector3.new(461.006, 350, 1180.881)
	}

	local currentFarmHeightY = 350
	local autoFarmEnabled = false
	local currentFarmingBossName = nil
	local isFarmMoverActive = false
	local lastKnownFarmCFrame = nil
	local previousDetectedBossInMap = nil
	local bossJustAppeared = false
	local farmAlignPosition, farmRootAttachment = nil, nil
	local autoFarmToggleObject = nil

	local function getCharacterComponents()
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChild("Humanoid")
		if not (char and hrp and hum and hum.Health > 0) then return nil, nil, nil end
		return char, hrp, hum
	end

	local function destroyFarmMover()
		if not isFarmMoverActive then return end
		isFarmMoverActive = false
		pcall(function() if farmAlignPosition and farmAlignPosition.Parent then farmAlignPosition:Destroy() end end)
		pcall(function() if farmRootAttachment and farmRootAttachment.Parent then farmRootAttachment:Destroy() end end)
		farmAlignPosition, farmRootAttachment = nil, nil
		local _, hrp = getCharacterComponents()
		if hrp then pcall(function() hrp.Anchored = false end) end
	end

	local function arePositionsClose(pos1, pos2, tolerance)
		if not (pos1 and pos2) then return false end
		return (math.abs(pos1.X - pos2.X) <= tolerance) and (math.abs(pos1.Y - pos2.Y) <= tolerance) and (math.abs(pos1.Z - pos2.Z) <= tolerance)
	end

	local function removeSpecificColliderForTheStatue()
		local targetPos, tolerance = CONFIG.SPECIFIC_COLLIDER_POS, CONFIG.COLLIDER_REMOVE_TOLERANCE
		local activeMap = Workspace:FindFirstChild("ActiveMap")
		if not activeMap then return end
		local statueFolder = activeMap:FindFirstChild("TheStatue")
		if not statueFolder then return end
		local playerCollidersFolder = statueFolder:FindFirstChild("PlayerColliders")
		if not playerCollidersFolder then return end
		for _, collider in ipairs(playerCollidersFolder:GetChildren()) do
			if collider:IsA("Part") and arePositionsClose(collider.Position, targetPos, tolerance) then
				pcall(function() collider:Destroy() end)
				break
			end
		end
	end

	local function activateFarm(bossName)
		if not autoFarmEnabled then destroyFarmMover(); return end
		local _, hrp = getCharacterComponents()
		if not hrp then destroyFarmMover(); return end
		local targetBasePos = bossCoordinates[bossName]
		if not targetBasePos then destroyFarmMover(); return end
		local targetPosition = Vector3.new(targetBasePos.X, currentFarmHeightY, targetBasePos.Z)
		if bossName == "TheStatue" then removeSpecificColliderForTheStatue() end
		lastKnownFarmCFrame = hrp.CFrame
		currentFarmingBossName = bossName
		destroyFarmMover()
		local success = pcall(function()
			hrp.Anchored = false
			hrp.Velocity, hrp.RotVelocity = Vector3.zero, Vector3.zero
			hrp.CFrame = CFrame.new(targetPosition)
			task.wait(0.05)
			local _, curHrp = getCharacterComponents()
			if not curHrp then error("Character invalid post TP") end
			farmRootAttachment = Instance.new("Attachment", curHrp)
			farmAlignPosition = Instance.new("AlignPosition", curHrp)
			farmAlignPosition.Attachment0 = farmRootAttachment
			farmAlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
			farmAlignPosition.ApplyAtCenterOfMass = true
			farmAlignPosition.MaxForce = CONFIG.ALIGN_MAX_FORCE
			farmAlignPosition.Responsiveness = CONFIG.ALIGN_RESPONSIVENESS
			farmAlignPosition.Position = targetPosition
			isFarmMoverActive = true
		end)
		if not success then
			destroyFarmMover()
			currentFarmingBossName = nil
			lastKnownFarmCFrame = nil
			if autoFarmEnabled then
				autoFarmEnabled = false
				if autoFarmToggleObject and autoFarmToggleObject.SetValue then pcall(function() autoFarmToggleObject:SetValue(false) end) end
			end
		end
	end

	local function deactivateFarm(returnToLastPosition)
		local lastCFrame = lastKnownFarmCFrame
		destroyFarmMover()
		currentFarmingBossName = nil
		if returnToLastPosition and lastCFrame then
			local _, hrp = getCharacterComponents()
			if hrp then
				pcall(function() hrp.Anchored = false; hrp.CFrame = lastCFrame; task.wait(0.1); hrp.Anchored = false end)
			end
		end
		lastKnownFarmCFrame = nil
	end

	task.spawn(function()
		 while task.wait(CONFIG.BOSS_CHECK_INTERVAL) do
			 local char, hrp, hum = getCharacterComponents()
			 if not char then
				 if currentFarmingBossName then deactivateFarm(false) end
				 previousDetectedBossInMap = nil; continue
			 end
			 local activeMap = Workspace:FindFirstChild("ActiveMap")
			 local bossFoundInMap = nil
			 if activeMap then
				 for name, _ in pairs(bossCoordinates) do if activeMap:FindFirstChild(name) then bossFoundInMap = name; break end end
			 end
			 if bossFoundInMap ~= previousDetectedBossInMap then
				 if bossFoundInMap then
					 if autoFarmEnabled then bossJustAppeared = true
					 else destroyFarmMover(); currentFarmingBossName = nil
					 end
				 elseif currentFarmingBossName then deactivateFarm(false)
				 end
				 previousDetectedBossInMap = bossFoundInMap
			 end
			 if autoFarmEnabled and bossFoundInMap then
				 if currentFarmingBossName ~= bossFoundInMap or not isFarmMoverActive then
					 if bossJustAppeared then
						 task.wait(CONFIG.INITIAL_BOSS_DETECT_DELAY)
						 bossJustAppeared = false
						 if not autoFarmEnabled then continue end
						 local _, hrpAfterDelay, _ = getCharacterComponents(); if not hrpAfterDelay then continue end
						 local currentMapCheckAfterDelay = Workspace:FindFirstChild("ActiveMap")
						 local bossStillThere = currentMapCheckAfterDelay and currentMapCheckAfterDelay:FindFirstChild(bossFoundInMap)
						 if not bossStillThere then previousDetectedBossInMap = nil; continue end
						 activateFarm(bossFoundInMap)
					 else activateFarm(bossFoundInMap)
					 end
				 end
			 elseif not bossFoundInMap and currentFarmingBossName then deactivateFarm(false)
			 end
			 if not autoFarmEnabled or not bossFoundInMap then bossJustAppeared = false end
		 end
	end)

	autoFarmToggleObject = Tabs.farm:AddToggle("AutoFarmToggle", {Title = "Auto farm", Default = false, Callback = function(value)
		if autoFarmEnabled == value then return end
		autoFarmEnabled = value
		if value then
			local _, hrp, _ = getCharacterComponents()
			if not hrp then
				autoFarmEnabled = false
				if autoFarmToggleObject and autoFarmToggleObject.SetValue then pcall(function() autoFarmToggleObject:SetValue(false) end) end
				return
			end
			local activeMap = Workspace:FindFirstChild("ActiveMap")
			local bossAlreadyPresent = nil
			if activeMap then for name,_ in pairs(bossCoordinates) do if activeMap:FindFirstChild(name) then bossAlreadyPresent = name; break end end end
			if bossAlreadyPresent then activateFarm(bossAlreadyPresent) else destroyFarmMover(); currentFarmingBossName = nil end
		else deactivateFarm(true) end
	end})

	Tabs.farm:AddSlider("HeightSlider", {Title = "Farm height", Description = "adjust the height", Default = 350, Min = 300, Max = 380, Rounding = 0, Callback = function(value)
		currentFarmHeightY = math.floor(value + 0.5)
		if isFarmMoverActive and currentFarmingBossName and farmAlignPosition then
			local bossBasePos = bossCoordinates[currentFarmingBossName]
			if bossBasePos then
				local newTargetPos = Vector3.new(bossBasePos.X, currentFarmHeightY, bossBasePos.Z)
				pcall(function() farmAlignPosition.Position = newTargetPos end)
				local _, hrp = getCharacterComponents()
				if hrp then pcall(function() hrp.CFrame = CFrame.new(hrp.Position.X, newTargetPos.Y, hrp.Position.Z) end) end
			end
		end
	end})
	pcall(function() local sliderObj = Tabs.farm.Sections and Tabs.farm.Sections.AutoFarm and Tabs.farm.Sections.AutoFarm.Controls and Tabs.farm.Sections.AutoFarm.Controls.HeightSlider; if sliderObj and sliderObj.Value then currentFarmHeightY = math.floor(sliderObj.Value + 0.5) end end)

	Tabs.farm:AddButton({ Title = "Revive all", Callback = function()
		local RevivePlayers = game:GetService("Players")
		local ReviveWorkspace = game:GetService("Workspace")
		local reviveFolderName = CONFIG.REVIVE_FOLDER_NAME
		local localPlayerRevive = RevivePlayers.LocalPlayer
		local _, hrpBeforeRevive = getCharacterComponents()
		local cframeBeforeRevive = hrpBeforeRevive and hrpBeforeRevive.CFrame
		local returnCFrame = (autoFarmEnabled and lastKnownFarmCFrame) or cframeBeforeRevive
		local reviveAlignPos, reviveAttach = nil, nil

		local function destroyReviveMover()
			 pcall(function() if reviveAlignPos and reviveAlignPos.Parent then reviveAlignPos:Destroy() end end)
			 pcall(function() if reviveAttach and reviveAttach.Parent then reviveAttach:Destroy() end end)
			 reviveAlignPos, reviveAttach = nil, nil
			 local _, hrp = getCharacterComponents(); if hrp then pcall(function() hrp.Anchored = false end) end
		end
		local function teleportRevive(targetPos)
			 local _, hrp = getCharacterComponents(); if not hrp then return false end
			 destroyFarmMover(); destroyReviveMover()
			 local success, arrived = pcall(function()
				 hrp.Anchored = false; hrp.Velocity, hrp.RotVelocity = Vector3.zero, Vector3.zero
				 reviveAttach = Instance.new("Attachment", hrp)
				 reviveAlignPos = Instance.new("AlignPosition", hrp)
				 reviveAlignPos.Attachment0 = reviveAttach
				 reviveAlignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
				 reviveAlignPos.ApplyAtCenterOfMass = true
				 reviveAlignPos.MaxForce = CONFIG.ALIGN_MAX_FORCE
				 reviveAlignPos.Responsiveness = CONFIG.ALIGN_RESPONSIVENESS
				 reviveAlignPos.Position = targetPos
				 hrp.CFrame = CFrame.new(targetPos)
				 local startTime, currentDist = tick(), (hrp.Position - targetPos).Magnitude
				 while currentDist > 4 and (tick() - startTime) < CONFIG.TELEPORT_TIMEOUT do
					 task.wait()
					 local _, curHrp = getCharacterComponents(); if not curHrp then error("Character invalid during revive TP wait") end
					 currentDist = (curHrp.Position - targetPos).Magnitude
				 end
				 destroyReviveMover()
				 return currentDist <= 4
			 end)
			 if not success then destroyReviveMover(); return false end
			 return arrived
		end
		local function doReviveSequence()
			 local _, hrp = getCharacterComponents(); if not hrp then return end
			 local revivePartsFolder = ReviveWorkspace:FindFirstChild(reviveFolderName); if not revivePartsFolder then return end
			 local prompts = {}
			 for _, obj in ipairs(revivePartsFolder:GetDescendants()) do
				 if obj:IsA("ProximityPrompt") then
					 local partParent = obj.Parent
					 if partParent and partParent:IsA("BasePart") then table.insert(prompts, {prompt = obj, pos = partParent.Position}); pcall(function() obj.HoldDuration = 0 end) end
				 end
			 end
			 if #prompts == 0 then return end
			 for _, data in ipairs(prompts) do
				 if teleportRevive(data.pos + Vector3.new(0, CONFIG.TELEPORT_Y_OFFSET, 0)) then
					 task.wait(CONFIG.WAIT_AFTER_TP)
					 local clickSuccess = pcall(function() if typeof(fireproximityprompt) == "function" then fireproximityprompt(data.prompt) else data.prompt:InputHoldBegin(); task.wait(0.05); data.prompt:InputHoldEnd() end end)
					 task.wait(CONFIG.WAIT_AFTER_CLICK)
				 end
				 local _, curHrp = getCharacterComponents(); if not curHrp then destroyReviveMover(); return end
			 end
			 if returnCFrame then
				 if teleportRevive(returnCFrame.Position) then
					 task.wait(0.1)
					 local _, finalHrp = getCharacterComponents()
					 if finalHrp then pcall(function() finalHrp.CFrame = returnCFrame end) end
					 destroyReviveMover()
					 if autoFarmEnabled and currentFarmingBossName then task.spawn(activateFarm, currentFarmingBossName) end
				 else destroyReviveMover() end
			 else destroyReviveMover() end
		end
		local char, hrp, hum = getCharacterComponents()
		if char and hrp and hum then task.spawn(doReviveSequence)
		else
			local conn; conn = localPlayerRevive.CharacterAdded:Once(function(newChar) local newHum = newChar:WaitForChild("Humanoid", 5); if newHum then task.wait(0.5); if newHum.Health > 0 then task.spawn(doReviveSequence) end end end)
			task.delay(20, function() if conn and conn.Connected then conn:Disconnect() end end)
		end
	end})

	local ballRemovedConnection = Workspace.ChildRemoved:Connect(function(child)
		if child.Name == "Ball" and autoFarmEnabled then
			autoFarmEnabled = false
			if autoFarmToggleObject and autoFarmToggleObject.SetValue then pcall(function() autoFarmToggleObject:SetValue(false) end) end
			deactivateFarm(true)
		end
	end)


--[[-------------------------------------------------------SKINS-------------------------------------------------------]]--

    -- Sword data (mantido)
    local swordsData = {
        { Name = "Drakos", WeldCFrame = CFrame.new(0, -1, -4.2) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(180)) },
        { Name = "Diamond Shardblade", WeldCFrame = CFrame.new(0, -1, -4.3) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(180)) },
        { Name = "Champion Scythe", WeldCFrame = CFrame.new(0, 0, -3.5) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(200)) },
        { Name = "Diamond Aegis", WeldCFrame = CFrame.new(0, -1.5, -5.3) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(180)) },
        { Name = "Demonic Shadow", WeldCFrame = CFrame.new(0, -1, -2.8) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(180)) },
        { Name = "Okiro", WeldCFrame = CFrame.new(0, -0.8, -3) * CFrame.Angles(math.rad(100), math.rad(85), math.rad(180)) },
        { Name = "Divine Shadow", WeldCFrame = CFrame.new(0, -1.5, -6) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(180)) },
        { Name = "Darkness", WeldCFrame = CFrame.new(0, -1, -4.5) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(180)) },
        { Name = "Divine Slayer", WeldCFrame = CFrame.new(0, -1, -4.8) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(180)) },
        { Name = "Amethyst Oblivion", WeldCFrame = CFrame.new(0, -1, -4.3) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(180)) },
        { Name = "Lotus Oblivion", WeldCFrame = CFrame.new(0, -1, -4.3) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(180)) },
        { Name = "Colossal Blazehead", WeldCFrame = CFrame.new(0, -0.4, -4.3) * CFrame.Angles(math.rad(100), math.rad(85), math.rad(180)) },
        { Name = "Enigma", WeldCFrame = CFrame.new(0, -0.9, -2.8) * CFrame.Angles(math.rad(110), math.rad(85), math.rad(180)) },
        { Name = "Cyber Enigma", WeldCFrame = CFrame.new(0.1, -1.3, -2.7) * CFrame.Angles(math.rad(0), math.rad(85), math.rad(-78)) },
        { Name = "Lumina", WeldCFrame = CFrame.new(0, -1, -4.3) * CFrame.Angles(math.rad(92), math.rad(85), math.rad(180)) },
        { Name = "Cyber Hammer", WeldCFrame = CFrame.new(0, -1, -4.3) * CFrame.Angles(math.rad(92), math.rad(85), math.rad(180)) },
        { Name = "Zen Sword", WeldCFrame = CFrame.new(0, -1, -3.5) * CFrame.Angles(math.rad(90), math.rad(85), math.rad(180)) },
    }

    -- Initialize folders
    local swordsFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Swords")
    local activeSwordsFolder = Workspace:FindFirstChild("ActiveSwords") or Instance.new("Folder")
    activeSwordsFolder.Name = "ActiveSwords"; activeSwordsFolder.Parent = Workspace
    local storageFolder = ReplicatedStorage:FindFirstChild("SwordStorage_"..Players.LocalPlayer.UserId) or Instance.new("Folder")
    storageFolder.Name = "SwordStorage_"..Players.LocalPlayer.UserId; storageFolder.Parent = ReplicatedStorage

    -- State variables
    local equippedCustomSwordMap = {}
    local originalSwordFolderName = Players.LocalPlayer.Name .. " SwordWelds"
    local localPlayer = Players.LocalPlayer
    local mainSwordPartName = "Sword"
    local mainSwordWeldName = "Weld"

    -- Helper functions
    local function cleanupCustomPlayerSword(player)
        local oldSword = equippedCustomSwordMap[player]
        if oldSword and oldSword.Parent then pcall(function() oldSword:Destroy() end) end
        equippedCustomSwordMap[player] = nil -- Limpa a referência
    end

    -- Encontra e move para o storage (Pasta OU Itens Soltos) - Mantida como antes
    local function findAndMoveOriginalSwordToStorage()
        local movedSomething = false
        storageFolder:ClearAllChildren()
        local sourceFolder = nil
        for _, child in ipairs(Workspace:GetChildren()) do
            if child.Name == originalSwordFolderName and child:IsA("Folder") and #child:GetChildren() > 0 then
                sourceFolder = child; break
            end
        end
        if sourceFolder then
            for _, potentialDuplicate in ipairs(Workspace:GetChildren()) do
                if potentialDuplicate.Name == originalSwordFolderName and potentialDuplicate:IsA("Folder") and potentialDuplicate ~= sourceFolder then
                    pcall(function() potentialDuplicate:Destroy() end)
                end
            end
            local itemsToMove = sourceFolder:GetChildren()
            for _, item in ipairs(itemsToMove) do item.Parent = storageFolder; movedSomething = true end
            return movedSomething
        end
        local looseItemsToMove = {}
        local looseSwordPart = Workspace:FindFirstChild(mainSwordPartName)
        if looseSwordPart and looseSwordPart.Parent == Workspace and looseSwordPart:IsA("BasePart") then
             table.insert(looseItemsToMove, looseSwordPart)
             local looseWeld = Workspace:FindFirstChild(mainSwordWeldName)
             if looseWeld and looseWeld.Parent == Workspace and looseWeld:IsA("Weld") then
                  table.insert(looseItemsToMove, looseWeld)
             end
        end
        if #looseItemsToMove > 0 then
            for _, item in ipairs(looseItemsToMove) do item.Parent = storageFolder; movedSomething = true end
        end
        return movedSomething
    end

    -- Move de volta para a PASTA, criando-a se necessário - Mantida como antes
    local function moveOriginalSwordBackToFolder()
        local itemsInStorage = storageFolder:GetChildren()
        if #itemsInStorage == 0 then return true end
        local targetFolder = Workspace:FindFirstChild(originalSwordFolderName)
        if not targetFolder or not targetFolder:IsA("Folder") then
             if targetFolder then pcall(function() targetFolder:Destroy() end) end
            targetFolder = Instance.new("Folder")
            targetFolder.Name = originalSwordFolderName
            targetFolder.Parent = Workspace
        end
        local success = false; local itemsMoved = 0
        for _, child in ipairs(itemsInStorage) do
            child.Parent = targetFolder
            if child.Parent == targetFolder then itemsMoved = itemsMoved + 1 end
            task.wait()
        end
        if #storageFolder:GetChildren() == 0 and itemsMoved > 0 then success = true end
        return success
    end


    -- === FUNÇÃO EQUIPAR MODIFICADA ===
    local function equipCustomSword(swordName, weldCFrame)
        if not localPlayer then return end

        local currentlyEquipped = equippedCustomSwordMap[localPlayer]
        local originalWasMoved = false -- Flag para saber se a original FOI movida nesta chamada

        -- ** Passo 1: Guardar a original SOMENTE SE não houver custom equipada **
        if not currentlyEquipped then
            -- Estamos vindo do Default, então precisamos guardar a original
            originalWasMoved = findAndMoveOriginalSwordToStorage()
        -- else: Já tem uma custom equipada, a original já deve estar guardada. NÃO mexa no storage.
        end

        -- ** Passo 2: Limpar a custom ANTERIOR (seja a antiga ou nil se vindo do Default) **
        cleanupCustomPlayerSword(localPlayer) -- Limpa a referência e destrói a instância antiga

        -- ** Passo 3: Tentar criar e equipar a NOVA custom **
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
        if not hand then
            -- Falhou em encontrar a mão: Tenta devolver a original SE ela foi movida nesta chamada
            if originalWasMoved then moveOriginalSwordBackToFolder() end
            return
        end

        local swordModel = swordsFolder:FindFirstChild(swordName)
        local swordPart = swordModel and swordModel:FindFirstChild("Sword")
        if not swordPart then
             -- Falhou em encontrar a skin: Tenta devolver a original SE ela foi movida nesta chamada
            if originalWasMoved then moveOriginalSwordBackToFolder() end
            return
        end

        -- Cria e configura a nova espada
        local newSword = swordPart:Clone(); newSword.Name = localPlayer.Name .. "_CustomSword_" .. swordName
        newSword.Anchored = false; newSword.CanCollide = false; newSword.Massless = true
        for _, part in ipairs(newSword:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false; part.Massless = true; part.Anchored = false end
        end
        local weld = Instance.new("Weld"); weld.Name = "HandWeld"; weld.Part0 = hand; weld.Part1 = newSword
        weld.C0 = weldCFrame; weld.Parent = newSword
        newSword.Parent = activeSwordsFolder

        -- ** Passo 4: Atualizar o mapa com a NOVA espada custom **
        equippedCustomSwordMap[localPlayer] = newSword
    end

    -- Limpeza ao sair (mantida igual, chama moveOriginalSwordBackToFolder)
    Players.PlayerRemoving:Connect(function(player)
        if player == localPlayer then
            local moveSucceeded = moveOriginalSwordBackToFolder() -- Tenta mover para PASTA
            cleanupCustomPlayerSword(player) -- Limpa qualquer custom que possa ter ficado
            if moveSucceeded and storageFolder and storageFolder.Parent then
                storageFolder:ClearAllChildren()
            end
        else
             cleanupCustomPlayerSword(player) -- Limpa custom de outros, se aplicável
        end
    end)

    -- UI (lógica de chamada mantida)
    Tabs.skins:AddSection("Sword")
    local swordOptions = {"Default"}
    for _, sword in ipairs(swordsData) do table.insert(swordOptions, sword.Name) end

    Tabs.skins:AddDropdown("SwordSelector", {
        Title = "Select sword", Values = swordOptions, Default = "Default",
        Callback = function(Value)
            if Value == "Default" then
                cleanupCustomPlayerSword(localPlayer) -- Tira a custom ATUAL
                moveOriginalSwordBackToFolder()    -- Traz a default DE VOLTA do storage
            else
                -- Selecionou uma skin nova (pode ser a primeira ou troca Custom->Custom)
                for _, sword in ipairs(swordsData) do
                    if sword.Name == Value then
                         equipCustomSword(sword.Name, sword.WeldCFrame) -- Chama a função equipar (agora mais inteligente)
                         break
                    end
                end
            end
        end
    })

    -- Limpeza inicial (mantida igual, chama moveOriginalSwordBackToFolder)
    if storageFolder and #storageFolder:GetChildren() > 0 then
         moveOriginalSwordBackToFolder()
    end
    if equippedCustomSwordMap[localPlayer] and (not equippedCustomSwordMap[localPlayer].Parent) then
         equippedCustomSwordMap[localPlayer] = nil
    end

--[[-------------------------------------------------------RAGE-------------------------------------------------------]]--

    -- Exploit compatibility checks
local getGc = getgc
local getInfo = debug.getinfo or getinfo
local getUpvalue = debug.getupvalue or getupvalue or getupval
local getConstants = debug.getconstants or getconstants or getconsts
local isXClosure = is_synapse_function or issentinelclosure or is_protosmasher_closure or is_sirhurt_closure or istempleclosure or checkclosure
local isLClosure = islclosure or is_l_closure or (iscclosure and function(f) return not iscclosure(f) end)

assert(getGc and getInfo and getConstants and isXClosure, "Your exploit is not supported")

-- Closure search function (inlined from aux)
local function searchClosure(script, name, upvalueIndex, constants)
    for _i, v in pairs(getGc()) do
        local parentScript = rawget(getfenv(v), "script")
        if type(v) == "function" and 
           isLClosure(v) and 
           not isXClosure(v) and 
           ((script == nil and parentScript.Parent == nil) or script == parentScript) and 
           pcall(getUpvalue, v, upvalueIndex)
        then
            local closureConstants = getConstants(v)
            local constantsMatch = true
            if constants then
                for index, value in pairs(constants) do
                    if closureConstants[index] ~= value then
                        constantsMatch = false
                        break
                    end
                end
            end
            if constantsMatch and ((name and name ~= "Unnamed function" and getInfo(v).name == name) or (not name or name == "Unnamed function")) then
                return v
            end
        end
    end
    return nil
end

Tabs.rage:AddParagraph({
        Title = "Warning",
        Content = "these features carry a high risk of ban."
    })

-- GUI toggles (assuming Tabs.rage is provided by a UI library)
Tabs.rage:AddToggle("infparry", {
    Title = "Infinite parry",
    Default = false,
    Callback = function(state)
        -- First closure: SetupVisuals
        do
            local scriptPath = game:GetService("Players").LocalPlayer.PlayerGui.PAGES.ShopPage.Centre.ScrollingFrame.VIPSubscription.VIPSubscription
            local closureName = "SetupVisuals"
            local upvalueIndex = 1
            local closureConstants = {
                [1] = "Object",
                [2] = "Button",
                [3] = "TitleLabel",
                [4] = "VIP Subscription",
                [5] = "Text",
                [6] = "DaysLabel"
            }
            local closure = searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
            if closure then
                local value = state and 0.7 or 1.3
                local elementIndex = "DEFLECT_COOLDOWN_TIME"
                local upvalues = getUpvalue(closure, upvalueIndex)
                if upvalues then
                    upvalues[elementIndex] = value
                end
            end
        end

        -- Second closure: numPlayersAndPublicGame
        do
            local scriptPath = game:GetService("ReplicatedStorage").DataBins.PermitData.PermitFunctions
            local closureName = "numPlayersAndPublicGame"
            local upvalueIndex = 3
            local closureConstants = {
                [1] = "IsInGame",
                [2] = "GetAttribute",
                [3] = "IsGameActive",
                [4] = "IsStudio",
                [5] = 0,
                [6] = "NumPlayersInGameAllTime"
            }
            local closure = searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
            if closure then
                local value = state and 0.7 or 2
                local elementIndex = "DEFLECTS_STARTED_WHILE_TARGET_THRESH"
                local upvalues = getUpvalue(closure, upvalueIndex)
                if upvalues then
                    upvalues[elementIndex] = value
                end
            end
        end
    end
})

Tabs.rage:AddToggle("nodashcool", {
    Title = "No dash cooldown",
    Default = false,
    Callback = function(state)
        local scriptPath = game:GetService("ReplicatedFirst").Classes.MovementHandler
        local closureName = "HandleDash"
        local upvalueIndex = 1
        local closureConstants = {
            [1] = "Enum",
            [2] = "UserInputState",
            [3] = "Begin",
            [4] = Enum.UserInputState.Begin,
            [5] = "GetCanDash",
            [6] = "InAir"
        }
        local success, closure = pcall(function()
            return searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
        end)
        if success and closure then
            local value = state and 0 or 1
            local elementIndex = "DashStamina"
            local upvalues = getUpvalue(closure, upvalueIndex)
            if upvalues then
                upvalues[elementIndex] = value
            end
        end
    end
})

Tabs.rage:AddToggle("infjump", {
    Title = "Infinite jump",
    Default = false,
    Callback = function(state)
        local scriptPath = game:GetService("ReplicatedFirst").Classes.MovementHandler
        local closureName = "Unnamed function"
        local upvalueIndex = 1
        local closureConstants = {
            [1] = "BodyForce",
            [2] = "Force"
        }
        local closure = searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
        if closure then
            local value = state and 100000 or 1
            local elementIndex = "ExtraJumpCount"
            local upvalues = getUpvalue(closure, upvalueIndex)
            if upvalues then
                upvalues[elementIndex] = value
            end
        end
    end
})

--[[-------------------------------------------------------SETTINGS-------------------------------------------------------]]--

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("Nova")
SaveManager:SetFolder("Nova/DeathBall")

InterfaceManager:BuildInterfaceSection(Tabs.settings)
SaveManager:BuildConfigSection(Tabs.settings)

Window:SelectTab(1)

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()