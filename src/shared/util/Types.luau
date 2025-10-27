--!strict

local Types = {}

-------------------------
-- Services
-------------------------

export type FieldService = {
	-- Properties
	fields: { [string]: any },
	generator: FieldGenerator,
	flowerCollection: FlowerCollection,
	playerService: PlayerService,
	toolService: ToolService,
	replenishConnection: RBXScriptConnection?,

	-- Methods
	new: () -> FieldService,
	getInstance: () -> FieldService,
	start: (self: FieldService) -> FieldService,
	update: (self: FieldService, dt: number) -> (),
	getField: (self: FieldService, fieldId: string) -> any,
	setField: (self: FieldService, fieldId: string, fieldData: any) -> (),
	setFields: (self: FieldService, fieldsData: { [string]: any }) -> (),
	getPlayerField: (self: FieldService, player: Player) -> any,
	collect: (self: FieldService, player: Player) -> (),
	replenish: (self: FieldService) -> (),
	startReplenish: (self: FieldService) -> (),
}

export type PlayerService = {
	-- Define properties and methods of PlayerService here
	fieldService: FieldService,
	toolService: ToolService,
	swarmService: SwarmService,

	playerEntities: { [number]: PlayerEntity },

	new: () -> PlayerService,
	start: (self: PlayerService) -> PlayerService,
	getInstance: () -> PlayerService,
	onPlayerAdded: (self: PlayerService, player: Player) -> (),
	onPlayerRemoving: (self: PlayerService, player: Player) -> (),
	update: (self: PlayerService, dt: number) -> (),
	getPlayerEntity: (self: PlayerService, player: Player) -> PlayerEntity,
}

export type ToolService = {
	-- Define properties and methods of ToolService here
	fieldService: FieldService,
	playerService: PlayerService,

	new: () -> ToolService,
	getInstance: () -> ToolService,
	start: (self: ToolService) -> ToolService,
	getPlayerTool: (self: ToolService, player: Player) -> PlayerTool,
	playerTools: { [number]: PlayerTool },
	onPlayerAdded: (self: ToolService, player: Player) -> (),
	equip: (self: ToolService, player: Player, toolId: string) -> (),
}

-------------------------
-- Field
-------------------------

export type FieldGenerator = {
	new: () -> FieldGenerator,
	getInstance: () -> FieldGenerator,

	generateField: (fieldData: FieldData) -> Field,
	generateFields: () -> { [string]: Field },
	generateModel: (field: Field) -> Model,
}

export type Field = {
	-- Define properties and methods of Field here
	data: FieldData,
	state: FieldState,

	model: Model?,
	toReplenish: { string },

	new: (id: string, data: any) -> Field,
	setModel: (self: Field, model: Model) -> (),
	populate: (self: Field, flowers: { [string]: Flower }) -> (),
	containsPosition: (self: Field, position: Vector3) -> boolean,
	replenish: (self: Field) -> (),
	harvest: (self: Field, flowerKey: string, amount: number) -> (),
}

export type FieldData = {
	-- Define properties of FieldData here
	id: string,
	name: string,
	size: Vector2,
	position: Vector3,
	chance: FlowerChance,

	new: (id: string, name: string, size: Vector2, position: Vector3) -> FieldData,
}

export type FieldState = {
	-- Define properties and methods of FieldState here
	flowers: { [string]: Flower },

	new: () -> FieldState,
	getFlowerStateAt: (self: FieldState, x: number, y: number) -> (string, string),
	populate: (self: FieldState, flowers: { [string]: Flower }) -> (),
}

export type Flower = {
	-- Define properties and methods of Flower here
	color: string,
	size: string,
	harvested: number,

	new: (id: string, data: any) -> Flower,
	harvest: (self: Flower, amount: number) -> (),
	replenish: (self: Flower, amount: number) -> (),
}

export type FlowerChance = {
	-- Define properties and methods of FlowerChance here
	colors: { [string]: number },
	sizes: { [string]: number },

	new: () -> FlowerChance,
	getChance: (self: FlowerChance, flowerType: string) -> number,
}

export type FlowerCollection = {
	-- Define properties and methods of FlowerCollection here
	fieldService: FieldService,
	playerService: PlayerService,

	new: () -> FlowerCollection,
	getInstance: () -> FlowerCollection,
	start: (self: FlowerCollection) -> FlowerCollection,
	getTouchingParts: (part: BasePart) -> { BasePart },
	collect: (player: Player) -> (),
}

