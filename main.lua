local module = {}
local Infomation
local TweenService = game:GetService("TweenService")

local Anim = {
	Knockback = Instance.new("Animation"),
	Lying = Instance.new("Animation"),
	GettingUp = Instance.new("Animation"),
}

local AnimId = {
	Knockback = "",
	Lying = "",
	GettingUp = "",
}

Anim.Knockback.AnimationId = AnimId.Knockback
Anim.Lying.AnimationId = AnimId.Lying
Anim.GettingUp.AnimationId = AnimId.GettingUp

function module.Give(Arg)
	
	Infomation = {
		Attacker = Arg["Attacker"],
		Target = Arg["Target"],
		Damage = Arg["Damage"],
		Type = Arg["Type"],
		Effect = Arg["Effect"],
		Sound = Arg["Sound"],
		StunTime = Arg["StunTime"],
	}
	
	local ready, main = pcall(function()
		if not Infomation.Attacker:FindFirstChild("Stun") then
			if Infomation.Type == "Normal" then
				local Humanoid = Infomation.Target.Humanoid
				if Infomation.Attacker then
					local KillerRoot = Infomation.Attacker.HumanoidRootPart
					local TargetRoot = Infomation.Target.HumanoidRootPart
					local BodyGyro = Instance.new("BodyGyro", TargetRoot)
					local BodyPosition = Instance.new("BodyPosition", TargetRoot)
					for i, bp in ipairs(TargetRoot:GetChildren()) do
						if bp:IsA("BodyPosition") or bp:IsA("BodyGyro") then
							bp:Destroy()
						end
					end
					BodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
					BodyGyro.P = 5000
					BodyGyro.CFrame = CFrame.new(TargetRoot.Position, KillerRoot.Position)
					game.Debris:AddItem(BodyGyro, .5)
					BodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					BodyPosition.P = 999
					BodyPosition.D = 170
					BodyPosition.Position = KillerRoot.Position + KillerRoot.CFrame.LookVector * 7.8
					game.Debris:AddItem(BodyPosition, .57)	
				end
				Humanoid:TakeDamage(Infomation.Damage)
				local Stun = Instance.new("BoolValue", Infomation.Target)
				Stun.Name = "Stun"
				if Infomation.StunTime then
					game.Debris:AddItem(Stun, Infomation.StunTime)
				else
					game.Debris:AddItem(Stun, 1)
				end
			elseif Infomation.Type == "Knockback" then
				local Defloor = false
				local BodyVelocity = Instance.new("BodyVelocity", Infomation.Target.HumanoidRootPart)
				local List = {} -- do ur self
				local Raycast = nil
				local Parma = RaycastParams.new()
				local Lying = Infomation.Target.Humanoid:LoadAnimation(Anim.Lying)
				local Knockback = Infomation.Target.Humanoid:LoadAnimation(Anim.Knockback)
				local Stun = Instance.new("BoolValue", Infomation.Target)
				local Tween = TweenService:Create(BodyVelocity, TweenInfo.new(1.8), {Velocity = Vector3.new(0,0,0)})
				for i, bool in ipairs(Infomation.Target:GetChildren()) do
					if bool.Name == "Stun" then
						bool:Destroy()
					end
				end 
				for i, hrp in ipairs(Infomation.Target.HumanoidRootPart:GetChildren()) do
					if hrp:IsA("BodyPosition") or hrp:IsA("BodyVelocity") then
						hrp:Destroy()
					end
				end
				Knockback:Play()
				Stun.Name = "Stun"
				BodyVelocity.MaxForce = Vector3.new(150000, 150000, 150000)
				BodyVelocity.P = 155
				BodyVelocity.Velocity = Infomation.Target.HumanoidRootPart.CFrame.LookVector * - 70
				Infomation.Target.HumanoidRootPart:SetNetworkOwner(nil)
				Parma.FilterType = Enum.RaycastFilterType.Exclude
				Parma.FilterDescendantsInstances = List
				task.wait(Arg["Time"])
				repeat task.wait()
					if not Infomation.Target:FindFirstChild("HumanoidRootPart") then
						Defloor = true
						Knockback:Stop()
					end
					Raycast = workspace:Raycast(Infomation.Target.HumanoidRootPart.Position, Infomation.Target.HumanoidRootPart.CFrame.UpVector * -5, Parma)
					if Raycast then
						Knockback:Stop()
						Lying:Play()
						Defloor = true
						BodyVelocity.MaxForce = Vector3.new(150000, 0, 150000)
						BodyVelocity.Velocity = Infomation.Target.HumanoidRootPart.CFrame.LookVector * - 77
						Tween:Play()
						Tween.Completed:Wait()
						BodyVelocity:Destroy()
						task.wait(1.5)
						Lying:Stop()
						Infomation.Target.Humanoid:LoadAnimation(Anim.GettingUp):Play()
						Stun:Destroy()
						local Highlight = Instance.new("Highlight", Infomation.Target)
						Highlight.Adornee = Infomation.Target
						Highlight.OutlineTransparency = 0
						Highlight.FillTransparency = 0
						Highlight.FillColor = Color3.new(1,1,1)
						Highlight.OutlineColor = Color3.new(1,1,1)
						game.Debris:AddItem(Highlight, 2)
						task.spawn(function()
							for i = 1, 2 do
								TweenService:Create(Highlight, TweenInfo.new(.01), {FillTransparency = 1}):Play()
								task.wait(.09)
								TweenService:Create(Highlight, TweenInfo.new(.01), {FillTransparency = 0.01}):Play()
								task.wait(.09)	
							end
							TweenService:Create(Highlight, TweenInfo.new(.11), {FillTransparency = 1}):Play()
							TweenService:Create(Highlight, TweenInfo.new(1), {OutlineTransparency = 1}):Play()
						end)
					end
				until Defloor == true
			end
		end
	end)
	if not ready then
		error("Print Error"..ready)
	end
end

return module
