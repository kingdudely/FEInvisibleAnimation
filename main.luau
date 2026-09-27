local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Humanoid.RootPart
local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)

local Animations = {
	[9391468976] = {
		TimePosition = 6.7,
		AnimationId = "rbxassetid://108081843941348",
	},
	[10449761463] = {
		TimePosition = 6.7,
		AnimationId = "rbxassetid://18462892217"
	}
}

local AnimationConfiguration = Animations[game.PlaceId]

if not AnimationConfiguration then
    -- warn
	StarterGui:SetCore("SendNotification", {
        Title = "Invisibility",
        Text = "Invisibility not configured for this game.",
        Duration = math.huge,
        Callback = Instance.new("BindableFunction"),
        Button1 = "Close",
    })
	return
end

-- Keep HRP visible
HumanoidRootPart.Transparency = 0
HumanoidRootPart.LocalTransparencyModifier = 0

HumanoidRootPart:GetPropertyChangedSignal("Transparency", function()
	HumanoidRootPart.Transparency = 0
end)

HumanoidRootPart:GetPropertyChangedSignal("LocalTransparencyModifier", function()
	HumanoidRootPart.LocalTransparencyModifier = 0
end)

-- Camera follows HRP
CurrentCamera.CameraType = Enum.CameraType.Custom
CurrentCamera.CameraSubject = HumanoidRootPart

-- Make every other BasePart non-collidable and massless
for _, Part in Character:QueryDescendants("BasePart") do
	if Part ~= HumanoidRootPart then
		Part.CanCollide = false
		Part.Massless = true
	end
end

-- Create animation
local Animation = Instance.new("Animation")
Animation.AnimationId = AnimationConfiguration.AnimationId

local AnimationTrack = Animator:LoadAnimation(Animation)
AnimationTrack.Priority = Enum.AnimationPriority.Action4

local function PlayAnimationTrack()
    if not AnimationTrack.IsPlaying then
        AnimationTrack:Play(0)
		AnimationTrack.TimePosition = AnimationConfiguration.TimePosition
        AnimationTrack:AdjustSpeed(0)
    end
end

local function StopOtherAnimationTrack(PlayingAnimationTrack)
	if PlayingAnimationTrack ~= AnimationTrack then
		PlayingAnimationTrack:Stop(0)
		PlayAnimationTrack()
	end
end

-- Stop existing animations
for _, PlayingAnimationTrack in Animator:GetPlayingAnimationTracks() do
	StopOtherAnimationTrack(PlayingAnimationTrack)
end

-- Stop animations that try to start afterward
Animator.AnimationPlayed:Connect(StopOtherAnimationTrack)

-- Play at the configured point and freeze
PlayAnimationTrack()