-------------------------
-- Player
-------------------------

export type PlayerEntity = {
	-- Define properties and methods of PlayerEntity here
	player: Player,
	character: Model?,
	collider: BasePart,
	heartbeatConnection: RBXScriptConnection?,

	start: (self: PlayerEntity) -> PlayerEntity,
	getPlayer: (self: PlayerEntity) -> Player,
	setCollider: (self: PlayerEntity, collider: BasePart) -> (),
	updateCollider: (self: PlayerEntity) -> (),
	getCollider: (self: PlayerEntity) -> BasePart,

	new: (player: Player) -> PlayerEntity,
}

export type PlayerTool = {
	player: Player,
	tool: Tool?,
	toolName: string,
	lastUsed: number?,
	useConnection: RBXScriptConnection?,
	cooldown: number,

	fieldService: FieldService,
	playerService: PlayerService,

	new: (tool: Tool) -> PlayerTool,
	equip: (self: PlayerTool, tool: Tool) -> (),
	isEquipped: (self: PlayerTool) -> boolean,
	getTool: (self: PlayerTool) -> Tool,
	setTool: (self: PlayerTool, tool: Tool) -> (),
	setLastUsed: (self: PlayerTool, timestamp: number) -> (),
	getLastUsed: (self: PlayerTool) -> number?,
	use: (self: PlayerTool) -> (),
	destroy: (self: PlayerTool) -> (),
}

-------------------------
-- Bee
-------------------------

export type SwarmService = {
	-- Define properties and methods of BeeService here
	swarms: { [number]: Swarm },

	new: () -> SwarmService,
	getInstance: () -> SwarmService,
	start: (self: SwarmService) -> SwarmService,
	update: (self: SwarmService, dt: number) -> (),
	onPlayerAdded: (self: SwarmService, player: Player) -> (),

	addSwarm: (self: SwarmService, player: Player) -> Swarm,
	getSwarm: (self: SwarmService, player: Player) -> Swarm,
	removeSwarm: (self: SwarmService, swarm: Swarm) -> (),
}

export type Swarm = {
	-- Define properties and methods of Swarm here
	player: Player,
	bees: { [string]: Bee },

	new: () -> Swarm,
	addBee: (self: Swarm, beeType: string) -> (),
	removeBee: (self: Swarm, bee: Bee) -> (),
	update: (self: Swarm, dt: number) -> (),
	destroy: (self: Swarm) -> (),
	size: (self: Swarm) -> number,
}

export type Bee = {
	-- Define properties and methods of Bee here
	player: Player,
	model: Model,
	ai: BeeAI,
	type: string,
	index: number,
	name: string,
	id: string,

	new: (player: Player, model: Model) -> Bee,
	update: (self: Bee, dt: number) -> (),
	destroy: (self: Bee) -> (),

	getFolder: (self: Bee) -> Folder,
	generateId: (self: Bee) -> string,
	loadModel: (self: Bee) -> Model,
	getId: (self: Bee) -> string,
}

export type BeeAI = {
	-- Define properties and methods of BeeAI here
	bee: Bee,
	speed: number,
	state: BeeState,
	maxDistance: number,
	maxHeight: number,
	timeInState: number,
	destination: Vector3?,
	timeOut: number,
	changeDirection: boolean,
	restRotation: CFrame,

	new: (bee: Bee) -> BeeAI,
	step: (self: BeeAI, dt: number) -> (),
	setState: (self: BeeAI, state: string) -> (),
	waitFor: (self: BeeAI, seconds: number) -> (),
	onTimeOut: (self: BeeAI) -> boolean,
	getPosAroundPlayer: (self: BeeAI) -> Vector3,
	getPlayerPos: (self: BeeAI) -> Vector3,
	isCloseToPlayer: (self: BeeAI) -> boolean,
	move: (self: BeeAI, dt: number) -> (),
	states: {
		idle: (self: BeeAI, dt: number) -> (),
		collect: (self: BeeAI, dt: number) -> (),
	},
}

export type BeeState = "idle" | "collect"

-------------------------
-- Game
-------------------------

export type Game = {
	-- Define properties and methods of Game here

	fieldService: FieldService,
	toolService: ToolService,
	playerService: PlayerService,
	swarmService: SwarmService,

	new: () -> Game,
	startServices: (self: Game) -> (),
	start: (self: Game) -> Game,
	run: (self: Game) -> Game,
	update: (self: Game, dt: number) -> (),
}

return Types
