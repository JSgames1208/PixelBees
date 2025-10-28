--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.util.Types)

local BeeAI = {}
BeeAI.__index = BeeAI
BeeAI.states = {}

type BeeAI = Types.BeeAI & typeof(setmetatable({}, BeeAI))

type Bee = Types.Bee
type BeeState = Types.BeeState

function BeeAI.new(bee: Bee): BeeAI
	local self = setmetatable({}, BeeAI) :: BeeAI
	self.bee = bee
	self.state = "idle"
	self.speed = 20
	self.maxDistance = 50
	self.maxHeight = 10
	self.timeInState = 0
	self.timeOut = 0
	self.changeDirection = false
	self.restRotation = self:getPrimaryPart().CFrame.Rotation
	return self
end

function BeeAI.step(self: BeeAI, dt: number): ()
	if not self.bee.model then
		return
	end
	self.timeInState += dt
	if self.states[self.state] then
		self.states[self.state](self, dt)
	else
		error("Unknown state: " .. self.state)
	end
end

function BeeAI.waitFor(self: BeeAI, seconds: number): ()
	self.timeOut = os.time() + seconds
end

function BeeAI.onTimeOut(self: BeeAI): boolean
	return os.time() < self.timeOut
end

function BeeAI.setState(self: BeeAI, state: BeeState): ()
	self.destination = nil
	self.state = state
	self.timeInState = 0
end

function BeeAI.getPlayerPos(self: BeeAI): Vector3
	local player = self.bee.player
	local character = player.Character or player.CharacterAdded:Wait()
	local primaryPart = character.PrimaryPart
	if not primaryPart then
		return Vector3.zero
	end

	local playerPos = primaryPart.Position
	return playerPos
end

function BeeAI.getPrimaryPart(self: BeeAI): BasePart
	local model = self.bee.model
	local primaryPart = model.PrimaryPart
	if not primaryPart then
		error("Primary part not found")
	end
	return primaryPart
end

function BeeAI.getPosAroundPlayer(self: BeeAI): Vector3
	local playerPos = self:getPlayerPos()
	local randomOffset = Vector3.new(
		(math.random() * 2 - 1) * self.maxDistance,
		math.random() * self.maxHeight,
		(math.random() * 2 - 1) * self.maxDistance
	)
	return playerPos + randomOffset
end

function BeeAI.isCloseToPlayer(self: BeeAI): boolean
	local playerPos = self:getPlayerPos()
	local primaryPart = self:getPrimaryPart()
	local beePos = primaryPart.Position
	local distance = (playerPos - beePos).Magnitude
	return distance <= math.sqrt(2) * self.maxDistance
end

function BeeAI.destinationReached(self: BeeAI): ()
	self.destination = nil
	if self.state == "idle" then
		self:waitFor(1 + 3 * math.random())
	elseif self.state == "moveToCollect" then
		local tilt = math.rad(-45)
		self.restRotation = self.restRotation * CFrame.Angles(tilt, 0, 0)
		self:setState("collect")
	end
end

function BeeAI.jiggle(self: BeeAI, dt: number): ()
	local model = self.bee.model
	local primaryPart = model.PrimaryPart

	if not primaryPart then
		return
	end

	self.bee.model:PivotTo(
		CFrame.new(primaryPart.Position) * self.restRotation * CFrame.Angles(0, 0, math.rad(math.sin(tick() * 15) * 5))
	)
end

function BeeAI.move(self: BeeAI, dt: number): ()
	-- Move

	local model = self.bee.model
	local primaryPart = model.PrimaryPart
	if not primaryPart then
		return
	end
	if not self.destination then
		return
	end

	local distance = (self.destination - primaryPart.Position).Magnitude
	if distance > self.speed * dt then
		local direction = (self.destination - primaryPart.Position).Unit
		self.restRotation = CFrame.lookAlong(primaryPart.Position, direction).Rotation
		model:PivotTo(CFrame.new(primaryPart.Position + direction * self.speed * dt) * self.restRotation)
	else
		model:PivotTo(CFrame.new(self.destination) * primaryPart.CFrame.Rotation)
		self:destinationReached()
	end
end

function BeeAI.states.idle(self: BeeAI, dt: number): ()
	-- Idle
	local primaryPart = self.bee.model.PrimaryPart
	if not primaryPart then
		return
	end

	if self.bee.swarm.fieldId then
		if math.random() < 0.0005 then
			self.setState(self, "moveToCollect")
			return
		end
	end

	local playerPos = self:getPlayerPos()

	if not self:isCloseToPlayer() then
		self.destination = playerPos
		self.changeDirection = true
		self:move(dt)
	elseif not self:onTimeOut() then
		if self.changeDirection and self:isCloseToPlayer() then
			self.changeDirection = false
			self.destination = self:getPosAroundPlayer()
		end
		if not self.destination or self.changeDirection then
			self.destination = self:getPosAroundPlayer()
		end
		self:move(dt)
	end

	self:jiggle(dt)
end

function BeeAI.states.moveToCollect(self: BeeAI, dt: number): ()
	-- Move to flower where it will collect
	local fieldId = self.bee.swarm.fieldId
	if not fieldId and not self.harvestFieldId then
		self.setState(self, "idle")
	end
	if not self.destination and fieldId then
		local fieldService = self.bee.swarm.fieldService
		local flower = fieldService:findRandom(fieldId)
		if flower then
			flower.occupied = true
			self.harvestFlower = flower
			self.harvestFieldId = fieldId
			local field = fieldService:getField(fieldId)
			local basePos = field.data.position - Vector3.new(field.data.size.X / 2, 0, field.data.size.Y / 2)

			self.destination = basePos + Vector3.new((flower.position.X - 0.5) * 4, 2.5, (flower.position.Y - 0.5) * 4)
		else
			self:setState("idle")
		end
	elseif self.destination then
		self:move(dt)
	end

	self:jiggle(dt)
end

function BeeAI.states.collect(self: BeeAI, dt: number): ()
	if self.timeInState > 3 then
		local fieldService = self.bee.swarm.fieldService
		if not self.harvestFieldId or not self.harvestFlower then
			return
		end
		fieldService:collectFlower(self.bee.player, self.harvestFieldId, self.harvestFlower)

		self.harvestFlower.occupied = false
		self.harvestFieldId = nil
		self.harvestFlower = nil
		self:setState("idle")
		return
	end

	self:jiggle(dt)
end

return BeeAI
