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

-- Camera follows HRP
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

-- Stop existing animations
for _, PlayingAnimationTrack in Animator:GetPlayingAnimationTracks() do
	if PlayingAnimationTrack ~= AnimationTrack then
		PlayingAnimationTrack:Stop(0)
	end
end

-- Stop animations that try to start afterward
Animator.AnimationPlayed:Connect(function(PlayingAnimationTrack)
	if PlayingAnimationTrack ~= AnimationTrack then
		PlayingAnimationTrack:Stop(0)
	end
end)

-- Play at the configured point and freeze
AnimationTrack:Play(0)
AnimationTrack.TimePosition = AnimationConfiguration.TimePosition
AnimationTrack:AdjustSpeed(0)
